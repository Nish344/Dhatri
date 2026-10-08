import 'package:dhatri_server/src/generated/protocol.dart';
import 'package:dhatri_server/src/services/check_in_open.dart';
import 'package:dhatri_server/src/services/timeline_service.dart';
import 'package:test/test.dart';

import 'fixtures.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Check-in open / ring / snooze', (sessionBuilder, _) {
    test('open is idempotent and creates a pending check', () async {
      final session = sessionBuilder.build();
      final patient = await insertProfile(
        session,
        authUserId: 'open-${DateTime.now().microsecondsSinceEpoch}',
        name: 'Ramesh',
        role: Role.patient,
      );

      await openCheckIn(session, patient.id!, trigger: CheckTrigger.daily);
      await openCheckIn(session, patient.id!, trigger: CheckTrigger.caregiver);

      final checks = await WellnessCheck.db.find(
        session,
        where: (t) => t.patientId.equals(patient.id!),
      );
      expect(checks, hasLength(1));
      expect(checks.single.status, CheckStatus.pending);
      expect(checks.single.trigger, CheckTrigger.daily);
    });

    test('ring re-posts twice then leaves the check unanswered', () async {
      final session = sessionBuilder.build();
      final patient = await insertProfile(
        session,
        authUserId: 'ring-${DateTime.now().microsecondsSinceEpoch}',
        name: 'Ramesh',
        role: Role.patient,
      );
      await openCheckIn(session, patient.id!);
      final check = (await WellnessCheck.db.findFirstRow(
        session,
        where: (t) => t.patientId.equals(patient.id!),
      ))!;

      await ringCheckIn(session, check.id!);
      var updated = await WellnessCheck.db.findById(session, check.id!);
      expect(updated!.ringCount, 1);
      expect(updated.status, CheckStatus.pending);

      await ringCheckIn(session, check.id!);
      updated = await WellnessCheck.db.findById(session, check.id!);
      expect(updated!.ringCount, 2);
      expect(updated.status, CheckStatus.snoozed);

      await ringCheckIn(session, check.id!);
      updated = await WellnessCheck.db.findById(session, check.id!);
      expect(updated!.ringCount, 2);

      final timeline = await buildTimeline(session, patient.id!, 7);
      expect(
        timeline.any((i) => i.title == 'Check-in not answered'),
        isTrue,
      );
    });

    test('snooze caps at two and uses snoozeCount', () async {
      final session = sessionBuilder.build();
      final patient = await insertProfile(
        session,
        authUserId: 'snooze-${DateTime.now().microsecondsSinceEpoch}',
        name: 'Ramesh',
        role: Role.patient,
      );
      await openCheckIn(session, patient.id!);
      final check = (await WellnessCheck.db.findFirstRow(
        session,
        where: (t) => t.patientId.equals(patient.id!),
      ))!;

      await snoozeCheckIn(session, check.id!);
      expect(
        (await WellnessCheck.db.findById(session, check.id!))!.snoozeCount,
        1,
      );

      // Ring brings the call back to pending so the patient can snooze again.
      await ringCheckIn(session, check.id!);
      await snoozeCheckIn(session, check.id!);
      expect(
        (await WellnessCheck.db.findById(session, check.id!))!.snoozeCount,
        2,
      );

      await ringCheckIn(session, check.id!);
      await snoozeCheckIn(session, check.id!);

      final updated = await WellnessCheck.db.findById(session, check.id!);
      expect(updated!.snoozeCount, 2);
      expect(updated.turnCount, 0);
    });
  });
}
