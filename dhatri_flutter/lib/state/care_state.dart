import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../repositories/dhatri_repository.dart';
import 'auth_state.dart';

enum CareStreamStatus { live, reconnecting, offline }

class CareState extends ChangeNotifier {
  final DhatriRepository repository;
  StreamSubscription<CareUpdate>? _streamSubscription;
  Timer? _reconnectTimer;
  Timer? _retryTimer;

  int? _activePatientId;
  CareStreamStatus _streamStatus = CareStreamStatus.offline;
  bool _isPatient = false;
  int _pendingAuthFailures = 0;

  List<DoseEvent> _todayDoses = [];
  List<Alert> _openAlerts = [];
  List<TimelineItem> _timeline = [];
  PatientInsight? _patientInsight;
  List<PatientStatus> _overview = [];
  Profile? _caregiverContact;

  /// Latest pending/snoozed check pushed over the care stream (patient ringtone).
  WellnessCheck? _incomingCheck;
  Timer? _pendingPollTimer;

  // Local optimistic states: doseId -> 'saving' | 'saved' | 'retry'
  final Map<int, String> _optimisticDoseStatus = {};
  final Set<int> _pendingSyncDoseIds = {};

  CareState({required this.repository});

  int? get activePatientId => _activePatientId;
  CareStreamStatus get streamStatus => _streamStatus;
  List<DoseEvent> get todayDoses => _todayDoses;
  List<Alert> get openAlerts => _openAlerts;
  List<TimelineItem> get timeline => _timeline;
  PatientInsight? get patientInsight => _patientInsight;
  List<PatientStatus> get overview => _overview;
  Profile? get caregiverContact => _caregiverContact;
  WellnessCheck? get incomingCheck => _incomingCheck;

  void clearIncomingCheck() {
    if (_incomingCheck == null) return;
    _incomingCheck = null;
    notifyListeners();
  }

  void _offerIncomingCheck(WellnessCheck check) {
    if (check.status != CheckStatus.pending &&
        check.status != CheckStatus.snoozed) {
      if (_incomingCheck?.id == check.id) {
        _incomingCheck = null;
        notifyListeners();
      }
      return;
    }
    _incomingCheck = check;
    debugPrint(
      'CareState: incoming check id=${check.id} status=${check.status.name}',
    );
    notifyListeners();
  }

  /// Synchronize active patient context with authenticated user session
  void syncWithAuth(AuthState auth) {
    if (!auth.isSignedIn || auth.needsOnboarding) {
      if (_activePatientId != null ||
          _todayDoses.isNotEmpty ||
          _streamSubscription != null) {
        _streamSubscription?.cancel();
        _streamSubscription = null;
        _reconnectTimer?.cancel();
        _reconnectTimer = null;
        _activePatientId = null;
        _todayDoses = [];
        _openAlerts = [];
        _timeline = [];
        _patientInsight = null;
        _overview = [];
        _caregiverContact = null;
        _incomingCheck = null;
        _pendingPollTimer?.cancel();
        _pendingPollTimer = null;
        _streamStatus = CareStreamStatus.offline;
        notifyListeners();
      }
      return;
    }

    final profile = auth.currentProfile;
    _isPatient = auth.isPatient;
    if (auth.isPatient) {
      if (profile.id > 0 && _activePatientId != profile.id) {
        _activePatientId = profile.id;
        loadAll();
        _subscribeToStream();
      }
    } else {
      _pendingPollTimer?.cancel();
      _pendingPollTimer = null;
      // Caregiver or Doctor:
      if (_overview.isEmpty && _activePatientId == null) {
        loadAll();
      }
    }
  }

  DoseEvent? get nextDose {
    final pending = _todayDoses.where(
      (d) =>
          d.status == DoseStatus.scheduled || d.status == DoseStatus.reminded,
    );
    if (pending.isNotEmpty) return pending.first;
    return null;
  }

  String? getOptimisticStatus(int doseId) => _optimisticDoseStatus[doseId];

  void setActivePatientId(int patientId) {
    if (_activePatientId == patientId) return;
    _activePatientId = patientId;
    notifyListeners();
    loadAll();
    _subscribeToStream();
  }

  Future<void> loadAll() async {
    // Patients must not call patients.overview (server returns 500 for Role.patient).
    if (!_isPatient) {
      try {
        _overview = await repository.getOverview();
        if (_overview.isNotEmpty &&
            (_activePatientId == null ||
                !_overview.any((p) => p.patient.id == _activePatientId))) {
          _activePatientId = _overview.first.patient.id;
          _subscribeToStream();
        }
      } catch (e) {
        debugPrint('CareState: overview failed: $e');
      }
    }

    final patientId = _activePatientId;
    if (patientId == null || patientId <= 0) {
      notifyListeners();
      return;
    }

    try {
      _todayDoses = await repository.getTodayDoses(patientId);
    } catch (_) {}

    try {
      _openAlerts = await repository.getOpenAlerts(patientId);
    } catch (_) {}

    try {
      _timeline = await repository.getTimeline(patientId);
    } catch (_) {}

    try {
      _patientInsight = await repository.getWeeklyInsight(patientId);
    } catch (_) {}

    try {
      _caregiverContact = await repository.getCaregiverContact(patientId);
    } catch (_) {}

    notifyListeners();
  }

