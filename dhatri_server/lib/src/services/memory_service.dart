import 'dart:io';

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

  Future<void> remember(
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
  }) => PatientMemory.db.find(
    session,
    where: (t) => t.patientId.equals(patientId) & t.kind.equals('symptom'),
    orderBy: (t) => t.createdAt.desc(),
    limit: k,
  );

  @override
  Future<void> remember(
    Session session,
    int patientId,
    String kind,
    String content,
    int checkId,
    Vector embedding,
  ) => _insert(session, patientId, kind, content, checkId, embedding);
}

class VectorMemoryService implements MemoryService {
  VectorMemoryService({required this.embedQuery, this.maxDistance = 0.5});

  final Future<Vector> Function(String query) embedQuery;

  /// Cosine distance above which a memory is treated as unrelated.
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
    return PatientMemory.db.find(
      session,
      where: (t) =>
          t.patientId.equals(patientId) &
          (t.createdAt > since) &
          (t.embedding.distanceCosine(queryVec) < maxDistance),
      orderBy: (t) => t.embedding.distanceCosine(queryVec),
      limit: k,
    );
  }

  @override
  Future<void> remember(
    Session session,
    int patientId,
    String kind,
    String content,
    int checkId,
    Vector embedding,
  ) => _insert(session, patientId, kind, content, checkId, embedding);
}
