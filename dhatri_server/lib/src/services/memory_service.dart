import 'dart:io';
import 'dart:math' show min;

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'gemini.dart';

abstract class MemoryService {
  Future<List<PatientMemory>> retrieve(
    Session session,
    int patientId,
    String query, {
    int k = 3,
  });

  /// Store [content] only when it adds new information vs existing memories.
  Future<bool> remember(
    Session session,
    int patientId,
    String kind,
    String content,
    int checkId,
    Vector embedding,
  );
}

/// `MEMORY_MODE=recency` falls back to SQL recency when pgvector is missing.
MemoryService memoryServiceFor(Gemini gemini) =>
    Platform.environment['MEMORY_MODE'] == 'recency'
    ? RecencyMemoryService()
    : VectorMemoryService(
        embedQuery: (q) async => Vector(await gemini.embed(q, query: true)),
      );

/// Cosine distance below which two notes are treated as the same fact.
const nearDuplicateDistance = 0.18;

String _normalize(String s) => s
    .toLowerCase()
    .replaceAll(RegExp(r'[^a-z0-9\s]'), ' ')
    .replaceAll(RegExp(r'\s+'), ' ')
    .trim();

bool _textNearDuplicate(String a, String b) {
  final na = _normalize(a);
  final nb = _normalize(b);
  if (na.isEmpty || nb.isEmpty) return false;
  if (na == nb) return true;
  if (na.contains(nb) || nb.contains(na)) return true;
  // Shared token overlap for short clinical notes.
  final ta = na.split(' ').where((t) => t.length > 2).toSet();
  final tb = nb.split(' ').where((t) => t.length > 2).toSet();
  if (ta.isEmpty || tb.isEmpty) return false;
  final inter = ta.intersection(tb).length;
  final union = ta.union(tb).length;
  return union > 0 && inter / union >= 0.72;
}

Future<void> _insert(
  Session session,
  int patientId,
  String kind,
  String content,
  int checkId,
  Vector embedding,
) => PatientMemory.db.insertRow(
  session,
  PatientMemory(
    patientId: patientId,
    kind: kind,
    content: content,
    sourceCheckId: checkId,
    embedding: embedding,
  ),
);

class RecencyMemoryService implements MemoryService {
  @override
  Future<List<PatientMemory>> retrieve(
    Session session,
    int patientId,
    String query, {
    int k = 3,
  }) async {
    final rows = await PatientMemory.db.find(
      session,
      where: (t) => t.patientId.equals(patientId) & t.kind.equals('symptom'),
      orderBy: (t) => t.createdAt.desc(),
      limit: k * 3,
    );
    return _dedupeRetrieved(rows, k);
  }

  @override
  Future<bool> remember(
    Session session,
    int patientId,
    String kind,
    String content,
    int checkId,
    Vector embedding,
  ) async {
    final recent = await PatientMemory.db.find(
      session,
      where: (t) => t.patientId.equals(patientId),
      orderBy: (t) => t.createdAt.desc(),
      limit: 40,
    );
    for (final m in recent) {
      if (_textNearDuplicate(m.content, content)) {
        session.log(
          'memory.skipDuplicate patient=$patientId '
          'existingId=${m.id} text="${content.substring(0, min(60, content.length))}"',
        );
        return false;
      }
    }
    await _insert(session, patientId, kind, content, checkId, embedding);
    return true;
  }
}

class VectorMemoryService implements MemoryService {
  VectorMemoryService({required this.embedQuery, this.maxDistance = 0.5});

  final Future<Vector> Function(String query) embedQuery;

  /// Cosine distance above which a memory is treated as unrelated for recall.
  final double maxDistance;

  @override
  Future<List<PatientMemory>> retrieve(
    Session session,
    int patientId,
    String query, {
    int k = 3,
  }) async {
    final queryVec = await embedQuery(query);
    final since = DateTime.now().toUtc().subtract(const Duration(days: 60));
    final rows = await PatientMemory.db.find(
      session,
      where: (t) =>
          t.patientId.equals(patientId) &
          (t.createdAt > since) &
          (t.embedding.distanceCosine(queryVec) < maxDistance),
      orderBy: (t) => t.embedding.distanceCosine(queryVec),
      limit: k * 3,
    );
    return _dedupeRetrieved(rows, k);
  }

  @override
  Future<bool> remember(
    Session session,
    int patientId,
    String kind,
    String content,
    int checkId,
    Vector embedding,
  ) async {
    final since = DateTime.now().toUtc().subtract(const Duration(days: 60));
    // Prefer vector near-dupes; fall back to text overlap.
    final near = await PatientMemory.db.find(
      session,
      where: (t) =>
          t.patientId.equals(patientId) &
          (t.createdAt > since) &
          (t.embedding.distanceCosine(embedding) < nearDuplicateDistance),
      orderBy: (t) => t.embedding.distanceCosine(embedding),
      limit: 3,
    );
    if (near.isNotEmpty) {
      session.log(
        'memory.skipNearDup patient=$patientId '
        'existingId=${near.first.id} dist~vec '
        'text="${content.substring(0, min(60, content.length))}"',
      );
      return false;
    }

    final recent = await PatientMemory.db.find(
      session,
      where: (t) => t.patientId.equals(patientId) & (t.createdAt > since),
      orderBy: (t) => t.createdAt.desc(),
      limit: 30,
    );
    for (final m in recent) {
      if (_textNearDuplicate(m.content, content)) {
        session.log(
          'memory.skipTextDup patient=$patientId existingId=${m.id}',
        );
        return false;
      }
    }

    await _insert(session, patientId, kind, content, checkId, embedding);
    session.log(
      'memory.store patient=$patientId kind=$kind '
      'text="${content.substring(0, min(80, content.length))}"',
    );
    return true;
  }
}

/// Keep at most [k] memories that are not near-copies of each other.
List<PatientMemory> _dedupeRetrieved(List<PatientMemory> rows, int k) {
  final out = <PatientMemory>[];
  for (final row in rows) {
    final dup = out.any(
      (kept) => _textNearDuplicate(kept.content, row.content),
    );
    if (!dup) out.add(row);
    if (out.length >= k) break;
  }
  return out;
}
