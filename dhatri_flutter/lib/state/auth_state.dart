import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../mock_engine/mock_database.dart';

/// Manages active authentication & demo role switcher.
class AuthState extends ChangeNotifier {
  Role _activeRole = Role.patient;
  Profile _currentProfile = MockDatabase.ramesh;

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
    notifyListeners();
  }
}

