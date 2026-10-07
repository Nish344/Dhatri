import 'package:flutter/foundation.dart';
import '../models/models.dart';

/// In-memory mock database and state container.
///
/// Pre-seeds a rich, realistic 7-day medical narrative for Ramesh Kumar (72),
/// matching ARCHITECTURE.md §4, DEMO.md, and Dhatri UI/UX Guide.
class MockDatabase {
  // Profiles
  static final Profile ramesh = Profile(
    id: 1,
    name: 'Ramesh Kumar',
    role: Role.patient,
    age: 72,
    phone: '+91 98765 43210',
    caregiverId: 2,
    doctorId: 3,
    linkCode: '482910',
  );

  static final Profile ananya = Profile(
    id: 2,
    name: 'Ananya Kumar',
    role: Role.caregiver,
    phone: '+91 98111 22233',
  );

  static final Profile drPriya = Profile(
    id: 3,
    name: 'Dr. Priya Sharma',
    role: Role.doctor,
    phone: '+91 99999 88888',
  );

  // Other caregiver patients for triage list
  static final Profile alice = Profile(
    id: 4,
    name: 'Alice Smith',
    role: Role.patient,
    age: 84,
    phone: '+91 98222 33445',
    caregiverId: 2,
  );

  static final Profile john = Profile(
    id: 5,
    name: 'John Sharma',
    role: Role.patient,
    age: 68,
    phone: '+91 98333 44556',
    caregiverId: 2,
  );

  static final Profile lakshmi = Profile(
    id: 6,
    name: 'Lakshmi Devi',
    role: Role.patient,
    age: 76,
    phone: '+91 98444 55667',
    caregiverId: 2,
  );

  // Active state lists
  List<Profile> patients = [];
  List<Prescription> prescriptions = [];
  List<Medication> medications = [];
  List<DoseEvent> doseEvents = [];
  List<WellnessCheck> wellnessChecks = [];
  List<SymptomReport> symptomReports = [];
  List<PatientMemory> patientMemories = [];
  List<Alert> alerts = [];

  MockDatabase() {
    resetToInitial();
  }

