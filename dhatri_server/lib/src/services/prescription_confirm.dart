import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'care_bus.dart';
import 'dose_reminder.dart';
import 'insight_service.dart';

/// Caregiver-confirmed schedule → medications + dose events (ARCHITECTURE §6).
Future<List<Medication>> confirmPrescription(
  Session session,
  int prescriptionId,
  List<MedicationDraft> meds,
) async {
  final rx = await Prescription.db.findById(session, prescriptionId);
  if (rx == null) throw ArgumentError('Prescription not found');
  if (rx.status != PrescriptionStatus.extracted &&
      rx.status != PrescriptionStatus.failed) {
    throw StateError('Prescription is not ready to confirm');
  }

  final patientId = rx.patientId;
  final start = istDayStartUtc(); // midnight IST as UTC instant
  final created = <Medication>[];
  final doseIds = <int>[];

  for (final draft in meds) {
    if (draft.name.trim().isEmpty || draft.times.isEmpty) continue;
    final end = start.add(Duration(days: draft.durationDays));
    final med = await Medication.db.insertRow(
      session,
      Medication(
        patientId: patientId,
        prescriptionId: prescriptionId,
        name: draft.name.trim(),
        strength: draft.strength,
        doseText: draft.doseText,
        instructions: draft.instructions,
        times: draft.times,
        startDate: start,
        endDate: end,
      ),
    );
    created.add(med);

    for (var day = 0; day < draft.durationDays; day++) {
      for (final time in draft.times) {
        final scheduled = istTimeToUtc(start.add(Duration(days: day)), time);
        if (scheduled.isBefore(DateTime.now().toUtc())) continue;
        try {
          final dose = await DoseEvent.db.insertRow(
            session,
            DoseEvent(
              patientId: patientId,
              medicationId: med.id!,
              scheduledAt: scheduled,
              status: DoseStatus.scheduled,
            ),
          );
          doseIds.add(dose.id!);
        } on DatabaseQueryException {
          // Unique (medicationId, scheduledAt) — safe retry / duplicate confirm.
        }
      }
    }
  }

  await Prescription.db.updateRow(
    session,
    rx.copyWith(status: PrescriptionStatus.confirmed),
  );
  await scheduleDoseReminders(session, doseIds);
  await postUpdate(
    session,
    patientId,
    CareUpdate(
      patientId: patientId,
      prescription: rx.copyWith(status: PrescriptionStatus.confirmed),
    ),
  );
  return created;
}

DateTime istTimeToUtc(DateTime istDayStart, String hhmm) {
  final parts = hhmm.split(':');
  final h = int.parse(parts[0]);
  final m = int.parse(parts[1]);
  final istLocal = DateTime(
    istDayStart.year,
    istDayStart.month,
    istDayStart.day,
    h,
    m,
  );
  return istLocal.subtract(const Duration(hours: 5, minutes: 30));
}
