import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'care_bus.dart';
import 'dose_rules.dart';

/// Marks a reminded dose missed and raises one alert (idempotent).
Future<bool> escalateMissedDose(Session session, int doseEventId) async {
  final changed = await transitionDoseStatus(
    session,
    doseEventId,
    from: {DoseStatus.reminded},
    to: DoseStatus.missed,
  );
  if (!changed) return false;

  final event = await DoseEvent.db.findById(session, doseEventId);
  if (event == null) return false;

  final alert = await Alert.db.insertRow(
    session,
    Alert(
      patientId: event.patientId,
      kind: AlertKind.missedDose,
      priority: AlertPriority.attention,
      doseEventId: event.id,
      message: 'Missed dose for scheduled medication',
      createdAt: DateTime.now().toUtc(),
    ),
  );

  await postUpdate(
    session,
    event.patientId,
    CareUpdate(patientId: event.patientId, doseEvent: event, alert: alert),
  );
  return true;
}

Future<DoseEvent?> markDoseTaken(Session session, int doseEventId) async {
  final changed = await transitionDoseStatus(
    session,
    doseEventId,
    from: {DoseStatus.scheduled, DoseStatus.reminded},
    to: DoseStatus.taken,
  );
  if (!changed) {
    return DoseEvent.db.findById(session, doseEventId);
  }
  final event = await DoseEvent.db.findById(session, doseEventId);
  if (event != null) {
    await postUpdate(
      session,
      event.patientId,
      CareUpdate(patientId: event.patientId, doseEvent: event),
    );
  }
  return event;
}
