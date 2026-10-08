import 'dart:async';
import 'package:dhatri_client/dhatri_client.dart' as protocol;
import '../models/models.dart';
import '../mock_engine/mock_database.dart';
import '../mock_engine/mock_prescription_samples.dart';
import 'dhatri_repository.dart';

class ServerpodDhatriRepository implements DhatriRepository {
  final protocol.Client client;

  ServerpodDhatriRepository({required this.client});

  @override
  bool get isLiveBackend => true;

  @override
  Future<Profile> getCurrentProfile() async {
    try {
      final p = await client.profile.me();
      if (p != null) return Profile.fromProtocol(p);
    } catch (_) {}
    return MockDatabase.ramesh;
  }

  @override
  Future<List<PatientStatus>> getOverview() async {
    final list = await client.patients.overview();
    return list.map(PatientStatus.fromProtocol).toList();
  }

  @override
  Future<Profile?> getCaregiverContact(int patientId) async {
    try {
      final c = await client.profile.caregiverContact(patientId);
      if (c != null) return Profile.fromProtocol(c);
    } catch (_) {}
    return MockDatabase.ananya;
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
  Future<List<Alert>> getOpenAlerts() async {
    final ins = await client.insight.week(1);
    return ins.openAlerts.map(Alert.fromProtocol).toList();
  }

  @override
  Future<void> acknowledgeAlert(int alertId) async {
    await client.alert.acknowledge(alertId);
  }

  @override
  Future<void> triggerEmergencyHelp(int patientId) async {
    try {
      await client.alert.needHelp(patientId);
    } catch (_) {}
  }

  @override
  Future<List<MedicationDraft>> extractDraftsFromPrescription(String path) async {
    try {
      final ticket = await client.prescription.uploadTicket(1);
      final rx = await client.prescription.submit(1, ticket.path);
      // Wait briefly for background Gemini extraction
      await Future.delayed(const Duration(milliseconds: 1500));
      final drafts = await client.prescription.drafts(rx.id!);
      if (drafts.isNotEmpty) {
        return drafts.map(MedicationDraft.fromProtocol).toList();
      }
    } catch (_) {}
    return MockPrescriptionSamples.getSampleDrafts();
  }

  @override
  Future<void> confirmPrescription(List<MedicationDraft> drafts) async {
    try {
      final protoDrafts = drafts.map((d) => d.toProtocol()).toList();
      await client.prescription.confirm(1, protoDrafts);
    } catch (_) {}
  }

  @override
  Stream<CareUpdate> watchPatient(int patientId) {
    try {
      return client.careStream.watch(patientId).map(CareUpdate.fromProtocol);
    } catch (_) {
      return const Stream.empty();
    }
  }

  // --- Real AI Voice Check-In Extensions ---

  Future<void> startCheckIn(int patientId) async {
    await client.checkIn.startNow(patientId);
  }

  Future<protocol.WellnessCheck?> getPendingCheckIn(int patientId) async {
    return client.checkIn.pending(patientId);
  }

  Future<protocol.CheckInTurn> acceptCheckIn(int checkId) async {
    return client.checkIn.accept(checkId);
  }

  Future<protocol.CheckInTurn> answerCheckInText(
    int checkId,
    String transcript,
  ) async {
    return client.checkIn.answerText(checkId, transcript);
  }

  Future<void> snoozeCheckIn(int checkId) async {
    await client.checkIn.snooze(checkId);
  }
}

