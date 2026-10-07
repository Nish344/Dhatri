import 'package:dhatri_server/src/generated/protocol.dart';
import 'package:dhatri_server/src/services/memory_service.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'fixtures.dart';
import 'test_tools/serverpod_test_tools.dart';

/// Unit vector pointing mostly along [axis], so cosine distance is meaningful.
Vector _vec(int axis, [double lean = 0]) {
  final v = List<double>.filled(768, 0.0);
  v[axis] = 1;
  v[(axis + 1) % 768] = lean;
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
        _vec(0),
      );
      await mem.remember(
        session,
        b.id!,
        'symptom',
        'other patient note',
        2,
        _vec(0),
      );

      final forA = await mem.retrieve(session, a.id!, 'weak');
      expect(forA.every((m) => m.patientId == a.id), isTrue);
      expect(forA.any((m) => m.content.contains('weakness')), isTrue);
    });

    test('vector retrieval returns the nearest memory, own patient only, '
        'and drops unrelated ones', () async {
      final session = sessionBuilder.build();
      final patient = await insertProfile(
        session,
        authUserId: 'mem-v',
        name: 'Ramesh',
        role: Role.patient,
      );
      final other = await insertProfile(
        session,
        authUserId: 'mem-v-other',
        name: 'Sita',
        role: Role.patient,
      );
      // "I feel weak again" embeds close to axis 0.
      final mem = VectorMemoryService(embedQuery: (_) async => _vec(0, 0.1));
      await mem.remember(
        session,
        patient.id!,
        'symptom',
        'Patient reported weakness',
        1,
        _vec(0),
      );
      await mem.remember(
        session,
        patient.id!,
        'note',
        'Unrelated appetite note',
        2,
        _vec(5),
      );
      await mem.remember(
        session,
        other.id!,
        'symptom',
        'Other patient weakness',
        3,
        _vec(0),
      );

      final hits = await mem.retrieve(
        session,
        patient.id!,
        'I feel weak again',
      );
      expect(hits.map((m) => m.content), ['Patient reported weakness']);
    });
  });
}