  void _subscribeToStream() {
    _streamSubscription?.cancel();
    _reconnectTimer?.cancel();

    final patientId = _activePatientId;
    if (patientId == null || patientId <= 0) {
      _streamStatus = CareStreamStatus.offline;
      return;
    }

    try {
      _streamStatus = CareStreamStatus.live;
      notifyListeners();

      _streamSubscription = repository
          .watchPatient(patientId)
          .listen(
            (update) {
              _streamStatus = CareStreamStatus.live;
              if (update.check != null) {
                _offerIncomingCheck(update.check!);
              }
              loadAll();
            },
            onError: (err) {
              debugPrint('CareState: care stream error: $err');
              _scheduleStreamReconnect();
            },
            onDone: () {
              _scheduleStreamReconnect();
            },
          );
      if (_isPatient) {
        _startPendingPoll();
      }
    } catch (_) {
      _scheduleStreamReconnect();
    }
  }

  /// Backup for multi-tab demos if the websocket update is missed.
  void _startPendingPoll() {
    _pendingPollTimer?.cancel();
    if (!_isPatient) return;
    final patientId = _activePatientId;
    if (patientId == null || patientId <= 0) return;
    _pendingAuthFailures = 0;

    _pendingPollTimer = Timer.periodic(const Duration(seconds: 4), (_) async {
      try {
        final check = await repository.getPendingCheckIn(patientId);
        _pendingAuthFailures = 0;
        if (check != null) {
          _offerIncomingCheck(check);
        }
      } catch (e) {
        final msg = e.toString();
        debugPrint('CareState: pending poll failed: $e');
        if (msg.contains('401') || msg.contains('Unauthorized')) {
          _pendingAuthFailures++;
          // Stop hammering the server once the JWT is dead — user must re-login.
          if (_pendingAuthFailures >= 2) {
            debugPrint(
              'CareState: stopping pending poll after repeated 401s — re-login required',
            );
            _pendingPollTimer?.cancel();
            _pendingPollTimer = null;
          }
        }
      }
    });
  }

  void _scheduleStreamReconnect() {
    _streamStatus = CareStreamStatus.reconnecting;
    notifyListeners();

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 10), () {
      _subscribeToStream();
    });
  }

  /// Patient action: Optimistic Taken Confirmation (Guide §11, §29)
  Future<void> markTaken(int doseId) async {
    // 1. Immediate local optimistic state: "Saving..."
    _optimisticDoseStatus[doseId] = 'saving';
    notifyListeners();

    try {
      await repository.markTaken(doseId);
      _optimisticDoseStatus[doseId] = 'saved';
      _pendingSyncDoseIds.remove(doseId);
      notifyListeners();

      // Clear local label after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        _optimisticDoseStatus.remove(doseId);
        notifyListeners();
      });
    } catch (e) {
      // Guide §29: "Will sync when connected"
      _optimisticDoseStatus[doseId] = 'retry';
      _pendingSyncDoseIds.add(doseId);
      notifyListeners();
      _scheduleRetryPendingSync();
    }
  }

  void _scheduleRetryPendingSync() {
    if (_retryTimer != null && _retryTimer!.isActive) return;
    _retryTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (_pendingSyncDoseIds.isEmpty) {
        timer.cancel();
        return;
      }
      final ids = List<int>.from(_pendingSyncDoseIds);
      for (final id in ids) {
        try {
          await repository.markTaken(id);
          _pendingSyncDoseIds.remove(id);
          _optimisticDoseStatus[id] = 'saved';
          notifyListeners();
          Future.delayed(const Duration(seconds: 3), () {
            _optimisticDoseStatus.remove(id);
            notifyListeners();
          });
        } catch (_) {}
      }
      if (_pendingSyncDoseIds.isEmpty) {
        timer.cancel();
      }
    });
  }

  Future<void> acknowledgeAlert(int alertId) async {
    await repository.acknowledgeAlert(alertId);
    await loadAll();
  }

  Future<void> triggerEmergencyHelp() async {
    final patientId = _activePatientId;
    if (patientId == null || patientId <= 0) return;
    await repository.triggerEmergencyHelp(patientId);
    await loadAll();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    _reconnectTimer?.cancel();
    _retryTimer?.cancel();
    _pendingPollTimer?.cancel();
    super.dispose();
  }
}
