import 'package:dhatri_server/src/generated/protocol.dart';
import 'package:dhatri_server/src/services/demo_seed.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Demo seed', (sessionBuilder, _) {
    test('seed inserts Ramesh history and memories; reset clears it', () async {
      final session = sessionBuilder.build();
      final patientId = await seedDemoData(session);

      final patient = await Profile.db.findById(session, patientId);
      expect(patient?.linkCode, demoLinkCode);
      expect(patient?.caregiverId, isNotNull);
      expect(patient?.doctorId, isNotNull);

      final memories = await PatientMemory.db.find(
        session,
        where: (t) => t.patientId.equals(patientId),
      );
      expect(memories.length, 3);
      expect(memories.every((m) => m.embedding.length == 768), isTrue);

      final weakness = await SymptomReport.db.count(
        session,
        where: (t) =>
            t.patientId.equals(patientId) & t.symptom.equals('weakness'),
      );
      expect(weakness, 2);

      await resetDemoData(session);
      expect(await Profile.db.findById(session, patientId), isNull);
      expect(
        await PatientMemory.db.count(
          session,
          where: (t) => t.patientId.equals(patientId),
        ),
        0,
      );
    });
  });
}
