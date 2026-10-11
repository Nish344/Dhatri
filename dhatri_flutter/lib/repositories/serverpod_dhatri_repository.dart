import 'dart:async';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:dhatri_client/dhatri_client.dart' as protocol;
import '../core/constants/copy_hindi.dart';
import '../models/models.dart';
import '../services/serverpod_client_service.dart';
import '../state/auth_state.dart';
import 'dhatri_repository.dart';

class ServerpodDhatriRepository implements DhatriRepository {
  final protocol.Client client;
  final ServerpodClientService? clientService;

  final Set<int> _locallyTakenDoseIds = {};
  final Set<int> _acknowledgedAlertIds = {};

  ServerpodDhatriRepository({
    required this.client,
    this.clientService,
  });

  Future<bool> _isAuth() async {
    if (clientService != null) {
      return await clientService!.isAuthenticated;
    }
    final key = await client.authKeyProvider?.get();
    return key != null && key.trim().isNotEmpty;
  }

  @override
  Future<Profile?> getCurrentProfile() async {
    if (await _isAuth()) {
      try {
        final p = await client.profile.me();
        if (p != null) return Profile.fromProtocol(p);
      } catch (_) {}
    }
    return null;
  }

  @override
  Future<Profile> registerProfile(
    String name,
    Role role,
    int? age,
    String? phone,
  ) async {
    if (await _isAuth()) {
      try {
        final p = await client.profile.register(
          name,
          protocol.Role.values.byName(role.name),
          age,
          phone,
        );
        return Profile.fromProtocol(p);
      } catch (_) {}
    }
    return Profile(
      id: 1,
      name: name,
      role: role,
      age: age,
      phone: phone,
    );
  }

  @override
  Future<Profile> linkWithCode(String code) async {
    if (await _isAuth()) {
      try {
        final p = await client.profile.link(code);
        return Profile.fromProtocol(p);
      } catch (_) {}
    }
    return AuthState.defaultPatient;
  }

  @override
  Future<List<Profile>> getMyPatients() async {
    if (await _isAuth()) {
      try {
        final list = await client.profile.myPatients();
        if (list.isNotEmpty) return list.map(Profile.fromProtocol).toList();
      } catch (_) {}
    }
    return [AuthState.defaultPatient];
  }

  @override
  Future<List<PatientStatus>> getOverview() async {
    if (await _isAuth()) {
      try {
        final list = await client.patients.overview();
        if (list.isNotEmpty) return list.map(PatientStatus.fromProtocol).toList();
      } catch (_) {}
    }
    return _demoOverview();
  }

  @override
  Future<Profile?> getCaregiverContact(int patientId) async {
    if (await _isAuth()) {
      try {
        final c = await client.profile.caregiverContact(patientId);
        if (c != null) return Profile.fromProtocol(c);
      } catch (_) {}
    }
    return AuthState.defaultCaregiver;
  }

  @override
  Future<List<DoseEvent>> getTodayDoses(int patientId) async {
    if (await _isAuth()) {
      try {
        final list = await client.dose.today(patientId);
        if (list.isNotEmpty) return list.map(DoseEvent.fromProtocol).toList();
      } catch (_) {}
    }
    return _demoTodayDoses();
  }

  @override
  Future<void> markTaken(int doseEventId) async {
    _locallyTakenDoseIds.add(doseEventId);
    if (await _isAuth()) {
      try {
        await client.dose.markTaken(doseEventId);
      } catch (_) {}
    }
  }

  @override
  Future<List<TimelineItem>> getTimeline(int patientId) async {
    if (await _isAuth()) {
      try {
        final list = await client.insight.timeline(patientId, 7);
        if (list.isNotEmpty) return list.map(TimelineItem.fromProtocol).toList();
      } catch (_) {}
    }
    return _demoTimeline();
  }

  @override
  Future<PatientInsight> getWeeklyInsight(int patientId) async {
    if (await _isAuth()) {
      try {
        final ins = await client.insight.week(patientId);
        return PatientInsight.fromProtocol(ins);
      } catch (_) {}
    }
    return _demoWeeklyInsight();
  }

  @override
  Future<List<Alert>> getOpenAlerts([int? patientId]) async {
    if (await _isAuth()) {
      try {
        final pid = patientId ?? 1;
        final ins = await client.insight.week(pid);
        final patientName = ins.patient.name;
        return ins.openAlerts
            .map((a) => Alert.fromProtocol(a, patientName: patientName))
            .where((a) => !_acknowledgedAlertIds.contains(a.id))
            .toList();
      } catch (_) {}
    }
    return _demoOpenAlerts();
  }

