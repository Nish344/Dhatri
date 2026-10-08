import 'package:flutter/foundation.dart';
import 'package:dhatri_client/dhatri_client.dart' as protocol;
import '../models/models.dart';
import '../services/serverpod_client_service.dart';

/// Manages active authentication & profile sessions for Patient, Caregiver, and Doctor.
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

  // Pre-configured demo accounts matching docs/DEMO.md
  static const Map<Role, (String email, String password)> demoCredentials = {
    Role.patient: ('ramesh.demo@dhatri.local', 'Demo@2026!'),
    Role.caregiver: ('ananya.demo@dhatri.local', 'Demo@2026!'),
    Role.doctor: ('priya.demo@dhatri.local', 'Demo@2026!'),
  };

  bool _isSignedIn = false;
  bool _needsOnboarding = false;
  Role _activeRole = Role.patient;
  Profile _currentProfile = defaultPatient;
  String? _authError;

  AuthState({this.clientService}) {
    _setLocalDefaultProfile(_activeRole);
  }

  bool get isSignedIn => _isSignedIn;
  bool get needsOnboarding => _needsOnboarding;
  Role get activeRole => _activeRole;
  Profile get currentProfile => _currentProfile;
  String? get authError => _authError;

  bool get isPatient => _activeRole == Role.patient;
  bool get isCaregiver => _activeRole == Role.caregiver;
  bool get isDoctor => _activeRole == Role.doctor;

  void _setLocalDefaultProfile(Role role) {
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
  }

  /// One-tap role switch or demo sign-in
  Future<void> signInWithRole(Role role) async {
    _isSignedIn = true;
    _needsOnboarding = false;
    _activeRole = role;
    _authError = null;
    _setLocalDefaultProfile(role);
    notifyListeners();

    final creds = demoCredentials[role];
    if (creds != null && clientService != null && clientService!.isOnline) {
      try {
        final ok = await clientService!.signIn(creds.$1, creds.$2);
        if (ok) {
          await loadCurrentProfile();
        } else {
          // If demo user is not yet created in Serverpod auth DB,
          // ensure auth key is cleared so invalid headers aren't sent.
          clientService!.setAuthKey(null);
        }
      } catch (_) {
        clientService!.setAuthKey(null);
      }
    } else if (clientService != null) {
      clientService!.setAuthKey(null);
    }
  }

  /// Sign in with registered Serverpod Email IDP
  Future<bool> signInWithEmail(String email, String password, Role role) async {
    _authError = null;
    _activeRole = role;
    _setLocalDefaultProfile(role);

    if (clientService != null) {
      final success = await clientService!.signIn(email, password);
      if (success) {
        _isSignedIn = true;
        notifyListeners();
        await loadCurrentProfile();
        return true;
      } else {
        _authError = clientService!.lastError ?? 'Login failed';
        notifyListeners();
        return false;
      }
    }

    _isSignedIn = true;
    notifyListeners();
    return true;
  }

  /// Registers user profile in Serverpod database if not yet created
  Future<bool> registerProfile({
    required String name,
    required Role role,
    int? age,
    String? phone,
  }) async {
    if (clientService == null || !clientService!.isOnline) return false;
    try {
      final protoRole = protocol.Role.values.byName(role.name);
      final p = await clientService!.client.profile.register(name, protoRole, age, phone);
      _currentProfile = Profile.fromProtocol(p);
      _activeRole = role;
      _needsOnboarding = false;
      notifyListeners();
      return true;
    } catch (e) {
      _authError = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Loads current authenticated profile from Serverpod backend
  Future<void> loadCurrentProfile() async {
    if (clientService != null && clientService!.isOnline) {
      try {
        final p = await clientService!.client.profile.me();
        if (p != null) {
          _currentProfile = Profile.fromProtocol(p);
          _activeRole = _currentProfile.role;
          _needsOnboarding = false;
          notifyListeners();
        } else {
          _needsOnboarding = true;
          notifyListeners();
        }
      } catch (_) {}
    }
  }

  /// Skip onboarding and fall back to local default profile for instant testing
  void skipOnboardingWithDefault() {
    _needsOnboarding = false;
    notifyListeners();
  }

  /// Switch active portal role for simulation
  Future<void> switchToRole(Role role) async {
    await signInWithRole(role);
  }

  /// Sign out and clear active session
  void signOut() {
    _isSignedIn = false;
    _needsOnboarding = false;
    _authError = null;
    if (clientService != null) {
      clientService!.signOut();
    }
    notifyListeners();
  }
}