  void resetToInitial() {
    final now = DateTime.now();
    final today8am = DateTime(now.year, now.month, now.day, 8, 0);
    final today8pm = DateTime(now.year, now.month, now.day, 20, 0);
    final today10pm = DateTime(now.year, now.month, now.day, 22, 0);

    patients = [ramesh, alice, john, lakshmi];

    prescriptions = [
      Prescription(
        id: 1,
        patientId: 1,
        storageId: 'private',
        path: 'prescriptions/1/sample_rx_verma.jpg',
        status: PrescriptionStatus.confirmed,
        createdAt: now.subtract(const Duration(days: 7)),
      ),
    ];

    medications = [
      Medication(
        id: 1,
        patientId: 1,
        prescriptionId: 1,
        name: 'Metformin',
        strength: '500 mg',
        doseText: '1 tablet',
        instructions: 'After meals',
        times: ['08:00', '20:00'],
        startDate: now.subtract(const Duration(days: 7)),
        endDate: now.add(const Duration(days: 23)),
      ),
      Medication(
        id: 2,
        patientId: 1,
        prescriptionId: 1,
        name: 'Amlodipine',
        strength: '5 mg',
        doseText: '1 tablet',
        instructions: 'Morning with water',
        times: ['08:00'],
        startDate: now.subtract(const Duration(days: 7)),
        endDate: now.add(const Duration(days: 23)),
      ),
      Medication(
        id: 3,
        patientId: 1,
        prescriptionId: 1,
        name: 'Atorvastatin',
        strength: '20 mg',
        doseText: '1 tablet',
        instructions: 'Bedtime',
        times: ['22:00'],
        startDate: now.subtract(const Duration(days: 7)),
        endDate: now.add(const Duration(days: 23)),
      ),
    ];

    // Dose Events: Today + past week
    doseEvents = [
      // Today morning doses (Taken)
      DoseEvent(
        id: 1,
        patientId: 1,
        medicationId: 1,
        medicationName: 'Metformin 500 mg',
        doseText: '1 tablet',
        instructions: 'After breakfast',
        scheduledAt: today8am,
        status: DoseStatus.taken,
        remindedAt: today8am,
        takenAt: today8am.add(const Duration(minutes: 5)),
      ),
      DoseEvent(
        id: 2,
        patientId: 1,
        medicationId: 2,
        medicationName: 'Amlodipine 5 mg',
        doseText: '1 tablet',
        instructions: 'Morning with water',
        scheduledAt: today8am,
        status: DoseStatus.taken,
        remindedAt: today8am,
        takenAt: today8am.add(const Duration(minutes: 6)),
      ),
      // Today evening dose (Hero Next Dose - currently Reminded)
      DoseEvent(
        id: 3,
        patientId: 1,
        medicationId: 1,
        medicationName: 'Metformin 500 mg',
        doseText: '1 tablet',
        instructions: 'After dinner',
        scheduledAt: today8pm,
        status: DoseStatus.reminded,
        remindedAt: today8pm,
      ),
      // Today night dose
      DoseEvent(
        id: 4,
        patientId: 1,
        medicationId: 3,
        medicationName: 'Atorvastatin 20 mg',
        doseText: '1 tablet',
        instructions: 'Before sleeping',
        scheduledAt: today10pm,
        status: DoseStatus.scheduled,
      ),
    ];

    // Longitudinal Memories
    patientMemories = [
      PatientMemory(
        id: 1,
        patientId: 1,
        kind: 'symptom',
        content: 'Patient reported mild fatigue and feeling slow on 2 Oct.',
        createdAt: now.subtract(const Duration(days: 5)),
      ),
      PatientMemory(
        id: 2,
        patientId: 1,
        kind: 'symptom',
        content: 'Patient reported weakness (severity 2) during evening check-in on 4 Oct.',
        createdAt: now.subtract(const Duration(days: 3)),
      ),
      PatientMemory(
        id: 3,
        patientId: 1,
        kind: 'symptom',
        content: 'Patient reported weakness (severity 3) and mild dizziness when getting out of bed.',
        createdAt: now.subtract(const Duration(days: 1)),
      ),
    ];

    // Symptoms (3 weakness occurrences in 7 days)
    symptomReports = [
      SymptomReport(
        id: 1,
        patientId: 1,
        checkId: 10,
        symptom: 'fatigue',
        severity: 2,
        reportedAt: now.subtract(const Duration(days: 5)),
      ),
      SymptomReport(
        id: 2,
        patientId: 1,
        checkId: 11,
        symptom: 'weakness',
        severity: 2,
        reportedAt: now.subtract(const Duration(days: 3)),
      ),
      SymptomReport(
        id: 3,
        patientId: 1,
        checkId: 12,
        symptom: 'weakness',
        severity: 3,
        reportedAt: now.subtract(const Duration(days: 1)),
      ),
    ];

    // Seeded Wellness Checks
    wellnessChecks = [
      WellnessCheck(
        id: 12,
        patientId: 1,
        status: CheckStatus.completed,
        trigger: CheckTrigger.daily,
        turnCount: 2,
        transcript: 'Patient: थोड़ा कमजोर लग रहा है और हल्का चक्कर भी आया।\nDhatri: आप आराम करें, मैंने आपकी बेटी को सूचित कर दिया है।',
        replyText: 'आप आराम करें रमेश जी।',
        mood: 'low',
        summaryEn: 'Patient reported weakness (severity 3) and mild dizziness.',
        memoryUsed: ['Weakness reported 3 days ago'],
        createdAt: now.subtract(const Duration(days: 1)),
        completedAt: now.subtract(const Duration(days: 1)).add(const Duration(minutes: 3)),
      ),
    ];

    // Seeded Alerts
    alerts = [
      Alert(
        id: 1,
        patientId: 1,
        patientName: 'Ramesh Kumar',
        kind: AlertKind.repeatedSymptom,
        priority: AlertPriority.important,
        symptom: 'weakness',
        message: 'Weakness reported 3 times in 7 days',
        createdAt: now.subtract(const Duration(hours: 14)),
      ),
      Alert(
        id: 2,
        patientId: 4,
        patientName: 'Alice Smith',
        kind: AlertKind.missedDose,
        priority: AlertPriority.attention,
        message: 'Missed 12:00 PM Blood Pressure medication',
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
    ];
  }

  // Helper Methods
  List<TimelineItem> getTimeline(int patientId) {
    final now = DateTime.now();
    return [
      TimelineItem(
        at: now.subtract(const Duration(hours: 2)),
        kind: TimelineKind.dose,
        tone: TimelineTone.good,
        title: 'Morning medications taken',
        detail: 'Metformin 500 mg & Amlodipine 5 mg confirmed at 8:05 AM',
      ),
      TimelineItem(
        at: now.subtract(const Duration(days: 1, hours: 2)),
        kind: TimelineKind.wellness,
        tone: TimelineTone.warning,
        title: 'Weakness reported in care call',
        detail: 'Severity 3/5 with dizziness mentioned. Daughter alerted.',
      ),
      TimelineItem(
        at: now.subtract(const Duration(days: 2, hours: 4)),
        kind: TimelineKind.dose,
        tone: TimelineTone.missed,
        title: 'Evening Metformin dose missed',
        detail: 'No response after 20-minute escalation grace period.',
      ),
      TimelineItem(
        at: now.subtract(const Duration(days: 3, hours: 3)),
        kind: TimelineKind.wellness,
        tone: TimelineTone.warning,
        title: 'Weakness reported in care call',
        detail: 'Severity 2/5 recorded by Dhatri Hindi check-in.',
      ),
      TimelineItem(
        at: now.subtract(const Duration(days: 5, hours: 1)),
        kind: TimelineKind.wellness,
        tone: TimelineTone.neutral,
        title: 'Mild fatigue reported',
        detail: 'Dhatri logged regular check-in.',
      ),
      TimelineItem(
        at: now.subtract(const Duration(days: 6)),
        kind: TimelineKind.dose,
        tone: TimelineTone.good,
        title: 'All scheduled doses confirmed',
        detail: 'Adherence: 100% on Day 1',
      ),
    ];
  }

  PatientInsight getInsight(int patientId) {
    return PatientInsight(
      patient: ramesh,
      adherencePct: 86,
      prevAdherencePct: 92,
      dosesTaken: 12,
      dosesMissed: 2,
      checkIns: 7,
      symptoms: [
        const SymptomCount(symptom: 'Weakness', count: 3, maxSeverity: 3),
        const SymptomCount(symptom: 'Dizziness', count: 1, maxSeverity: 2),
      ],
      openAlerts: alerts.where((a) => a.patientId == patientId && a.acknowledgedAt == null).toList(),
      reviewRecommended: true,
      aiSummary: 'Repeated weakness reported across 3 of the last 5 check-ins. Medication adherence declined from 92% to 86% with 2 missed evening doses this week. Clinical review recommended.',
      latestCheck: wellnessChecks.isNotEmpty ? wellnessChecks.first : null,
      generatedAt: DateTime.now(),
    );
  }

  List<PatientStatus> getOverview() {
    return [
      PatientStatus(
        patient: ramesh,
        state: alerts.any((a) => a.patientId == 1 && a.kind == AlertKind.missedDose)
            ? PatientState.medicationMissed
            : PatientState.attention,
        headline: 'Repeated weakness · Next dose 8:00 PM',
        nextDose: doseEvents.firstWhere((d) => d.id == 3),
        openAlerts: alerts.where((a) => a.patientId == 1 && a.acknowledgedAt == null).length,
      ),
      PatientStatus(
        patient: alice,
        state: PatientState.medicationMissed,
        headline: 'Missed 12:00 PM Blood Pressure medicine',
        nextDose: null,
        openAlerts: 1,
      ),
      PatientStatus(
        patient: john,
        state: PatientState.allGood,
        headline: 'All medications confirmed on time',
        nextDose: null,
        openAlerts: 0,
      ),
      PatientStatus(
        patient: lakshmi,
        state: PatientState.allGood,
        headline: 'All medications confirmed on time',
        nextDose: null,
        openAlerts: 0,
      ),
    ];
  }
}

