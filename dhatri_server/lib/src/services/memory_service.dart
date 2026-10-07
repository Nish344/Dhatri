import 'package:serverpod/serverpod.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';

import '../generated/protocol.dart';

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

class RecencyMemoryService implements MemoryService {
  @override
  Future<List<PatientMemory>> retrieve(
    Session session,
    int patientId,
    String query, {
    int k = 3,
  }) async {
    return PatientMemory.db.find(
      session,
      where: (t) => t.patientId.equals(patientId) & t.kind.equals('symptom'),
      orderBy: (t) => t.createdAt.desc(),
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
  ) async {
    await PatientMemory.db.insertRow(
      session,
      PatientMemory(
        patientId: patientId,
        kind: kind,
        content: content,
        sourceCheckId: checkId,
        embedding: embedding,
      ),
    );
  }
}

class VectorMemoryService implements MemoryService {
  VectorMemoryService({this.maxDistance = 1.0});

  final double maxDistance;

  @override
  Future<List<PatientMemory>> retrieve(
    Session session,
    int patientId,
    String query, {
    int k = 3,
  }) async {
    final queryVec = _placeholderEmbed(query);
    final rows = await PatientMemory.db.find(
      session,
      where: (t) => t.patientId.equals(patientId),
      orderByList: (t) => [t.embedding.distanceCosine(queryVec).asc()],
      limit: k,
    );
    return rows;
  }

  @override
  Future<void> remember(
    Session session,
    int patientId,
    String kind,
    String content,
    int checkId,
    Vector embedding,
  ) async {
    await PatientMemory.db.insertRow(
      session,
      PatientMemory(
        patientId: patientId,
        kind: kind,
        content: content,
        sourceCheckId: checkId,
        embedding: embedding,
      ),
    );
  }

  /// Tests and callers pass [queryVec] via a dedicated overload in tests.
  Future<List<PatientMemory>> retrieveWithVector(
    Session session,
    int patientId,
    Vector queryVec, {
    int k = 3,
  }) async {
    return PatientMemory.db.find(
      session,
      where: (t) => t.patientId.equals(patientId),
      orderByList: (t) => [t.embedding.distanceCosine(queryVec).asc()],
      limit: k,
    );
  }

  Vector _placeholderEmbed(String query) => Vector(List.filled(768, 0.0));
}
