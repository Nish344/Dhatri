import '../models/models.dart';
import '../mock_engine/mock_database.dart';
import '../mock_engine/mock_care_stream.dart';
import '../mock_engine/mock_voice_engine.dart';
import '../mock_engine/mock_prescription_samples.dart';

abstract class DhatriRepository {
  bool get isLiveBackend;

  // Profiles
  Future<Profile> getCurrentProfile();
  Future<List<PatientStatus>> getOverview();
  Future<Profile?> getCaregiverContact(int patientId);

  // Doses
  Future<List<DoseEvent>> getTodayDoses(int patientId);
  Future<void> markTaken(int doseEventId);

  // Timeline & Insights
  Future<List<TimelineItem>> getTimeline(int patientId);
  Future<PatientInsight> getWeeklyInsight(int patientId);

  // Alerts
  Future<List<Alert>> getOpenAlerts();
  Future<void> acknowledgeAlert(int alertId);
  Future<void> triggerEmergencyHelp(int patientId);

  // Prescriptions
  Future<List<MedicationDraft>> extractDraftsFromPrescription(String path);
  Future<void> confirmPrescription(List<MedicationDraft> drafts);

  // Stream
  Stream<CareUpdate> watchPatient(int patientId);
}

class MockDhatriRepository implements DhatriRepository {
  final MockDatabase db;
  final MockCareStream careStream;
  final MockVoiceEngine voiceEngine;

  MockDhatriRepository({
    required this.db,
    required this.careStream,
    required this.voiceEngine,
  });

  @override
  bool get isLiveBackend => false;

  @override
  Future<Profile> getCurrentProfile() async => MockDatabase.ramesh;

  @override
  Future<List<PatientStatus>> getOverview() async => db.getOverview();

  @override
  Future<Profile?> getCaregiverContact(int patientId) async => MockDatabase.ananya;

  @override
  Future<List<DoseEvent>> getTodayDoses(int patientId) async =>
      List.from(db.doseEvents.where((d) => d.patientId == patientId));

  @override
  Future<void> markTaken(int doseEventId) async => careStream.takeDose(doseEventId);

  @override
  Future<List<TimelineItem>> getTimeline(int patientId) async => db.getTimeline(patientId);

  @override
  Future<PatientInsight> getWeeklyInsight(int patientId) async => db.getInsight(patientId);

  @override
  Future<List<Alert>> getOpenAlerts() async =>
      List.from(db.alerts.where((a) => a.acknowledgedAt == null));

  @override
  Future<void> acknowledgeAlert(int alertId) async => careStream.acknowledgeAlert(alertId);

  @override
  Future<void> triggerEmergencyHelp(int patientId) async {
    final alert = Alert(
      id: DateTime.now().millisecondsSinceEpoch,
      patientId: patientId,
      patientName: 'Ramesh Kumar',
      kind: AlertKind.patientHelp,
      priority: AlertPriority.high,
      message: '🚨 Ramesh pressed "Something feels wrong" — immediate check required!',
      createdAt: DateTime.now(),
    );
    db.alerts.insert(0, alert);
    careStream.postUpdate(CareUpdate(patientId: patientId, alert: alert));
  }

  @override
  Future<List<MedicationDraft>> extractDraftsFromPrescription(String path) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return MockPrescriptionSamples.getSampleDrafts();
  }

  @override
  Future<void> confirmPrescription(List<MedicationDraft> drafts) async {
    MockPrescriptionSamples.confirmDrafts(
      db: db,
      careStream: careStream,
      drafts: drafts,
    );
  }

  @override
  Stream<CareUpdate> watchPatient(int patientId) => careStream.watch(patientId);
}

