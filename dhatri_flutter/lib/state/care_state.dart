import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../repositories/dhatri_repository.dart';

class CareState extends ChangeNotifier {
  final DhatriRepository repository;
  StreamSubscription<CareUpdate>? _streamSubscription;

  List<DoseEvent> _todayDoses = [];
  List<Alert> _openAlerts = [];
  List<TimelineItem> _timeline = [];
  PatientInsight? _patientInsight;
  List<PatientStatus> _overview = [];

  // Local optimistic states: doseId -> 'saving' | 'saved'
  final Map<int, String> _optimisticDoseStatus = {};

  CareState({required this.repository}) {
    if (repository is ChangeNotifier) {
      (repository as ChangeNotifier).addListener(loadAll);
    }
    loadAll();
    _subscribeToStream();
  }

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

  Future<void> loadAll() async {
    try {
      _todayDoses = await repository.getTodayDoses(1);
    } catch (_) {}
    try {
      _openAlerts = await repository.getOpenAlerts();
    } catch (_) {}
    try {
      _timeline = await repository.getTimeline(1);
    } catch (_) {}
    try {
      _patientInsight = await repository.getWeeklyInsight(1);
    } catch (_) {}
    try {
      _overview = await repository.getOverview();
    } catch (_) {}
    notifyListeners();
  }

  void _subscribeToStream() {
    _streamSubscription = repository.watchPatient(1).listen((update) {
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
      notifyListeners();

      // Clear local label after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        _optimisticDoseStatus.remove(doseId);
        notifyListeners();
      });
    } catch (e) {
      _optimisticDoseStatus.remove(doseId);
      notifyListeners();
    }
  }

  Future<void> acknowledgeAlert(int alertId) async {
    await repository.acknowledgeAlert(alertId);
    await loadAll();
  }

  Future<void> triggerEmergencyHelp() async {
    await repository.triggerEmergencyHelp(1);
    await loadAll();
  }

  @override
  void dispose() {
    if (repository is ChangeNotifier) {
      (repository as ChangeNotifier).removeListener(loadAll);
    }
    _streamSubscription?.cancel();
    super.dispose();
  }
}

