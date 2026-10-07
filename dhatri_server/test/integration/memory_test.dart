import 'package:dhatri_server/src/generated/protocol.dart';
import 'package:dhatri_server/src/services/memory_service.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:test/test.dart';

import 'fixtures.dart';
import 'test_tools/serverpod_test_tools.dart';

Vector _vec(double first) {
  final v = List<double>.filled(768, 0.0);
  v[0] = first;
  return Vector(v);
}

void main() {
  withServerpod('Patient memory', (sessionBuilder, _) {
    test('recency retrieval is scoped per patient', () async {
      final session = sessionBuilder.build();
      final a = await insertProfile(
        session,
        authUserId: 'mem-a',
        name: 'A',
        role: Role.patient,
      );
      final b = await insertProfile(
        session,
        authUserId: 'mem-b',
        name: 'B',
        role: Role.patient,
      );
      final mem = RecencyMemoryService();
      await mem.remember(
        session,
        a.id!,
        'symptom',
        'weakness week 1',
        1,
        _vec(1),
      );
      await mem.remember(
        session,
        b.id!,
        'symptom',
        'other patient note',
        2,
        _vec(2),
      );

      final forA = await mem.retrieve(session, a.id!, 'weak');
      expect(forA.every((m) => m.patientId == a.id), isTrue);
      expect(forA.any((m) => m.content.contains('weakness')), isTrue);
    });

    test('vector retrieval returns nearest weakness memory', () async {
      final session = sessionBuilder.build();
      final patient = await insertProfile(
        session,
        authUserId: 'mem-v',
        name: 'Ramesh',
        role: Role.patient,
      );
      final vectorMem = VectorMemoryService();
      await vectorMem.remember(
        session,
        patient.id!,
        'symptom',
        'Patient reported weakness',
        1,
        _vec(1.0),
      );
      await vectorMem.remember(
        session,
        patient.id!,
        'note',
        'Unrelated appetite note',
        2,
        _vec(0.1),
      );

      final hits = await vectorMem.retrieveWithVector(
        session,
        patient.id!,
        _vec(0.95),
        k: 2,
      );
      expect(hits.first.content, contains('weakness'));
    });
  });
}
