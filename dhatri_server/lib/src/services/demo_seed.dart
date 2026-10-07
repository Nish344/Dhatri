import 'dart:io';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'gemini.dart';

const demoLinkCode = '482910';

Future<void> assertDemoSeedAllowed(Session session, String token) async {
  if (Platform.environment['DHATRI_ENABLE_SEED'] != 'true') {
    throw StateError('Demo seed is disabled (set DHATRI_ENABLE_SEED=true)');
  }
  final expected = session.serverpod.getPassword('demoSeedToken');
  if (expected == null || expected.isEmpty || token != expected) {
    throw ArgumentError('Invalid demo seed token');
  }
}

/// Inserts the Ramesh Kumar filming dataset (7-day history + memory embeddings).
Future<int> seedDemoData(Session session) async {
  await resetDemoData(session);
  final gemini = _optionalGemini(session);

  final caregiver = await Profile.db.insertRow(
    session,
    Profile(name: 'Ananya Kumar', role: Role.caregiver, phone: '+91 98111 22233'),
  );
  final doctor = await Profile.db.insertRow(
    session,
    Profile(name: 'Dr. Priya Sharma', role: Role.doctor, phone: '+91 99999 88888'),
  );
  final patient = await Profile.db.insertRow(
    session,
    Profile(
      name: 'Ramesh Kumar',
      role: Role.patient,
      age: 72,
      phone: '+91 98765 43210',
      caregiverId: caregiver.id,
      doctorId: doctor.id,
      linkCode: demoLinkCode,
    ),
  );
  final patientId = patient.id!;

  final now = DateTime.now().toUtc();
  final todayIst = now.add(const Duration(hours: 5, minutes: 30));

  final prescription = await Prescription.db.insertRow(
    session,
    Prescription(
      patientId: patientId,
      storageId: 'private',
      path: 'prescriptions/$patientId/demo_seed.jpg',
      status: PrescriptionStatus.confirmed,
      createdAt: now.subtract(const Duration(days: 7)),
    ),
  );

  final metformin = await Medication.db.insertRow(
    session,
    Medication(
      patientId: patientId,
      prescriptionId: prescription.id!,
      name: 'Metformin',
      strength: '500 mg',
      doseText: '1 tablet',
      instructions: 'After meals',
      times: ['08:00', '20:00'],
      startDate: now.subtract(const Duration(days: 7)),
      endDate: now.add(const Duration(days: 23)),
    ),
  );
  final amlodipine = await Medication.db.insertRow(
    session,
    Medication(
      patientId: patientId,
      prescriptionId: prescription.id!,
      name: 'Amlodipine',
      strength: '5 mg',
      doseText: '1 tablet',
      instructions: 'Morning with water',
      times: ['08:00'],
      startDate: now.subtract(const Duration(days: 7)),
      endDate: now.add(const Duration(days: 23)),
    ),
  );
  final atorvastatin = await Medication.db.insertRow(
    session,
    Medication(
      patientId: patientId,
      prescriptionId: prescription.id!,
      name: 'Atorvastatin',
      strength: '20 mg',
      doseText: '1 tablet',
      instructions: 'Bedtime',
      times: ['22:00'],
      startDate: now.subtract(const Duration(days: 7)),
      endDate: now.add(const Duration(days: 23)),
    ),
  );

  DateTime istSlot(int dayOffset, int hour, int minute) {
    final local = DateTime(
      todayIst.year,
      todayIst.month,
      todayIst.day + dayOffset,
      hour,
      minute,
    );
    return local.subtract(const Duration(hours: 5, minutes: 30));
  }

  Future<void> dose({
    required int medicationId,
    required DateTime scheduledAt,
    required DoseStatus status,
    DateTime? takenAt,
  }) async {
    await DoseEvent.db.insertRow(
      session,
      DoseEvent(
        patientId: patientId,
        medicationId: medicationId,
        scheduledAt: scheduledAt,
        status: status,
        remindedAt: status == DoseStatus.reminded || status == DoseStatus.taken
            ? scheduledAt
            : null,
        takenAt: takenAt,
      ),
    );
  }

  // Morning pair taken today.
  await dose(
    medicationId: metformin.id!,
    scheduledAt: istSlot(0, 8, 0),
    status: DoseStatus.taken,
    takenAt: istSlot(0, 8, 5),
  );
  await dose(
    medicationId: amlodipine.id!,
    scheduledAt: istSlot(0, 8, 0),
    status: DoseStatus.taken,
    takenAt: istSlot(0, 8, 6),
  );
  // Evening hero dose — reminded.
  await dose(
    medicationId: metformin.id!,
    scheduledAt: istSlot(0, 20, 0),
    status: DoseStatus.reminded,
  );
  await dose(
    medicationId: atorvastatin.id!,
    scheduledAt: istSlot(0, 22, 0),
    status: DoseStatus.scheduled,
  );
  // Missed evening dose 2 days ago.
  await dose(
    medicationId: metformin.id!,
    scheduledAt: istSlot(-2, 20, 0),
    status: DoseStatus.missed,
  );

  final checkOld = await WellnessCheck.db.insertRow(
    session,
    WellnessCheck(
      patientId: patientId,
      status: CheckStatus.completed,
      trigger: CheckTrigger.daily,
      turnCount: 1,
      mood: 'okay',
      summaryEn: 'Mild fatigue reported.',
      createdAt: now.subtract(const Duration(days: 5)),
      completedAt: now.subtract(const Duration(days: 5)).add(const Duration(minutes: 3)),
    ),
  );
  final checkWeak = await WellnessCheck.db.insertRow(
    session,
    WellnessCheck(
      patientId: patientId,
      status: CheckStatus.completed,
      trigger: CheckTrigger.daily,
      turnCount: 2,
      mood: 'low',
      summaryEn: 'Weakness reported (severity 2).',
      memoryUsed: const ['Weakness reported 5 days ago'],
      createdAt: now.subtract(const Duration(days: 3)),
      completedAt: now.subtract(const Duration(days: 3)).add(const Duration(minutes: 3)),
    ),
  );
  final checkRecent = await WellnessCheck.db.insertRow(
    session,
    WellnessCheck(
      patientId: patientId,
      status: CheckStatus.completed,
      trigger: CheckTrigger.daily,
      turnCount: 2,
      mood: 'low',
      summaryEn: 'Weakness (severity 3) with mild dizziness.',
      memoryUsed: const ['Weakness reported 3 days ago'],
      createdAt: now.subtract(const Duration(days: 1)),
      completedAt: now.subtract(const Duration(days: 1)).add(const Duration(minutes: 3)),
    ),
  );

  await SymptomReport.db.insertRow(
    session,
    SymptomReport(
      patientId: patientId,
      checkId: checkOld.id!,
      symptom: 'fatigue',
      severity: 2,
      reportedAt: now.subtract(const Duration(days: 5)),
    ),
  );
  await SymptomReport.db.insertRow(
    session,
    SymptomReport(
      patientId: patientId,
      checkId: checkWeak.id!,
      symptom: 'weakness',
      severity: 2,
      reportedAt: now.subtract(const Duration(days: 3)),
    ),
  );
  await SymptomReport.db.insertRow(
    session,
    SymptomReport(
      patientId: patientId,
      checkId: checkRecent.id!,
      symptom: 'weakness',
      severity: 3,
      reportedAt: now.subtract(const Duration(days: 1)),
    ),
  );

  await Alert.db.insertRow(
    session,
    Alert(
      patientId: patientId,
      kind: AlertKind.repeatedSymptom,
      priority: AlertPriority.important,
      symptom: 'weakness',
      message: 'Weakness reported 3 times in 7 days',
      createdAt: now.subtract(const Duration(hours: 14)),
    ),
  );

  final memoryRows = [
    (
      checkOld.id!,
      'Patient reported mild fatigue and feeling slow.',
      now.subtract(const Duration(days: 5)),
    ),
    (
      checkWeak.id!,
      'Patient reported weakness (severity 2) during evening check-in.',
      now.subtract(const Duration(days: 3)),
    ),
    (
      checkRecent.id!,
      'Patient reported weakness (severity 3) and mild dizziness when getting out of bed.',
      now.subtract(const Duration(days: 1)),
    ),
  ];
  for (final (checkId, content, at) in memoryRows) {
    final embedding = await _embedForSeed(gemini, content);
    await PatientMemory.db.insertRow(
      session,
      PatientMemory(
        patientId: patientId,
        kind: 'symptom',
        content: content,
        sourceCheckId: checkId,
        createdAt: at,
        embedding: embedding,
      ),
    );
  }

  return patientId;
}

