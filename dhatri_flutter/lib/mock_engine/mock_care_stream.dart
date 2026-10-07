import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/models.dart';
import 'mock_database.dart';

enum CareConnectionState { live, reconnecting, offline }

/// Simulates Serverpod's care_bus WebSocket channel ('patient_{id}')
/// and CareStreamEndpoint.watch()
class MockCareStream {
  final MockDatabase db;
  final StreamController<CareUpdate> _controller = StreamController<CareUpdate>.broadcast();
  final ValueNotifier<CareConnectionState> connectionState =
      ValueNotifier<CareConnectionState>(CareConnectionState.live);

  MockCareStream(this.db);

  Stream<CareUpdate> watch(int patientId) {
    return _controller.stream.where((update) => update.patientId == patientId);
  }

  void postUpdate(CareUpdate update) {
    _controller.add(update);
  }

  /// Interactive Simulation: Takes the 8:00 PM Metformin dose (optimistic transition)
  Future<void> takeDose(int doseEventId) async {
    final index = db.doseEvents.indexWhere((d) => d.id == doseEventId);
    if (index != -1) {
      final updated = db.doseEvents[index].copyWith(
        status: DoseStatus.taken,
        takenAt: DateTime.now(),
      );
      db.doseEvents[index] = updated;

      postUpdate(CareUpdate(
        patientId: updated.patientId,
        doseEvent: updated,
      ));
    }
  }

  /// Interactive Simulation: Simulates the 20-minute grace period elapsing without confirmation
  /// Shifting 8:00 PM dose from Reminded -> Missed, and pushing a live Alert to Caregiver.
  void triggerMissedDoseEscalation() {
    final index = db.doseEvents.indexWhere((d) => d.id == 3);
    if (index != -1) {
      final missedDose = db.doseEvents[index].copyWith(
        status: DoseStatus.missed,
      );
      db.doseEvents[index] = missedDose;

      // Create new live Alert for caregiver
      final newAlert = Alert(
        id: DateTime.now().millisecondsSinceEpoch,
        patientId: 1,
        patientName: 'Ramesh Kumar',
        kind: AlertKind.missedDose,
        priority: AlertPriority.attention,
        doseEventId: 3,
        message: '🚨 Ramesh has not confirmed his 8:00 PM Metformin medication (Grace period elapsed).',
        createdAt: DateTime.now(),
      );
      db.alerts.insert(0, newAlert);

      // Broadcast both updates
      postUpdate(CareUpdate(
        patientId: 1,
        doseEvent: missedDose,
      ));
      postUpdate(CareUpdate(
        patientId: 1,
        alert: newAlert,
      ));
    }
  }

  /// Interactive Simulation: Remotely triggers an incoming Dhatri Care Call on the patient's phone
  void triggerIncomingCall({CheckTrigger trigger = CheckTrigger.caregiver}) {
    final newCheck = WellnessCheck(
      id: DateTime.now().millisecondsSinceEpoch,
      patientId: 1,
      status: CheckStatus.pending,
      trigger: trigger,
      turnCount: 0,
      createdAt: DateTime.now(),
    );
    db.wellnessChecks.insert(0, newCheck);

    postUpdate(CareUpdate(
      patientId: 1,
      check: newCheck,
    ));
  }

  /// Caregiver acknowledges alert
  void acknowledgeAlert(int alertId) {
    final index = db.alerts.indexWhere((a) => a.id == alertId);
    if (index != -1) {
      final updated = db.alerts[index].copyWith(
        acknowledgedAt: DateTime.now(),
      );
      db.alerts[index] = updated;

      postUpdate(CareUpdate(
        patientId: updated.patientId,
        alert: updated,
      ));
    }
  }

  void dispose() {
    _controller.close();
  }
}

