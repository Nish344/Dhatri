import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/serverpod_client_service.dart';

/// Manages active authentication & profile sessions.
class AuthState extends ChangeNotifier {
  final ServerpodClientService? clientService;

  static const defaultPatient = Profile(
    id: 1,
    name: 'Ramesh Kumar',
    role: Role.patient,
    age: 72,
    phone: '+91 98765 43210',
    caregiverId: 2,
    doctorId: 3,
    linkCode: '482910',
  );

  static const defaultCaregiver = Profile(
    id: 2,
    name: 'Ananya Kumar',
    role: Role.caregiver,
    phone: '+91 98111 22233',
  );

  static const defaultDoctor = Profile(
    id: 3,
    name: 'Dr. Priya Sharma',
    role: Role.doctor,
    phone: '+91 99999 88888',
  );

  bool _isSignedIn = false;
  Role _activeRole = Role.patient;
  Profile _currentProfile = defaultPatient;

  AuthState({this.clientService}) {
    _syncAuthWithRole(_activeRole);
  }

  bool get isSignedIn => _isSignedIn;
  Role get activeRole => _activeRole;
  Profile get currentProfile => _currentProfile;

  bool get isPatient => _activeRole == Role.patient;
  bool get isCaregiver => _activeRole == Role.caregiver;
  bool get isDoctor => _activeRole == Role.doctor;

  Future<void> signInWithRole(Role role) async {
    _isSignedIn = true;
    await switchToRole(role);
  }

  void signOut() {
    _isSignedIn = false;
    if (clientService != null) {
      clientService!.setAuthKey(null);
    }
    notifyListeners();
  }

  Future<bool> signInWithEmail(String email, String password, Role role) async {
    // Attempt Serverpod IDP login or set auth session token
    _isSignedIn = true;
    _activeRole = role;
    switch (role) {
      case Role.patient:
        _currentProfile = defaultPatient;
        break;
      case Role.caregiver:
        _currentProfile = defaultCaregiver;
        break;
      case Role.doctor:
        _currentProfile = defaultDoctor;
        break;
    }
    _syncAuthWithRole(role);
    notifyListeners();
    await loadCurrentProfile();
    return true;
  }

  Future<void> loadCurrentProfile() async {
    if (clientService != null && clientService!.isOnline && _isSignedIn) {
      try {
        final p = await clientService!.client.profile.me();
        if (p != null) {
          _currentProfile = Profile.fromProtocol(p);
          _activeRole = _currentProfile.role;
          notifyListeners();
        }
      } catch (_) {}
    }
  }

  Future<void> switchToRole(Role role) async {
    _activeRole = role;
    switch (role) {
      case Role.patient:
        _currentProfile = defaultPatient;
        break;
      case Role.caregiver:
        _currentProfile = defaultCaregiver;
        break;
      case Role.doctor:
        _currentProfile = defaultDoctor;
        break;
    }
    _syncAuthWithRole(role);
    notifyListeners();
    await loadCurrentProfile();
  }

  void _syncAuthWithRole(Role role) {
    if (clientService == null) return;
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
