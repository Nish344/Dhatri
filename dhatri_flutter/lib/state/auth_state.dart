import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../mock_engine/mock_database.dart';
import '../services/serverpod_client_service.dart';

/// Manages active authentication & demo role switcher.
class AuthState extends ChangeNotifier {
  final ServerpodClientService? clientService;

  Role _activeRole = Role.patient;
  Profile _currentProfile = MockDatabase.ramesh;

  AuthState({this.clientService}) {
    _syncAuthWithRole(_activeRole);
  }

  Role get activeRole => _activeRole;
  Profile get currentProfile => _currentProfile;

  bool get isPatient => _activeRole == Role.patient;
  bool get isCaregiver => _activeRole == Role.caregiver;
  bool get isDoctor => _activeRole == Role.doctor;

  void switchToRole(Role role) {
    _activeRole = role;
    switch (role) {
      case Role.patient:
        _currentProfile = MockDatabase.ramesh;
        break;
      case Role.caregiver:
        _currentProfile = MockDatabase.ananya;
        break;
      case Role.doctor:
        _currentProfile = MockDatabase.drPriya;
        break;
    }
    _syncAuthWithRole(role);
    notifyListeners();
  }

  void _syncAuthWithRole(Role role) {
    if (clientService == null) return;
    // Set role simulated session key
    switch (role) {
      case Role.patient:
        clientService!.setAuthKey('demo-patient-ramesh');
        break;
      case Role.caregiver:
        clientService!.setAuthKey('demo-caregiver-ananya');
        break;
      case Role.doctor:
        clientService!.setAuthKey('demo-doctor-priya');
        break;
    }
  }
}
