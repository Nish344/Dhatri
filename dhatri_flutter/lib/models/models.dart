/// Domain models matching ARCHITECTURE.md §4 and synchronized with dhatri_client protocol.
import 'package:dhatri_client/dhatri_client.dart' as protocol;

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

  factory Profile.fromProtocol(protocol.Profile p) {
    return Profile(
      id: p.id ?? 1,
      authUserId: p.authUserId,
      name: p.name,
      role: Role.values.byName(p.role.name),
      age: p.age,
      phone: p.phone,
      caregiverId: p.caregiverId,
      doctorId: p.doctorId,
      linkCode: p.linkCode,
    );
  }

  protocol.Profile toProtocol() {
    return protocol.Profile(
      id: id,
      authUserId: authUserId,
      name: name,
      role: protocol.Role.values.byName(role.name),
      age: age,
      phone: phone,
      caregiverId: caregiverId,
      doctorId: doctorId,
      linkCode: linkCode,
    );
  }

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

  factory MedicationDraft.fromProtocol(protocol.MedicationDraft p) {
    return MedicationDraft(
      name: p.name,
      strength: p.strength,
      doseText: p.doseText,
      instructions: p.instructions,
      times: List<String>.from(p.times),
      durationDays: p.durationDays,
      uncertain: p.uncertain,
    );
  }

  protocol.MedicationDraft toProtocol() {
    return protocol.MedicationDraft(
      name: name,
      strength: strength,
      doseText: doseText,
      instructions: instructions,
      times: times,
      durationDays: durationDays,
      uncertain: uncertain,
    );
  }
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

  factory Prescription.fromProtocol(protocol.Prescription p) {
    return Prescription(
      id: p.id ?? 0,
      patientId: p.patientId,
      storageId: p.storageId,
      path: p.path,
      status: PrescriptionStatus.values.byName(p.status.name),
      extractedJson: p.extractedJson,
      error: p.error,
      createdAt: p.createdAt.toLocal(),
    );
  }

  protocol.Prescription toProtocol() {
    return protocol.Prescription(
      id: id,
      patientId: patientId,
      storageId: storageId,
      path: path,
      status: protocol.PrescriptionStatus.values.byName(status.name),
      extractedJson: extractedJson,
      error: error,
      createdAt: createdAt.toUtc(),
    );
  }

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

  factory Medication.fromProtocol(protocol.Medication p) {
    return Medication(
      id: p.id ?? 0,
      patientId: p.patientId,
      prescriptionId: p.prescriptionId,
      name: p.name,
      strength: p.strength,
      doseText: p.doseText,
      instructions: p.instructions,
      times: List<String>.from(p.times),
      startDate: p.startDate.toLocal(),
      endDate: p.endDate.toLocal(),
      active: p.active,
    );
  }

  protocol.Medication toProtocol() {
    return protocol.Medication(
      id: id,
      patientId: patientId,
      prescriptionId: prescriptionId,
      name: name,
      strength: strength,
      doseText: doseText,
      instructions: instructions,
      times: times,
      startDate: startDate.toUtc(),
      endDate: endDate.toUtc(),
      active: active,
    );
  }
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

  factory DoseEvent.fromProtocol(
    protocol.DoseEvent p, {
    String? medicationName,
    String? doseText,
    String? instructions,
  }) {
    return DoseEvent(
      id: p.id ?? 0,
      patientId: p.patientId,
      medicationId: p.medicationId,
      medicationName: medicationName ?? _defaultMedName(p.medicationId),
      doseText: doseText ?? '1 tablet',
      instructions: instructions ?? 'With water',
      scheduledAt: p.scheduledAt.toLocal(),
      status: DoseStatus.values.byName(p.status.name),
      remindedAt: p.remindedAt?.toLocal(),
      takenAt: p.takenAt?.toLocal(),
    );
  }

  static String _defaultMedName(int medId) {
    switch (medId) {
      case 1:
        return 'Metformin 500 mg';
      case 2:
        return 'Amlodipine 5 mg';
      case 3:
        return 'Atorvastatin 20 mg';
      default:
        return 'Prescription Medicine';
    }
  }

  protocol.DoseEvent toProtocol() {
    return protocol.DoseEvent(
      id: id,
      patientId: patientId,
      medicationId: medicationId,
      scheduledAt: scheduledAt.toUtc(),
      status: protocol.DoseStatus.values.byName(status.name),
      remindedAt: remindedAt?.toUtc(),
      takenAt: takenAt?.toUtc(),
    );
  }

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

  factory WellnessCheck.fromProtocol(protocol.WellnessCheck p) {
    return WellnessCheck(
      id: p.id ?? 0,
      patientId: p.patientId,
      status: CheckStatus.values.byName(p.status.name),
      trigger: CheckTrigger.values.byName(p.trigger.name),
      turnCount: p.turnCount,
      transcript: p.transcript,
      replyText: p.replyText,
      mood: p.mood,
      summaryEn: p.summaryEn,
      memoryUsed: p.memoryUsed != null ? List<String>.from(p.memoryUsed!) : null,
      createdAt: p.createdAt.toLocal(),
      completedAt: p.completedAt?.toLocal(),
    );
  }

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

  factory SymptomReport.fromProtocol(protocol.SymptomReport p) {
    return SymptomReport(
      id: p.id ?? 0,
      patientId: p.patientId,
      checkId: p.checkId,
      symptom: p.symptom,
      severity: p.severity,
      reportedAt: p.reportedAt.toLocal(),
    );
  }
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

  factory PatientMemory.fromProtocol(protocol.PatientMemory p) {
    return PatientMemory(
      id: p.id ?? 0,
      patientId: p.patientId,
      kind: p.kind,
      content: p.content,
      sourceCheckId: p.sourceCheckId,
      createdAt: p.createdAt.toLocal(),
    );
  }
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

  factory Alert.fromProtocol(protocol.Alert p, {String? patientName}) {
    return Alert(
      id: p.id ?? 0,
      patientId: p.patientId,
      patientName: patientName ?? 'Ramesh Kumar',
      kind: AlertKind.values.byName(p.kind.name),
      priority: AlertPriority.values.byName(p.priority.name),
      doseEventId: p.doseEventId,
      symptom: p.symptom,
      message: p.message,
      createdAt: p.createdAt.toLocal(),
      acknowledgedAt: p.acknowledgedAt?.toLocal(),
    );
  }

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

  factory CareUpdate.fromProtocol(protocol.CareUpdate p) {
    return CareUpdate(
      patientId: p.patientId,
      doseEvent: p.doseEvent != null ? DoseEvent.fromProtocol(p.doseEvent!) : null,
      alert: p.alert != null ? Alert.fromProtocol(p.alert!) : null,
      check: p.check != null ? WellnessCheck.fromProtocol(p.check!) : null,
      prescription: p.prescription != null ? Prescription.fromProtocol(p.prescription!) : null,
    );
  }
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

  factory TimelineItem.fromProtocol(protocol.TimelineItem p) {
    return TimelineItem(
      at: p.at.toLocal(),
      kind: TimelineKind.values.byName(p.kind.name),
      tone: TimelineTone.values.byName(p.tone.name),
      title: p.title,
      detail: p.detail,
    );
  }
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

  factory SymptomCount.fromProtocol(protocol.SymptomCount p) {
    return SymptomCount(
      symptom: p.symptom,
      count: p.count,
      maxSeverity: p.maxSeverity,
    );
  }
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

  factory PatientInsight.fromProtocol(protocol.PatientInsight p) {
    return PatientInsight(
      patient: Profile.fromProtocol(p.patient),
      adherencePct: p.adherencePct,
      prevAdherencePct: p.prevAdherencePct,
      dosesTaken: p.dosesTaken,
      dosesMissed: p.dosesMissed,
      checkIns: p.checkIns,
      symptoms: p.symptoms.map(SymptomCount.fromProtocol).toList(),
      openAlerts: p.openAlerts.map(Alert.fromProtocol).toList(),
      reviewRecommended: p.reviewRecommended,
      aiSummary: p.aiSummary,
      latestCheck: p.latestCheck != null ? WellnessCheck.fromProtocol(p.latestCheck!) : null,
      generatedAt: p.generatedAt.toLocal(),
    );
  }
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

  factory PatientStatus.fromProtocol(protocol.PatientStatus p) {
    return PatientStatus(
      patient: Profile.fromProtocol(p.patient),
      state: PatientState.values.byName(p.state.name),
      headline: p.headline,
      nextDose: p.nextDose != null ? DoseEvent.fromProtocol(p.nextDose!) : null,
      openAlerts: p.openAlerts,
    );
  }
}

class UploadTicket {
  final String path;
  final String description;

  const UploadTicket({
    required this.path,
    required this.description,
  });

  factory UploadTicket.fromProtocol(protocol.UploadTicket p) {
    return UploadTicket(
      path: p.path,
      description: p.description,
    );
  }
}

