import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../repositories/dhatri_repository.dart';

enum CareStreamStatus { live, reconnecting, offline }

class CareState extends ChangeNotifier {
  final DhatriRepository repository;
  StreamSubscription<CareUpdate>? _streamSubscription;
  Timer? _reconnectTimer;
  Timer? _retryTimer;

  int _activePatientId = 1;
  CareStreamStatus _streamStatus = CareStreamStatus.offline;

  List<DoseEvent> _todayDoses = [];
  List<Alert> _openAlerts = [];
  List<TimelineItem> _timeline = [];
  PatientInsight? _patientInsight;
  List<PatientStatus> _overview = [];

  // Local optimistic states: doseId -> 'saving' | 'saved' | 'retry'
  final Map<int, String> _optimisticDoseStatus = {};
  final Set<int> _pendingSyncDoseIds = {};

  CareState({required this.repository}) {
    loadAll();
    _subscribeToStream();
  }

  int get activePatientId => _activePatientId;
  CareStreamStatus get streamStatus => _streamStatus;
  List<DoseEvent> get todayDoses => _todayDoses;
  List<Alert> get openAlerts => _openAlerts;
  List<TimelineItem> get timeline => _timeline;
  PatientInsight? get patientInsight => _patientInsight;
  List<PatientStatus> get overview => _overview;

  DoseEvent? get nextDose {
    final pending = _todayDoses.where((d) =>
        d.status == DoseStatus.scheduled || d.status == DoseStatus.reminded);
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
    try {
      _todayDoses = await repository.getTodayDoses(_activePatientId);
    } catch (_) {}

    try {
      _openAlerts = await repository.getOpenAlerts(_activePatientId);
    } catch (_) {}

    try {
      _timeline = await repository.getTimeline(_activePatientId);
    } catch (_) {}

    try {
      _patientInsight = await repository.getWeeklyInsight(_activePatientId);
    } catch (_) {}

    try {
      _overview = await repository.getOverview();
    } catch (_) {}

    notifyListeners();
  }

  void _subscribeToStream() {
    _streamSubscription?.cancel();
    _reconnectTimer?.cancel();

    try {
      _streamStatus = CareStreamStatus.live;
      notifyListeners();

      _streamSubscription = repository.watchPatient(_activePatientId).listen(
        (update) {
          _streamStatus = CareStreamStatus.live;
          loadAll();
        },
        onError: (err) {
          _scheduleStreamReconnect();
        },
        onDone: () {
          _scheduleStreamReconnect();
        },
      );
    } catch (_) {
      _scheduleStreamReconnect();
    }
  }

  void _scheduleStreamReconnect() {
    _streamStatus = CareStreamStatus.reconnecting;
    notifyListeners();

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 2), () {
      _subscribeToStream();
      loadAll();
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
    await repository.triggerEmergencyHelp(_activePatientId);
    await loadAll();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    _reconnectTimer?.cancel();
    _retryTimer?.cancel();
    super.dispose();
  }
}
