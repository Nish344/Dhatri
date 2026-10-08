import 'package:dhatri_server/src/generated/protocol.dart';
import 'package:dhatri_server/src/services/symptom_rules.dart';
import 'package:test/test.dart';

import 'fixtures.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Symptom rules', (sessionBuilder, _) {
    test(
      'three weakness reports in 7 days → one repeatedSymptom alert',
      () async {
        final session = sessionBuilder.build();
        final patient = await insertProfile(
          session,
          authUserId: 'sym-patient',
          name: 'Ramesh',
          role: Role.patient,
        );

        for (var i = 0; i < 3; i++) {
          final check = await insertCheck(session, patient.id!);
          await applySymptomRules(session, patient.id!, check.id!, [
            (symptom: 'weakness', severity: 2),
          ]);
        }

        final repeated = await Alert.db.count(
          session,
          where: (t) =>
              t.patientId.equals(patient.id!) &
              t.kind.equals(AlertKind.repeatedSymptom),
        );
        expect(repeated, 1);

        final check4 = await insertCheck(session, patient.id!);
        await applySymptomRules(session, patient.id!, check4.id!, [
          (symptom: 'weakness', severity: 2),
        ]);
        expect(
          await Alert.db.count(
            session,
            where: (t) =>
                t.patientId.equals(patient.id!) &
                t.kind.equals(AlertKind.repeatedSymptom),
          ),
          1,
        );
      },
    );

    test('severity 4 creates severeSymptom alert', () async {
      final session = sessionBuilder.build();
      final patient = await insertProfile(
        session,
        authUserId: 'sev-patient',
        name: 'Ramesh',
        role: Role.patient,
      );
      final check = await insertCheck(session, patient.id!);
      await applySymptomRules(session, patient.id!, check.id!, [
        (symptom: 'pain', severity: 4),
      ]);

      expect(
        await Alert.db.count(
          session,
          where: (t) =>
              t.patientId.equals(patient.id!) &
              t.kind.equals(AlertKind.severeSymptom),
        ),
        1,
      );
    });
  });
}