  @override
  Future<void> acknowledgeAlert(int alertId) async {
    _acknowledgedAlertIds.add(alertId);
    if (await _isAuth()) {
      try {
        await client.alert.acknowledge(alertId);
      } catch (_) {}
    }
  }

  @override
  Future<void> triggerEmergencyHelp(int patientId) async {
    if (await _isAuth()) {
      try {
        await client.alert.needHelp(patientId);
      } catch (_) {}
    }
  }

  @override
  Future<UploadTicket> getPrescriptionUploadTicket(int patientId) async {
    final ticket = await client.prescription.uploadTicket(patientId);
    return UploadTicket(path: ticket.path, description: ticket.description);
  }

  @override
  Future<bool> uploadPrescriptionBytes(UploadTicket ticket, List<int> bytes) async {
    try {
      final uploader = protocol.FileUploader(ticket.description);
      final stream = Stream.value(bytes);
      return await uploader.upload(stream, bytes.length);
    } catch (_) {
      try {
        final uri = Uri.parse(ticket.description);
        final res = await http.put(uri, body: bytes);
        return res.statusCode >= 200 && res.statusCode < 300;
      } catch (_) {
        return false;
      }
    }
  }

  @override
  Future<Prescription> submitPrescription(int patientId, String storagePath) async {
    final rx = await client.prescription.submit(patientId, storagePath);
    return Prescription.fromProtocol(rx);
  }

  @override
  Future<List<MedicationDraft>> getPrescriptionDrafts(int prescriptionId) async {
    final drafts = await client.prescription.drafts(prescriptionId);
    return drafts.map(MedicationDraft.fromProtocol).toList();
  }

  @override
  Future<List<Medication>> confirmPrescription(
    int prescriptionId,
    List<MedicationDraft> drafts,
  ) async {
    final protoDrafts = drafts.map((d) => d.toProtocol()).toList();
    final meds = await client.prescription.confirm(prescriptionId, protoDrafts);
    return meds.map(Medication.fromProtocol).toList();
  }

  @override
  Future<List<MedicationDraft>> extractDraftsFromPrescription(
    int patientId,
    String storagePath,
  ) async {
    final rx = await client.prescription.submit(patientId, storagePath);

    // Poll for Gemini OCR background processing (up to 8 retries)
    for (int i = 0; i < 8; i++) {
      await Future.delayed(const Duration(milliseconds: 1500));
      final drafts = await client.prescription.drafts(rx.id!);
      if (drafts.isNotEmpty) {
        return drafts.map(MedicationDraft.fromProtocol).toList();
      }
    }
    return [];
  }

  @override
  Stream<CareUpdate> watchPatient(int patientId) {
    final controller = StreamController<CareUpdate>.broadcast();
    StreamSubscription? sub;

    void connect() async {
      try {
        final auth = await _isAuth();
        if (!auth) {
          // In unauthenticated / demo mode, avoid WebSocket connect to prevent 401 disconnect loops
          return;
        }
        sub = client.careStream.watch(patientId).listen(
          (protoUpdate) {
            if (!controller.isClosed) {
              controller.add(CareUpdate.fromProtocol(protoUpdate));
            }
          },
          onError: (_) {},
          onDone: () {},
        );
      } catch (_) {}
    }

    controller.onListen = connect;
    controller.onCancel = () {
      sub?.cancel();
    };

    return controller.stream;
  }

  // --- Real AI Voice Check-In (Sarvam STT + Gemini) with Fallback ---

  @override
  Future<void> startCheckIn(int patientId) async {
    if (await _isAuth()) {
      try {
        await client.checkIn.startNow(patientId);
      } catch (_) {}
    }
  }

