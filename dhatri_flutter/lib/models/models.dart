/// Domain models matching ARCHITECTURE.md §4.

enum Role { patient, caregiver, doctor }

enum PrescriptionStatus { uploaded, extracting, extracted, confirmed, failed }

enum DoseStatus { scheduled, reminded, taken, missed }

enum CheckStatus { pending, active, completed, snoozed }

enum CheckTrigger { daily, caregiver }

enum AlertKind { missedDose, repeatedSymptom, severeSymptom, patientHelp }

enum AlertPriority { attention, important, high }

enum TimelineKind { dose, wellness, alert }

enum TimelineTone { good, neutral, warning, missed }

enum PatientState { allGood, checkInNeeded, medicationMissed, attention }

class Profile {
  final int id;
  final String? authUserId;
  final String name;
  final Role role;
  final int? age;
  final String? phone;
  final int? caregiverId;
  final int? doctorId;
  final String? linkCode;

  const Profile({
    required this.id,
    this.authUserId,
    required this.name,
    required this.role,
    this.age,
    this.phone,
    this.caregiverId,
    this.doctorId,
    this.linkCode,
  });

  Profile copyWith({
    int? id,
    String? authUserId,
    String? name,
    Role? role,
    int? age,
    String? phone,
    int? caregiverId,
    int? doctorId,
    String? linkCode,
  }) {
    return Profile(
      id: id ?? this.id,
      authUserId: authUserId ?? this.authUserId,
      name: name ?? this.name,
      role: role ?? this.role,
      age: age ?? this.age,
      phone: phone ?? this.phone,
      caregiverId: caregiverId ?? this.caregiverId,
      doctorId: doctorId ?? this.doctorId,
      linkCode: linkCode ?? this.linkCode,
    );
  }
}

class MedicationDraft {
  String name;
  String? strength;
  String doseText;
  String? instructions;
  List<String> times;
  int durationDays;
  bool uncertain;

  MedicationDraft({
    required this.name,
    this.strength,
    required this.doseText,
    this.instructions,
    required this.times,
    required this.durationDays,
    required this.uncertain,
  });
}

class Prescription {
  final int id;
  final int patientId;
  final String storageId;
  final String path;
  final PrescriptionStatus status;
  final String? extractedJson;
  final String? error;
  final DateTime createdAt;

  const Prescription({
    required this.id,
    required this.patientId,
    required this.storageId,
    required this.path,
    required this.status,
    this.extractedJson,
    this.error,
    required this.createdAt,
  });

  Prescription copyWith({
    PrescriptionStatus? status,
    String? extractedJson,
    String? error,
  }) {
    return Prescription(
      id: id,
      patientId: patientId,
      storageId: storageId,
      path: path,
      status: status ?? this.status,
      extractedJson: extractedJson ?? this.extractedJson,
      error: error ?? this.error,
      createdAt: createdAt,
    );
  }
}

class Medication {
  final int id;
  final int patientId;
  final int prescriptionId;
  final String name;
  final String? strength;
  final String doseText;
  final String? instructions;
  final List<String> times;
  final DateTime startDate;
  final DateTime endDate;
  final bool active;

  const Medication({
    required this.id,
    required this.patientId,
    required this.prescriptionId,
    required this.name,
    this.strength,
    required this.doseText,
    this.instructions,
    required this.times,
    required this.startDate,
    required this.endDate,
    this.active = true,
  });
}

class DoseEvent {
  final int id;
  final int patientId;
  final int medicationId;
  final String medicationName;
  final String doseText;
  final String? instructions;
  final DateTime scheduledAt;
  final DoseStatus status;
  final DateTime? remindedAt;
  final DateTime? takenAt;

  const DoseEvent({
    required this.id,
    required this.patientId,
    required this.medicationId,
    required this.medicationName,
    required this.doseText,
    this.instructions,
    required this.scheduledAt,
    required this.status,
    this.remindedAt,
    this.takenAt,
  });

  DoseEvent copyWith({
    DoseStatus? status,
    DateTime? remindedAt,
    DateTime? takenAt,
  }) {
    return DoseEvent(
      id: id,
      patientId: patientId,
      medicationId: medicationId,
      medicationName: medicationName,
      doseText: doseText,
      instructions: instructions,
      scheduledAt: scheduledAt,
      status: status ?? this.status,
      remindedAt: remindedAt ?? this.remindedAt,
      takenAt: takenAt ?? this.takenAt,
    );
  }
}

