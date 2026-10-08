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
  if (!changed) return;

  final event = await DoseEvent.db.findById(session, doseEventId);
  if (event == null) return;

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
  final now = DateTime.now().toUtc();
  for (final id in doseEventIds) {
    final event = await DoseEvent.db.findById(session, id);
    if (event == null || event.status != DoseStatus.scheduled) continue;
    if (!event.scheduledAt.isAfter(now)) {
      await remindDose(session, id);
    } else {
      await session.serverpod.futureCalls
          .callAtTime(event.scheduledAt, identifier: 'remind-$id')
          .dose
          .remind(id);
    }
  }
}
