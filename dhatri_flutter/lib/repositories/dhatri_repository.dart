import '../models/models.dart';

abstract class DhatriRepository {
  // Profiles & Auth
  Future<Profile?> getCurrentProfile();
  Future<List<PatientStatus>> getOverview();
  Future<Profile?> getCaregiverContact(int patientId);
  Future<Profile> registerProfile(String name, Role role, int? age, String? phone);
  Future<Profile> linkWithCode(String code);

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
  Future<UploadTicket> getPrescriptionUploadTicket(int patientId);
  Future<Prescription> submitPrescription(int patientId, String storagePath);
  Future<List<MedicationDraft>> getPrescriptionDrafts(int prescriptionId);
  Future<List<Medication>> confirmPrescription(int prescriptionId, List<MedicationDraft> drafts);
  Future<List<MedicationDraft>> extractDraftsFromPrescription(int patientId, String storagePath);

  // Real-time WebSocket Stream
  Stream<CareUpdate> watchPatient(int patientId);
}