class WellnessCheck {
  final int id;
  final int patientId;
  final CheckStatus status;
  final CheckTrigger trigger;
  final int turnCount;
  final String? transcript;
  final String? replyText;
  final String? mood; // good | okay | low
  final String? summaryEn;
  final List<String>? memoryUsed;
  final DateTime createdAt;
  final DateTime? completedAt;

  const WellnessCheck({
    required this.id,
    required this.patientId,
    required this.status,
    required this.trigger,
    this.turnCount = 0,
    this.transcript,
    this.replyText,
    this.mood,
    this.summaryEn,
    this.memoryUsed,
    required this.createdAt,
    this.completedAt,
  });

  WellnessCheck copyWith({
    CheckStatus? status,
    int? turnCount,
    String? transcript,
    String? replyText,
    String? mood,
    String? summaryEn,
    List<String>? memoryUsed,
    DateTime? completedAt,
  }) {
    return WellnessCheck(
      id: id,
      patientId: patientId,
      status: status ?? this.status,
      trigger: trigger,
      turnCount: turnCount ?? this.turnCount,
      transcript: transcript ?? this.transcript,
      replyText: replyText ?? this.replyText,
      mood: mood ?? this.mood,
      summaryEn: summaryEn ?? this.summaryEn,
      memoryUsed: memoryUsed ?? this.memoryUsed,
      createdAt: createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

class SymptomReport {
  final int id;
  final int patientId;
  final int checkId;
  final String symptom;
  final int severity; // 1 to 5
  final DateTime reportedAt;

  const SymptomReport({
    required this.id,
    required this.patientId,
    required this.checkId,
    required this.symptom,
    required this.severity,
    required this.reportedAt,
  });
}

class PatientMemory {
  final int id;
  final int patientId;
  final String kind; // symptom | mood | note
  final String content;
  final int? sourceCheckId;
  final DateTime createdAt;

  const PatientMemory({
    required this.id,
    required this.patientId,
    required this.kind,
    required this.content,
    this.sourceCheckId,
    required this.createdAt,
  });
}

class Alert {
  final int id;
  final int patientId;
  final String patientName;
  final AlertKind kind;
  final AlertPriority priority;
  final int? doseEventId;
  final String? symptom;
  final String message;
  final DateTime createdAt;
  final DateTime? acknowledgedAt;

  const Alert({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.kind,
    required this.priority,
    this.doseEventId,
    this.symptom,
    required this.message,
    required this.createdAt,
    this.acknowledgedAt,
  });

  Alert copyWith({
    DateTime? acknowledgedAt,
  }) {
    return Alert(
      id: id,
      patientId: patientId,
      patientName: patientName,
      kind: kind,
      priority: priority,
      doseEventId: doseEventId,
      symptom: symptom,
      message: message,
      createdAt: createdAt,
      acknowledgedAt: acknowledgedAt ?? this.acknowledgedAt,
    );
  }
}

class CareUpdate {
  final int patientId;
  final DoseEvent? doseEvent;
  final Alert? alert;
  final WellnessCheck? check;
  final Prescription? prescription;

  const CareUpdate({
    required this.patientId,
    this.doseEvent,
    this.alert,
    this.check,
    this.prescription,
  });
}

class TimelineItem {
  final DateTime at;
  final TimelineKind kind;
  final TimelineTone tone;
  final String title;
  final String? detail;

  const TimelineItem({
    required this.at,
    required this.kind,
    required this.tone,
    required this.title,
    this.detail,
  });
}

class SymptomCount {
  final String symptom;
  final int count;
  final int maxSeverity;

  const SymptomCount({
    required this.symptom,
    required this.count,
    required this.maxSeverity,
  });
}

class PatientInsight {
  final Profile patient;
  final int? adherencePct;
  final int? prevAdherencePct;
  final int dosesTaken;
  final int dosesMissed;
  final int checkIns;
  final List<SymptomCount> symptoms;
  final List<Alert> openAlerts;
  final bool reviewRecommended;
  final String aiSummary;
  final WellnessCheck? latestCheck;
  final DateTime generatedAt;

  const PatientInsight({
    required this.patient,
    this.adherencePct,
    this.prevAdherencePct,
    required this.dosesTaken,
    required this.dosesMissed,
    required this.checkIns,
    required this.symptoms,
    required this.openAlerts,
    required this.reviewRecommended,
    required this.aiSummary,
    this.latestCheck,
    required this.generatedAt,
  });
}

class PatientStatus {
  final Profile patient;
  final PatientState state;
  final String headline;
  final DoseEvent? nextDose;
  final int openAlerts;

  const PatientStatus({
    required this.patient,
    required this.state,
    required this.headline,
    this.nextDose,
    required this.openAlerts,
  });
}

