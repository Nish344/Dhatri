import 'package:dhatri_server/src/generated/protocol.dart';
import 'package:dhatri_server/src/services/dose_escalation.dart';
import 'package:test/test.dart';

import 'fixtures.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Dose escalation', (sessionBuilder, endpoints) {
    test(
      'reminded dose becomes missed with one alert; double escalate is safe',
      () async {
        final session = sessionBuilder.build();
        final patient = await insertProfile(
          session,
          authUserId: 'patient-1',
          name: 'Ramesh',
          role: Role.patient,
        );
        final dose = await insertRemindedDose(session, patientId: patient.id!);

        expect(await escalateMissedDose(session, dose.id!), isTrue);
        expect(await missedDoseAlertCount(session, patient.id!), 1);

        final after = await DoseEvent.db.findById(session, dose.id!);
        expect(after!.status, DoseStatus.missed);

        expect(await escalateMissedDose(session, dose.id!), isFalse);
        expect(await missedDoseAlertCount(session, patient.id!), 1);
      },
    );

    test('taken before escalate stays taken with no alert', () async {
      final session = sessionBuilder.build();
      final patient = await insertProfile(
        session,
        authUserId: 'patient-2',
        name: 'Ramesh',
        role: Role.patient,
      );
      final dose = await insertRemindedDose(session, patientId: patient.id!);

      expect(await markDoseTaken(session, dose.id!), isNotNull);
      expect(await escalateMissedDose(session, dose.id!), isFalse);
      expect(await missedDoseAlertCount(session, patient.id!), 0);

      final after = await DoseEvent.db.findById(session, dose.id!);
      expect(after!.status, DoseStatus.taken);
    });
  });

  withServerpod(
    'Dose escalation race',
    (sessionBuilder, _) {
      test(
        'concurrent taken vs escalate never yields taken and an alert',
        () async {
          final session = sessionBuilder.build();
          final patient = await insertProfile(
            session,
            authUserId: 'patient-3',
            name: 'Ramesh',
            role: Role.patient,
          );
          final dose = await insertRemindedDose(
            session,
            patientId: patient.id!,
          );

          await Future.wait(
            List.generate(20, (_) async {
              await Future.wait([
                markDoseTaken(session, dose.id!),
                escalateMissedDose(session, dose.id!),
              ]);
            }),
          );

          final after = await DoseEvent.db.findById(session, dose.id!);
          final alerts = await missedDoseAlertCount(session, patient.id!);

          if (after!.status == DoseStatus.taken) {
            expect(alerts, 0);
          } else {
            expect(after.status, DoseStatus.missed);
            expect(alerts, 1);
          }
        },
      );
    },
    rollbackDatabase: RollbackDatabase.disabled,
  );
}
