import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/serverpod_client_service.dart';
import 'dhatri_repository.dart';
import 'serverpod_dhatri_repository.dart';

/// Hybrid repository that automatically connects to live Serverpod backend
/// when online, and falls back gracefully to deterministic local mock data
/// when offline or when explicitly toggled.
class HybridDhatriRepository extends ChangeNotifier implements DhatriRepository {
  final ServerpodClientService clientService;
  final ServerpodDhatriRepository serverpodRepo;
  final MockDhatriRepository mockRepo;

  bool _forceMock = false;
  final StreamController<CareUpdate> _unifiedStreamController =
      StreamController<CareUpdate>.broadcast();
  StreamSubscription<CareUpdate>? _serverSubscription;
  StreamSubscription<CareUpdate>? _mockSubscription;

  HybridDhatriRepository({
    required this.clientService,
    required this.serverpodRepo,
    required this.mockRepo,
  }) {
    clientService.addListener(_handleConnectionChange);
    _setupStreamListeners();
  }

  bool get forceMock => _forceMock;

  @override
  bool get isLiveBackend => clientService.isOnline && !_forceMock;

  void toggleForceMock(bool force) {
    _forceMock = force;
    notifyListeners();
  }

  void _handleConnectionChange() {
    notifyListeners();
  }

  void _setupStreamListeners() {
    _mockSubscription = mockRepo.watchPatient(1).listen((update) {
      if (!isLiveBackend) {
        _unifiedStreamController.add(update);
      }
    });

    try {
      _serverSubscription = serverpodRepo.watchPatient(1).listen((update) {
        if (isLiveBackend) {
          _unifiedStreamController.add(update);
        }
      });
    } catch (_) {}
  }

  @override
  Future<Profile> getCurrentProfile() async {
    if (isLiveBackend) {
      try {
        return await serverpodRepo.getCurrentProfile();
      } catch (_) {}
    }
    return mockRepo.getCurrentProfile();
  }

  @override
  Future<List<PatientStatus>> getOverview() async {
    if (isLiveBackend) {
      try {
        final res = await serverpodRepo.getOverview();
        if (res.isNotEmpty) return res;
      } catch (_) {}
    }
    return mockRepo.getOverview();
  }

  @override
  Future<Profile?> getCaregiverContact(int patientId) async {
    if (isLiveBackend) {
      try {
        return await serverpodRepo.getCaregiverContact(patientId);
      } catch (_) {}
    }
    return mockRepo.getCaregiverContact(patientId);
  }

  @override
  Future<List<DoseEvent>> getTodayDoses(int patientId) async {
    if (isLiveBackend) {
      try {
        final res = await serverpodRepo.getTodayDoses(patientId);
        if (res.isNotEmpty) return res;
      } catch (_) {}
    }
    return mockRepo.getTodayDoses(patientId);
  }

  @override
  Future<void> markTaken(int doseEventId) async {
    if (isLiveBackend) {
      try {
        await serverpodRepo.markTaken(doseEventId);
      } catch (_) {}
    }
    // Also update mock state in case of instant toggle
    await mockRepo.markTaken(doseEventId);
  }

  @override
  Future<List<TimelineItem>> getTimeline(int patientId) async {
    if (isLiveBackend) {
      try {
        final res = await serverpodRepo.getTimeline(patientId);
        if (res.isNotEmpty) return res;
      } catch (_) {}
    }
    return mockRepo.getTimeline(patientId);
  }

  @override
  Future<PatientInsight> getWeeklyInsight(int patientId) async {
    if (isLiveBackend) {
      try {
        return await serverpodRepo.getWeeklyInsight(patientId);
      } catch (_) {}
    }
    return mockRepo.getWeeklyInsight(patientId);
  }

  @override
  Future<List<Alert>> getOpenAlerts() async {
    if (isLiveBackend) {
      try {
        final res = await serverpodRepo.getOpenAlerts();
        if (res.isNotEmpty) return res;
      } catch (_) {}
    }
    return mockRepo.getOpenAlerts();
  }

  @override
  Future<void> acknowledgeAlert(int alertId) async {
    if (isLiveBackend) {
      try {
        await serverpodRepo.acknowledgeAlert(alertId);
      } catch (_) {}
    }
    await mockRepo.acknowledgeAlert(alertId);
  }

  @override
  Future<void> triggerEmergencyHelp(int patientId) async {
    if (isLiveBackend) {
      try {
        await serverpodRepo.triggerEmergencyHelp(patientId);
      } catch (_) {}
    }
    await mockRepo.triggerEmergencyHelp(patientId);
  }

  @override
  Future<List<MedicationDraft>> extractDraftsFromPrescription(String path) async {
    if (isLiveBackend) {
      try {
        final res = await serverpodRepo.extractDraftsFromPrescription(path);
        if (res.isNotEmpty) return res;
      } catch (_) {}
    }
    return mockRepo.extractDraftsFromPrescription(path);
  }

  @override
  Future<void> confirmPrescription(List<MedicationDraft> drafts) async {
    if (isLiveBackend) {
      try {
        await serverpodRepo.confirmPrescription(drafts);
      } catch (_) {}
    }
    await mockRepo.confirmPrescription(drafts);
  }

  @override
  Stream<CareUpdate> watchPatient(int patientId) =>
      _unifiedStreamController.stream;

  @override
  void dispose() {
    clientService.removeListener(_handleConnectionChange);
    _serverSubscription?.cancel();
    _mockSubscription?.cancel();
    _unifiedStreamController.close();
    super.dispose();
  }
}

