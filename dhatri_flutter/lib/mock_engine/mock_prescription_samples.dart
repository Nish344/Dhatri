import '../models/models.dart';
import 'mock_database.dart';
import 'mock_care_stream.dart';

class MockPrescriptionSamples {
  static List<MedicationDraft> getSampleDrafts() {
    return [
      MedicationDraft(
        name: 'Metformin',
        strength: '500 mg',
        doseText: '1 tablet',
        instructions: 'After breakfast & dinner',
        times: ['08:00', '20:00'],
        durationDays: 30,
        uncertain: false,
      ),
      MedicationDraft(
        name: 'Amlodipine',
        strength: '5 mg',
        doseText: '1 tablet',
        instructions: 'Morning with water',
        times: ['08:00'],
        durationDays: 30,
        uncertain: false,
      ),
      MedicationDraft(
        name: 'Atorvastatin',
        strength: '20 mg',
        doseText: '1 tablet',
        instructions: 'Bedtime',
        times: ['22:00'],
        durationDays: 30,
        uncertain: true, // Highlights safety rule: AI was unsure, caregiver reviews!
      ),
    ];
  }

  /// Converts reviewed drafts into active medications and creates dose events
  static void confirmDrafts({
    required MockDatabase db,
    required MockCareStream careStream,
    required List<MedicationDraft> drafts,
  }) {
    final now = DateTime.now();
    for (final draft in drafts) {
      final med = Medication(
        id: DateTime.now().millisecondsSinceEpoch + db.medications.length,
        patientId: 1,
        prescriptionId: 1,
        name: draft.name,
        strength: draft.strength,
        doseText: draft.doseText,
        instructions: draft.instructions,
        times: draft.times,
        startDate: now,
        endDate: now.add(Duration(days: draft.durationDays)),
        active: true,
      );
      db.medications.add(med);
    }

    careStream.postUpdate(CareUpdate(
      patientId: 1,
      prescription: db.prescriptions.first,
    ));
  }
}

