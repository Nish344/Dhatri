import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:dhatri_client/dhatri_client.dart';

class DhatriAuthKeyManager extends AuthenticationKeyManager {
  String? _key;

  @override
  Future<String?> get() async => _key;

  @override
  Future<void> put(String key) async {
    _key = key;
  }

  @override
  Future<void> remove() async {
    _key = null;
  }
}

/// Service managing the Serverpod Client, connection status,
/// endpoint routing, and demo database seeding.
class ServerpodClientService extends ChangeNotifier {
  late Client _client;
  final DhatriAuthKeyManager _authManager = DhatriAuthKeyManager();
  String _serverUrl;
  bool _isOnline = false;
  bool _isChecking = false;
  String? _lastError;

  Client get client => _client;
  String get serverUrl => _serverUrl;
  bool get isOnline => _isOnline;
  bool get isChecking => _isChecking;
  String? get lastError => _lastError;

  static String get defaultServerUrl {
    const fromEnv = String.fromEnvironment('SERVER_URL');
    if (fromEnv.isNotEmpty) return fromEnv;

    if (kIsWeb) return 'http://localhost:8080/';

    try {
      if (Platform.isAndroid) {
        // In Android emulator 10.0.2.2 points to host machine.
        // For physical device, localhost works if adb reverse tcp:8080 tcp:8080 is run.
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
    _client = Client(
      _serverUrl.endsWith('/') ? _serverUrl : '$_serverUrl/',
      connectionTimeout: const Duration(seconds: 5),
    )..authenticationKeyManager = _authManager;
  }

  Future<void> updateServerUrl(String newUrl) async {
    if (_serverUrl == newUrl) return;
    _serverUrl = newUrl;
    _initClient();
    notifyListeners();
    await checkConnection();
  }

  /// Checks if the Serverpod backend is reachable.
  Future<bool> checkConnection() async {
    if (_isChecking) return _isOnline;
    _isChecking = true;
    notifyListeners();

    try {
      final baseUri = Uri.parse(_serverUrl);
      final checkUri = Uri(
        scheme: baseUri.scheme,
        host: baseUri.host,
        port: baseUri.port,
        path: '/assets/assets/config.json',
      );

      final response = await http
          .get(checkUri)
          .timeout(const Duration(milliseconds: 2500));

      if (response.statusCode == 200 || response.statusCode == 404) {
        _isOnline = true;
        _lastError = null;
      } else {
        _isOnline = false;
        _lastError = 'HTTP ${response.statusCode}';
      }
    } catch (e) {
      // Also try fallback ping directly to root /
      try {
        final rootUri = Uri.parse(_serverUrl);
        final response = await http
            .get(rootUri)
            .timeout(const Duration(milliseconds: 1500));
        _isOnline = response.statusCode == 200 || response.statusCode == 404;
        _lastError = null;
      } catch (err) {
        _isOnline = false;
        _lastError = err.toString();
      }
    } finally {
      _isChecking = false;
      notifyListeners();
    }

    return _isOnline;
  }

  /// Seeds the 7-day Ramesh Kumar demonstration dataset on Serverpod.
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

  /// Resets the demo dataset on Serverpod.
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

  /// Sets auth key for session simulation.
  void setAuthKey(String? key) {
    if (key == null) {
      _authManager.remove();
    } else {
      _authManager.put(key);
    }
  }
}

