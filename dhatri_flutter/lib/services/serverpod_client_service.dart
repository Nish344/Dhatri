import 'dart:async';
import 'dart:io' show Platform;

import 'package:dhatri_client/dhatri_client.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart';

/// In-memory key/value store for JWT [AuthSuccess] (survives within the tab).
class _MemoryKeyValueStorage implements KeyValueStorage {
  final Map<String, String> _data = {};

  @override
  Future<String?> get(String key) async => _data[key];

  @override
  Future<void> set(String key, String? value) async {
    if (value == null) {
      _data.remove(key);
    } else {
      _data[key] = value;
    }
  }
}

/// Service managing the Serverpod Client, connection status,
/// endpoint routing, and demo database seeding.
class ServerpodClientService extends ChangeNotifier {
  late Client _client;
  late ClientAuthSessionManager _sessionManager;
  String _serverUrl;
  bool _isOnline = false;
  bool _isChecking = false;
  String? _lastError;

  Client get client => _client;
  String get serverUrl => _serverUrl;
  bool get isOnline => _isOnline;
  bool get isChecking => _isChecking;
  String? get lastError => _lastError;
  AuthSuccess? get authInfo => _sessionManager.authInfo;

  /// AI check-in (Gemini + Sarvam) regularly exceeds 5s — keep this high.
  static const connectionTimeout = Duration(seconds: 60);

  static String get defaultServerUrl {
    const fromEnv = String.fromEnvironment('SERVER_URL');
    if (fromEnv.isNotEmpty) return fromEnv;

    if (kIsWeb) return 'http://localhost:8080/';

    try {
      if (Platform.isAndroid) {
        return 'http://10.0.2.2:8080/';
      }
    } catch (_) {}

    return 'http://localhost:8080/';
  }

  ServerpodClientService({String? initialUrl})
    : _serverUrl = initialUrl ?? defaultServerUrl {
    _initClient();
    checkConnection();
  }

  void _initClient() {
    _sessionManager = ClientAuthSessionManager(
      storage: KeyValueClientAuthSuccessStorage(
        keyValueStorage: _MemoryKeyValueStorage(),
      ),
      onAuthInfoChanged: (_) => notifyListeners(),
    );

    _client = Client(
      _serverUrl.endsWith('/') ? _serverUrl : '$_serverUrl/',
      connectionTimeout: connectionTimeout,
    )..authKeyProvider = _sessionManager;

    // Session manager needs the auth-core caller (status + JWT refresh wiring).
    _sessionManager.setCaller(_client.modules.serverpod_auth_core);
  }

  Future<void> updateServerUrl(String newUrl) async {
    if (_serverUrl == newUrl) return;
    _serverUrl = newUrl;
    _initClient();
    notifyListeners();
    await checkConnection();
  }

  Future<bool> checkConnection() async {
    if (_isChecking) return _isOnline;
    _isChecking = true;
    notifyListeners();

    try {
      await _client.emailIdp.hasAccount().timeout(const Duration(seconds: 3));
      _isOnline = true;
      _lastError = null;
    } catch (e) {
      if (e is ServerpodClientException) {
        _isOnline = true;
        _lastError = null;
      } else {
        try {
          final rootUri = Uri.parse(_serverUrl);
          final res = await http
              .get(rootUri)
              .timeout(const Duration(milliseconds: 1500));
          _isOnline = res.statusCode >= 200 && res.statusCode < 500;
          _lastError = _isOnline ? null : 'HTTP ${res.statusCode}';
        } catch (err) {
          _isOnline = false;
          _lastError = err.toString();
        }
      }
    } finally {
      _isChecking = false;
      notifyListeners();
    }

    return _isOnline;
  }

  Future<bool> seedDemoData({String token = 'dhatri-demo-secret-2026'}) async {
    try {
      await _client.demo.seed(token);
      return true;
    } catch (e) {
      _lastError = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> resetDemoData({String token = 'dhatri-demo-secret-2026'}) async {
    try {
      await _client.demo.reset(token);
      return true;
    } catch (e) {
      _lastError = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      final res = await _client.emailIdp.login(
        email: email.trim(),
        password: password,
      );
      await _sessionManager.updateSignedInUser(res);
      _lastError = null;
      notifyListeners();
      return true;
    } catch (e) {
      _lastError = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<UuidValue?> startRegistration(String email) async {
    try {
      final reqId = await _client.emailIdp.startRegistration(
        email: email.trim(),
      );
      _lastError = null;
      return reqId;
    } catch (e) {
      _lastError = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<String?> verifyRegistrationCode(
    UuidValue accountRequestId,
    String code,
  ) async {
    try {
      final token = await _client.emailIdp.verifyRegistrationCode(
        accountRequestId: accountRequestId,
        verificationCode: code.trim(),
      );
      _lastError = null;
      return token;
    } catch (e) {
      _lastError = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<bool> finishRegistration(
    String registrationToken,
    String password,
  ) async {
    try {
      final res = await _client.emailIdp.finishRegistration(
        registrationToken: registrationToken,
        password: password,
      );
      await _sessionManager.updateSignedInUser(res);
      _lastError = null;
      notifyListeners();
      return true;
    } catch (e) {
      _lastError = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await _sessionManager.updateSignedInUser(null);
    _lastError = null;
    notifyListeners();
  }

  Future<bool> get isAuthenticated async => _sessionManager.isAuthenticated;

  /// Force a JWT refresh (e.g. after a 401). Returns false if refresh failed.
  Future<bool> refreshAuth() async {
    final result = await _sessionManager.refreshAuthKey(force: true);
    notifyListeners();
    return result == RefreshAuthKeyResult.success;
  }
}
