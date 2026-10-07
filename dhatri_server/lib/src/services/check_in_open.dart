import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'care_bus.dart';

/// Caregiver-triggered or scheduled opening of a pending check-in.
Future<void> openCheckIn(
  Session session,
  int patientId, {
  CheckTrigger trigger = CheckTrigger.caregiver,
}) async {
  final existing = await WellnessCheck.db.findFirstRow(
    session,
    where: (t) =>
        t.patientId.equals(patientId) &
        t.status.inSet({
          CheckStatus.pending,
          CheckStatus.snoozed,
          CheckStatus.active,
        }),
  );
  if (existing != null) return;

  final check = await WellnessCheck.db.insertRow(
    session,
    WellnessCheck(
      patientId: patientId,
      status: CheckStatus.pending,
      trigger: trigger,
    ),
  );
  await postUpdate(
    session,
    patientId,
    CareUpdate(patientId: patientId, check: check),
  );
}

Future<void> snoozeCheckIn(Session session, int checkId) async {
  final check = await WellnessCheck.db.findById(session, checkId);
  if (check == null) throw ArgumentError('Check-in not found');
  if (check.status != CheckStatus.pending && check.status != CheckStatus.active) {
    return;
  }
  final snoozeCount = check.turnCount;
  if (snoozeCount >= 2) return;

  final updated = await WellnessCheck.db.updateRow(
    session,
    check.copyWith(status: CheckStatus.snoozed, turnCount: snoozeCount + 1),
  );
  await postUpdate(
    session,
    check.patientId,
    CareUpdate(patientId: check.patientId, check: updated),
  );
}
