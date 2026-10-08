import 'dart:async';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:dhatri_client/dhatri_client.dart' as protocol;
import '../models/models.dart';
import 'dhatri_repository.dart';

class ServerpodDhatriRepository implements DhatriRepository {
  final protocol.Client client;

  ServerpodDhatriRepository({required this.client});

  @override
  Future<Profile?> getCurrentProfile() async {
    final p = await client.profile.me();
    return p != null ? Profile.fromProtocol(p) : null;
  }

  @override
  Future<Profile> registerProfile(
    String name,
    Role role,
    int? age,
    String? phone,
  ) async {
    final p = await client.profile.register(
      name,
      protocol.Role.values.byName(role.name),
      age,
      phone,
    );
    return Profile.fromProtocol(p);
  }

  @override
  Future<Profile> linkWithCode(String code) async {
    final p = await client.profile.link(code);
    return Profile.fromProtocol(p);
  }

  @override
  Future<List<Profile>> getMyPatients() async {
    final list = await client.profile.myPatients();
    return list.map(Profile.fromProtocol).toList();
  }

  @override
  Future<List<PatientStatus>> getOverview() async {
    final list = await client.patients.overview();
    return list.map(PatientStatus.fromProtocol).toList();
  }

  @override
  Future<Profile?> getCaregiverContact(int patientId) async {
    final c = await client.profile.caregiverContact(patientId);
    return c != null ? Profile.fromProtocol(c) : null;
  }

  @override
  Future<List<DoseEvent>> getTodayDoses(int patientId) async {
    final list = await client.dose.today(patientId);
    return list.map(DoseEvent.fromProtocol).toList();
  }

  @override
  Future<void> markTaken(int doseEventId) async {
    await client.dose.markTaken(doseEventId);
  }

  @override
  Future<List<TimelineItem>> getTimeline(int patientId) async {
    final list = await client.insight.timeline(patientId, 7);
    return list.map(TimelineItem.fromProtocol).toList();
  }

  @override
  Future<PatientInsight> getWeeklyInsight(int patientId) async {
    final ins = await client.insight.week(patientId);
    return PatientInsight.fromProtocol(ins);
  }

  @override
  Future<List<Alert>> getOpenAlerts([int? patientId]) async {
    final pid = patientId ?? 1;
    final ins = await client.insight.week(pid);
    final patientName = ins.patient.name;
    return ins.openAlerts
        .map((a) => Alert.fromProtocol(a, patientName: patientName))
        .toList();
  }

  @override
  Future<void> acknowledgeAlert(int alertId) async {
    await client.alert.acknowledge(alertId);
  }

  @override
  Future<void> triggerEmergencyHelp(int patientId) async {
    await client.alert.needHelp(patientId);
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
    try {
      return client.careStream.watch(patientId).map(CareUpdate.fromProtocol);
    } catch (_) {
      return const Stream.empty();
    }
  }

  // --- Real AI Voice Check-In (Sarvam STT + Gemini) ---

  @override
  Future<void> startCheckIn(int patientId) async {
    await client.checkIn.startNow(patientId);
  }

  @override
  Future<WellnessCheck?> getPendingCheckIn(int patientId) async {
    final c = await client.checkIn.pending(patientId);
    return c != null ? WellnessCheck.fromProtocol(c) : null;
  }

  @override
  Future<protocol.CheckInTurn> acceptCheckIn(int checkId) async {
    return client.checkIn.accept(checkId);
  }

  @override
  Future<protocol.CheckInTurn> answerCheckInText(
    int checkId,
    String transcript,
  ) async {
    return client.checkIn.answerText(checkId, transcript);
  }

  @override
  Future<protocol.CheckInTurn> answerCheckInAudio(
    int checkId,
    ByteData audio,
  ) async {
    return client.checkIn.answer(checkId, audio);
  }

  @override
  Future<void> snoozeCheckIn(int checkId) async {
    await client.checkIn.snooze(checkId);
  }
}
