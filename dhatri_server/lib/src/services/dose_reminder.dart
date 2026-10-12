import 'dart:io';

import 'package:serverpod/serverpod.dart';

import '../generated/future_calls.dart';
import '../generated/protocol.dart';
import 'care_bus.dart';
import 'dose_rules.dart';

Duration doseGracePeriod() => Duration(
  minutes: int.parse(Platform.environment['DHATRI_GRACE_MINUTES'] ?? '20'),
);

/// `scheduled → reminded`, notify caregivers, schedule escalation.
Future<void> remindDose(Session session, int doseEventId) async {
  final changed = await transitionDoseStatus(
    session,
    doseEventId,
    from: {DoseStatus.scheduled},
    to: DoseStatus.reminded,
  );
  if (!changed) {
    session.log('dose.remind skip id=$doseEventId (not scheduled)');
    return;
  }

  final event = await DoseEvent.db.findById(session, doseEventId);
  if (event == null) return;

  session.log(
    'dose.remind id=$doseEventId patient=${event.patientId} '
    'med=${event.medicationId} scheduledAt=${event.scheduledAt.toIso8601String()} '
    'graceMin=${doseGracePeriod().inMinutes}',
  );
  await postUpdate(
    session,
    event.patientId,
    CareUpdate(patientId: event.patientId, doseEvent: event),
  );

  await session.serverpod.futureCalls
      .callWithDelay(doseGracePeriod(), identifier: 'escalate-$doseEventId')
      .dose
      .escalate(doseEventId);
}

Future<void> scheduleDoseReminders(
  Session session,
  Iterable<int> doseEventIds,
) async {
  final ids = doseEventIds.toList();
  session.log('dose.scheduleReminders count=${ids.length}');
  final now = DateTime.now().toUtc();
  var immediate = 0;
  var deferred = 0;
  for (final id in ids) {
    final event = await DoseEvent.db.findById(session, id);
    if (event == null || event.status != DoseStatus.scheduled) continue;
    if (!event.scheduledAt.isAfter(now)) {
      immediate++;
      await remindDose(session, id);
    } else {
      deferred++;
      await session.serverpod.futureCalls
          .callAtTime(event.scheduledAt, identifier: 'remind-$id')
          .dose
          .remind(id);
    }
  }
  session.log(
    'dose.scheduleReminders done immediate=$immediate deferred=$deferred',
  );
}
