import 'package:flutter/foundation.dart';
import 'package:dhatri_client/dhatri_client.dart' as protocol;
import '../models/models.dart';
import '../services/serverpod_client_service.dart';

/// Manages active authentication & profile sessions for Patient, Caregiver, and Doctor.
/// Driven 100% by live Serverpod database records.
class AuthState extends ChangeNotifier {
  final ServerpodClientService? clientService;

  bool _isSignedIn = false;
  bool _needsOnboarding = false;
  Role _activeRole = Role.patient;
  Profile? _currentProfile;
  String? _authError;

  AuthState({this.clientService}) {
    _checkExistingSession();
  }

  bool get isSignedIn => _isSignedIn;
  bool get needsOnboarding => _needsOnboarding;
  Role get activeRole => _currentProfile?.role ?? _activeRole;
  Profile get currentProfile =>
      _currentProfile ??
      const Profile(
        id: 0,
        name: 'User',
        role: Role.patient,
      );
  String? get authError => _authError;

  bool get isPatient => activeRole == Role.patient;
  bool get isCaregiver => activeRole == Role.caregiver;
  bool get isDoctor => activeRole == Role.doctor;

  Future<void> _checkExistingSession() async {
    if (clientService != null && await clientService!.isAuthenticated) {
      await loadCurrentProfile();
    }
  }

  /// Sign in with registered Serverpod Email IDP
  Future<bool> signInWithEmail(String email, String password) async {
    _authError = null;

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

    _authError = 'Server client unavailable';
    notifyListeners();
    return false;
  }

  /// Registers user profile in Serverpod database for the authenticated account
  Future<bool> registerProfile({
    required String name,
    required Role role,
    int? age,
    String? phone,
  }) async {
    if (clientService == null || !clientService!.isOnline) {
      _authError = 'Backend is offline';
      notifyListeners();
      return false;
    }
    try {
      final protoRole = protocol.Role.values.byName(role.name);
      final p = await clientService!.client.profile.register(name, protoRole, age, phone);
      _currentProfile = Profile.fromProtocol(p);
      _activeRole = role;
      _isSignedIn = true;
      _needsOnboarding = false;
      _authError = null;
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
          _activeRole = _currentProfile!.role;
          _isSignedIn = true;
          _needsOnboarding = false;
        } else {
          // User is authenticated but hasn't created a Profile yet
          _isSignedIn = true;
          _needsOnboarding = true;
        }
        notifyListeners();
      } catch (e) {
        _authError = e.toString();
        notifyListeners();
      }
    }
  }

  /// Switch active portal role (for multi-role views if applicable)
  void setActiveRole(Role role) {
    _activeRole = role;
    notifyListeners();
  }

  /// Sign out and clear active session
  void signOut() {
    _isSignedIn = false;
    _needsOnboarding = false;
    _currentProfile = null;
    _authError = null;
    if (clientService != null) {
      clientService!.signOut();
    }
    notifyListeners();
  }
}