  @override
  Future<WellnessCheck?> getPendingCheckIn(int patientId) async {
    if (await _isAuth()) {
      try {
        final c = await client.checkIn.pending(patientId);
        if (c != null) return WellnessCheck.fromProtocol(c);
      } catch (_) {}
    }
    return WellnessCheck(
      id: 1,
      patientId: patientId,
      status: CheckStatus.active,
      trigger: CheckTrigger.daily,
      turnCount: 0,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<protocol.CheckInTurn> acceptCheckIn(int checkId) async {
    if (await _isAuth()) {
      try {
        return await client.checkIn.accept(checkId);
      } catch (_) {}
    }
    return protocol.CheckInTurn(
      turnIndex: 1,
      text: CopyHindi.greetingQuestion,
      done: false,
    );
  }

  @override
  Future<protocol.CheckInTurn> answerCheckInText(
    int checkId,
    String transcript,
  ) async {
    if (await _isAuth()) {
      try {
        return await client.checkIn.answerText(checkId, transcript);
      } catch (_) {}
    }

    final lower = transcript.toLowerCase();
    if (transcript.contains('कमजोरी') ||
        lower.contains('weakness') ||
        transcript.contains('चक्कर') ||
        transcript.contains('dizzy')) {
      return protocol.CheckInTurn(
        turnIndex: 2,
        text: CopyHindi.followUpWithMemory,
        done: false,
      );
    }

    return protocol.CheckInTurn(
      turnIndex: 3,
      text: CopyHindi.closingThankYou,
      done: true,
    );
  }

  @override
  Future<protocol.CheckInTurn> answerCheckInAudio(
    int checkId,
    ByteData audio,
  ) async {
    if (await _isAuth()) {
      try {
        return await client.checkIn.answer(checkId, audio);
      } catch (_) {}
    }
    return protocol.CheckInTurn(
      turnIndex: 2,
      text: CopyHindi.followUpWithMemory,
      done: false,
    );
  }

  @override
  Future<void> snoozeCheckIn(int checkId) async {
    if (await _isAuth()) {
      try {
        await client.checkIn.snooze(checkId);
      } catch (_) {}
    }
  }

  // --- Seeded Ramesh Kumar 7-Day Demo Dataset (docs/DEMO.md §39-47) ---

  List<DoseEvent> _demoTodayDoses() {
    final now = DateTime.now();
    return [
      DoseEvent(
        id: 1,
        patientId: 1,
        medicationId: 1,
        medicationName: 'Metformin',
        doseText: '1 tablet',
        instructions: 'After meals',
        scheduledAt: DateTime(now.year, now.month, now.day, 8, 0),
        status: DoseStatus.taken,
        takenAt: DateTime(now.year, now.month, now.day, 8, 5),
      ),
      DoseEvent(
        id: 2,
        patientId: 1,
        medicationId: 2,
        medicationName: 'Amlodipine',
        doseText: '1 tablet',
        instructions: 'Morning with water',
        scheduledAt: DateTime(now.year, now.month, now.day, 8, 0),
        status: DoseStatus.taken,
        takenAt: DateTime(now.year, now.month, now.day, 8, 6),
      ),
      DoseEvent(
        id: 3,
        patientId: 1,
        medicationId: 1,
        medicationName: 'Metformin',
        doseText: '1 tablet',
        instructions: 'After dinner',
        scheduledAt: DateTime(now.year, now.month, now.day, 20, 0),
        status: _locallyTakenDoseIds.contains(3)
            ? DoseStatus.taken
            : DoseStatus.reminded,
        remindedAt: DateTime(now.year, now.month, now.day, 20, 0),
        takenAt: _locallyTakenDoseIds.contains(3) ? now : null,
      ),
      DoseEvent(
        id: 4,
        patientId: 1,
        medicationId: 3,
        medicationName: 'Atorvastatin',
        doseText: '1 tablet',
        instructions: 'Bedtime',
        scheduledAt: DateTime(now.year, now.month, now.day, 22, 0),
        status: _locallyTakenDoseIds.contains(4)
            ? DoseStatus.taken
            : DoseStatus.scheduled,
        takenAt: _locallyTakenDoseIds.contains(4) ? now : null,
      ),
    ];
  }

  List<Alert> _demoOpenAlerts() {
    final now = DateTime.now();
    final allAlerts = [
      Alert(
        id: 1,
        patientId: 1,
        patientName: 'Ramesh Kumar',
        kind: AlertKind.repeatedSymptom,
        priority: AlertPriority.important,
        symptom: 'weakness',
        message: 'Repeated weakness reported across 3 check-ins (severity 3/5)',
        createdAt: now.subtract(const Duration(hours: 4)),
      ),
      Alert(
        id: 2,
        patientId: 1,
        patientName: 'Ramesh Kumar',
        kind: AlertKind.missedDose,
        priority: AlertPriority.attention,
        doseEventId: 10,
        message: 'Missed evening Metformin 500mg dose 2 days ago',
        createdAt: now.subtract(const Duration(days: 2)),
      ),
    ];
    return allAlerts.where((a) => !_acknowledgedAlertIds.contains(a.id)).toList();
  }

  List<TimelineItem> _demoTimeline() {
    final now = DateTime.now();
    return [
      TimelineItem(
        at: DateTime(now.year, now.month, now.day, 8, 5),
        kind: TimelineKind.dose,
        tone: TimelineTone.good,
        title: 'Morning doses taken on time',
        detail: 'Metformin 500mg, Amlodipine 5mg',
      ),
      TimelineItem(
        at: now.subtract(const Duration(days: 1)).copyWith(hour: 20, minute: 30),
        kind: TimelineKind.wellness,
        tone: TimelineTone.warning,
        title: 'Evening wellness check-in',
        detail: 'Weakness (severity 3/5) with mild dizziness reported',
      ),
      TimelineItem(
        at: now.subtract(const Duration(days: 1)).copyWith(hour: 20, minute: 5),
        kind: TimelineKind.dose,
        tone: TimelineTone.good,
        title: 'Evening dose taken',
        detail: 'Metformin 500mg taken after meal',
      ),
      TimelineItem(
        at: now.subtract(const Duration(days: 2)).copyWith(hour: 20, minute: 0),
        kind: TimelineKind.dose,
        tone: TimelineTone.missed,
        title: 'Missed evening dose',
        detail: 'Metformin 500mg reminder expired without confirmation',
      ),
      TimelineItem(
        at: now.subtract(const Duration(days: 3)).copyWith(hour: 20, minute: 30),
        kind: TimelineKind.wellness,
        tone: TimelineTone.warning,
        title: 'Wellness check completed',
        detail: 'Mild fatigue & weakness reported (severity 2/5)',
      ),
      TimelineItem(
        at: now.subtract(const Duration(days: 3)).copyWith(hour: 8, minute: 5),
        kind: TimelineKind.dose,
        tone: TimelineTone.good,
        title: 'Morning doses taken',
        detail: 'Metformin 500mg, Amlodipine 5mg',
      ),
      TimelineItem(
        at: now.subtract(const Duration(days: 5)).copyWith(hour: 8, minute: 30),
        kind: TimelineKind.wellness,
        tone: TimelineTone.good,
        title: 'Routine morning check-in',
        detail: 'Feeling active, completed 20-min morning garden walk',
      ),
    ];
  }

  PatientInsight _demoWeeklyInsight() {
    final now = DateTime.now();
    return PatientInsight(
      patient: AuthState.defaultPatient,
      adherencePct: 86,
      prevAdherencePct: 92,
      dosesTaken: 12,
      dosesMissed: 2,
      checkIns: 4,
      symptoms: const [
        SymptomCount(symptom: 'weakness', count: 3, maxSeverity: 3),
        SymptomCount(symptom: 'dizziness', count: 1, maxSeverity: 2),
      ],
      openAlerts: _demoOpenAlerts(),
      reviewRecommended: true,
      aiSummary:
          'Ramesh had 86% medication adherence this week (down from 92%). Persistent weakness was reported during recent check-ins with mild dizziness noted. Evening Metformin doses require continuous family oversight, and a clinical review is recommended.',
      latestCheck: WellnessCheck(
        id: 1,
        patientId: 1,
        status: CheckStatus.completed,
        trigger: CheckTrigger.daily,
        turnCount: 2,
        mood: 'low',
        summaryEn: 'Weakness (severity 3) with mild dizziness.',
        memoryUsed: const ['Weakness reported 3 days ago'],
        createdAt: now.subtract(const Duration(days: 1)),
        completedAt: now.subtract(const Duration(days: 1)),
      ),
      generatedAt: now,
    );
  }

  List<PatientStatus> _demoOverview() {
    final doses = _demoTodayDoses();
    final next = doses.firstWhere(
      (d) => d.status == DoseStatus.reminded || d.status == DoseStatus.scheduled,
      orElse: () => doses.first,
    );
    final alerts = _demoOpenAlerts();

    return [
      PatientStatus(
        patient: AuthState.defaultPatient,
        state: alerts.isNotEmpty ? PatientState.attention : PatientState.allGood,
        headline: 'Evening Metformin reminded · Mild weakness noted',
        nextDose: next,
        openAlerts: alerts.length,
      ),
    ];
  }
}
