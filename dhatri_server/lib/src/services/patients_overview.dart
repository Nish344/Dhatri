import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'insight_service.dart';

Future<List<PatientStatus>> caregiverOverview(
  Session session,
  Profile caregiver,
) async {
  final patients = await Profile.db.find(
    session,
    where: (t) => t.caregiverId.equals(caregiver.id!),
    orderBy: (t) => t.name,
  );
  final statuses = <PatientStatus>[];
  for (final p in patients) {
    statuses.add(await _statusFor(session, p));
  }
  statuses.sort((a, b) {
    final aw = _attentionWeight(a.state);
    final bw = _attentionWeight(b.state);
    if (aw != bw) return bw.compareTo(aw);
    return a.patient.name.compareTo(b.patient.name);
  });
  return statuses;
}

Future<List<PatientStatus>> doctorOverview(
  Session session,
  Profile doctor,
) async {
  final patients = await Profile.db.find(
    session,
    where: (t) => t.doctorId.equals(doctor.id!),
    orderBy: (t) => t.name,
  );
  return [for (final p in patients) await _statusFor(session, p)];
}

int _attentionWeight(PatientState s) => switch (s) {
  PatientState.medicationMissed => 3,
  PatientState.attention => 2,
  PatientState.checkInNeeded => 1,
  _ => 0,
};

Future<PatientStatus> _statusFor(Session session, Profile patient) async {
  final patientId = patient.id!;
  final openAlerts = await Alert.db.count(
    session,
    where: (t) =>
        t.patientId.equals(patientId) & t.acknowledgedAt.equals(null),
  );
  final missed = await Alert.db.findFirstRow(
    session,
    where: (t) =>
        t.patientId.equals(patientId) &
        t.kind.equals(AlertKind.missedDose) &
        t.acknowledgedAt.equals(null),
  );
  final repeated = await Alert.db.findFirstRow(
    session,
    where: (t) =>
        t.patientId.equals(patientId) &
        t.kind.equals(AlertKind.repeatedSymptom) &
        t.acknowledgedAt.equals(null),
  );

  final todayStart = istDayStartUtc();
  final tomorrow = todayStart.add(const Duration(days: 1));
  final nextDose = await DoseEvent.db.findFirstRow(
    session,
    where: (t) =>
        t.patientId.equals(patientId) &
        (t.scheduledAt >= todayStart) &
        (t.scheduledAt < tomorrow) &
        t.status.inSet({DoseStatus.scheduled, DoseStatus.reminded}),
    orderBy: (t) => t.scheduledAt,
  );

  final state = missed != null
      ? PatientState.medicationMissed
      : repeated != null || openAlerts > 0
      ? PatientState.attention
      : PatientState.allGood;

  final headline = missed != null
      ? missed.message
      : repeated != null
      ? repeated.message
      : nextDose != null
      ? 'Next dose ${nextDose.scheduledAt.toUtc().add(const Duration(hours: 5, minutes: 30))}'
      : 'All medications confirmed on time';

  return PatientStatus(
    patient: patient,
    state: state,
    headline: headline,
    nextDose: nextDose,
    openAlerts: openAlerts,
  );
}