Future<void> resetDemoData(Session session) async {
  final patient = await Profile.db.findFirstRow(
    session,
    where: (t) => t.linkCode.equals(demoLinkCode),
  );
  if (patient == null) return;
  final patientId = patient.id!;

  await PatientMemory.db.deleteWhere(
    session,
    where: (t) => t.patientId.equals(patientId),
  );
  await SymptomReport.db.deleteWhere(
    session,
    where: (t) => t.patientId.equals(patientId),
  );
  await Alert.db.deleteWhere(
    session,
    where: (t) => t.patientId.equals(patientId),
  );
  await DoseEvent.db.deleteWhere(
    session,
    where: (t) => t.patientId.equals(patientId),
  );
  await WellnessCheck.db.deleteWhere(
    session,
    where: (t) => t.patientId.equals(patientId),
  );
  await Medication.db.deleteWhere(
    session,
    where: (t) => t.patientId.equals(patientId),
  );
  await Prescription.db.deleteWhere(
    session,
    where: (t) => t.patientId.equals(patientId),
  );

  final caregiverId = patient.caregiverId;
  final doctorId = patient.doctorId;
  await Profile.db.deleteRow(session, patient);
  if (caregiverId != null) {
    await Profile.db.deleteWhere(
      session,
      where: (t) => t.id.equals(caregiverId) & t.role.equals(Role.caregiver),
    );
  }
  if (doctorId != null) {
    await Profile.db.deleteWhere(
      session,
      where: (t) => t.id.equals(doctorId) & t.role.equals(Role.doctor),
    );
  }
}

Gemini? _optionalGemini(Session session) {
  try {
    return Gemini.of(session);
  } on StateError {
    return null;
  }
}

Future<Vector> _embedForSeed(Gemini? gemini, String content) async {
  if (gemini != null) {
    try {
      return Vector(await gemini.embed(content));
    } on GeminiException {
      // Fall through to deterministic vector for tests / offline seed.
    }
  }
  final v = List<double>.filled(768, 0.0);
  v[content.hashCode.abs() % 768] = 1.0;
  if (content.toLowerCase().contains('weak')) {
    v[0] = 1.0;
  }
  return Vector(v);
}
