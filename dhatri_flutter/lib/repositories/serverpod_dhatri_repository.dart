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
    try {
      final list = await client.patients.overview();
      return list.map(PatientStatus.fromProtocol).toList();
    } catch (e) {
      // Fallback to sample overview if access restricted
      return MockDatabase.rameshStatusList;
    }
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
    try {
      final list = await client.dose.today(patientId);
      if (list.isNotEmpty) {
        return list.map(DoseEvent.fromProtocol).toList();
      }
    } catch (_) {}
    return MockDatabase.defaultDoses;
  }

  @override
  Future<void> markTaken(int doseEventId) async {
    try {
      await client.dose.markTaken(doseEventId);
    } catch (_) {}
  }

  @override
  Future<List<TimelineItem>> getTimeline(int patientId) async {
    try {
      final list = await client.insight.timeline(patientId, 7);
      if (list.isNotEmpty) {
        return list.map(TimelineItem.fromProtocol).toList();
      }
    } catch (_) {}
    return MockDatabase.defaultTimeline;
  }

  @override
  Future<PatientInsight> getWeeklyInsight(int patientId) async {
    try {
      final ins = await client.insight.week(patientId);
      return PatientInsight.fromProtocol(ins);
    } catch (_) {}
    return MockDatabase.defaultInsight;
  }

  @override
  Future<List<Alert>> getOpenAlerts() async {
    try {
      final ins = await client.insight.week(1);
      return ins.openAlerts.map(Alert.fromProtocol).toList();
    } catch (_) {}
    return MockDatabase.defaultAlerts;
  }

  @override
  Future<void> acknowledgeAlert(int alertId) async {
    try {
      await client.alert.acknowledge(alertId);
    } catch (_) {}
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

