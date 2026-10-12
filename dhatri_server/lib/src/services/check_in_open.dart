import 'package:serverpod/serverpod.dart';

import '../generated/future_calls.dart';
import '../generated/protocol.dart';
import 'care_bus.dart';

const checkInRingDelay = Duration(seconds: 90);
const checkInSnoozeDelay = Duration(minutes: 15);
const maxCheckInRings = 2;
const maxCheckInSnoozes = 2;

/// Cron for 19:00 IST (UTC+5:30) = 13:30 UTC.
const dailyCheckInCron = '30 13 * * *';

String dailyCheckInId(int patientId) => 'checkin-$patientId';

/// Registers the evening care call when a caregiver or doctor links a patient.
Future<void> scheduleDailyCheckIn(Session session, int patientId) async {
  session.log(
    'checkIn.scheduleDaily patient=$patientId cron=$dailyCheckInCron',
  );
  await session.serverpod.futureCalls.cancel(dailyCheckInId(patientId));
  await session.serverpod.futureCalls
      .callRecurring(identifier: dailyCheckInId(patientId))
      .cron(dailyCheckInCron)
      .checkIn
      .open(patientId, CheckTrigger.daily);
}

/// Caregiver-triggered or scheduled opening of a pending check-in.
/// Safe to run twice: skips if a pending/active/snoozed check already exists.
Future<void> openCheckIn(
  Session session,
  int patientId, {
  CheckTrigger trigger = CheckTrigger.caregiver,
}) async {
  session.log('checkIn.open patient=$patientId trigger=${trigger.name}');
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
  if (existing != null) {
    // Abandoned "active" checks (patient hung up / tab closed) block every new
    // call because pending() ignores active. Reclaim and open a fresh ring.
    if (existing.status == CheckStatus.active) {
      session.log(
        'checkIn.open reclaim active id=${existing.id} patient=$patientId',
        level: LogLevel.warning,
      );
      await _completeCheck(
        session,
        existing,
        summaryFallback: 'Check-in ended without finishing.',
      );
      // Fall through and create a new pending check below.
    } else {
      session.log(
        'checkIn.open re-ring patient=$patientId existingId=${existing.id} '
        'status=${existing.status.name} trigger=${trigger.name}',
      );
      final revived = await WellnessCheck.db.updateRow(
        session,
        existing.copyWith(status: CheckStatus.pending),
      );
      await postUpdate(
        session,
        patientId,
        CareUpdate(patientId: patientId, check: revived),
      );
      await _scheduleRing(session, revived.id!);
      return;
    }
  }

  final check = await WellnessCheck.db.insertRow(
    session,
    WellnessCheck(
      patientId: patientId,
      status: CheckStatus.pending,
      trigger: trigger,
    ),
  );
  session.log('checkIn.open created id=${check.id} patient=$patientId');
  await postUpdate(
    session,
    patientId,
    CareUpdate(patientId: patientId, check: check),
  );
  await _scheduleRing(session, check.id!);
}

/// Re-posts the incoming-call update while the check is still unanswered.
/// After [maxCheckInRings] rings with no answer, leaves the check snoozed so
/// the timeline can show "Check-in not answered".
Future<void> ringCheckIn(Session session, int checkId) async {
  final check = await WellnessCheck.db.findById(session, checkId);
  if (check == null) {
    session.log('checkIn.ring missing id=$checkId', level: LogLevel.warning);
    return;
  }
  if (check.status != CheckStatus.pending &&
      check.status != CheckStatus.snoozed) {
    session.log(
      'checkIn.ring skip id=$checkId status=${check.status.name}',
    );
    return;
  }
  if (check.ringCount >= maxCheckInRings) {
    session.log('checkIn.ring maxed id=$checkId rings=${check.ringCount}');
    return;
  }

  final rings = check.ringCount + 1;
  final unanswered = rings >= maxCheckInRings;
  final updated = await WellnessCheck.db.updateRow(
    session,
    check.copyWith(
      ringCount: rings,
      // Bring the call back to pending so the patient can answer or snooze again.
      status: unanswered ? CheckStatus.snoozed : CheckStatus.pending,
    ),
  );
  session.log(
    'checkIn.ring id=$checkId ring=$rings/$maxCheckInRings '
    'unanswered=$unanswered status=${updated.status.name}',
  );
  await postUpdate(
    session,
    updated.patientId,
    CareUpdate(patientId: updated.patientId, check: updated),
  );

  if (!unanswered) {
    await _scheduleRing(session, checkId);
  }
}

Future<void> snoozeCheckIn(Session session, int checkId) async {
  final check = await WellnessCheck.db.findById(session, checkId);
  if (check == null) throw ArgumentError('Check-in not found');
  if (check.status != CheckStatus.pending &&
      check.status != CheckStatus.active) {
    session.log(
      'checkIn.snooze skip id=$checkId status=${check.status.name}',
    );
    return;
  }

  // Hang-up mid-call: complete so Talk-to-Dhatri / caregiver ring can start again.
  if (check.status == CheckStatus.active) {
    session.log('checkIn.hangUp complete id=$checkId');
    await _completeCheck(
      session,
      check,
      summaryFallback: 'Check-in ended by patient.',
    );
    return;
  }

  if (check.snoozeCount >= maxCheckInSnoozes) {
    // Decline after max snoozes — complete instead of leaving a zombie pending.
    session.log(
      'checkIn.snooze maxed → complete id=$checkId '
      'snoozes=${check.snoozeCount}',
    );
    await _completeCheck(
      session,
      check,
      summaryFallback: 'Check-in declined after max snoozes.',
    );
    return;
  }

  final updated = await WellnessCheck.db.updateRow(
    session,
    check.copyWith(
      status: CheckStatus.snoozed,
      snoozeCount: check.snoozeCount + 1,
    ),
  );
  session.log(
    'checkIn.snooze id=$checkId snooze=${updated.snoozeCount}/'
    '$maxCheckInSnoozes delay=${checkInSnoozeDelay.inMinutes}m',
  );
  await postUpdate(
    session,
    check.patientId,
    CareUpdate(patientId: check.patientId, check: updated),
  );
  await session.serverpod.futureCalls
      .callWithDelay(
        checkInSnoozeDelay,
        identifier: 'checkin-ring-$checkId',
      )
      .checkIn
      .ring(checkId);
}

Future<void> _completeCheck(
  Session session,
  WellnessCheck check, {
  required String summaryFallback,
}) async {
  final updated = await WellnessCheck.db.updateRow(
    session,
    check.copyWith(
      status: CheckStatus.completed,
      completedAt: DateTime.now().toUtc(),
      summaryEn: check.summaryEn ?? summaryFallback,
    ),
  );
  await postUpdate(
    session,
    check.patientId,
    CareUpdate(patientId: check.patientId, check: updated),
  );
}

Future<void> _scheduleRing(Session session, int checkId) => session
    .serverpod
    .futureCalls
    .callWithDelay(
      checkInRingDelay,
      identifier: 'checkin-ring-$checkId',
    )
    .checkIn
    .ring(checkId);
