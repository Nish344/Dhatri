import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

/// Plays Sarvam WAV from the server when available; falls back to on-device
/// [FlutterTts] only if audio bytes are empty (TTS outage on the server).
/// Patient mic input uses the browser/device STT (`speech_to_text`).
class VoiceAudioService {
  static final VoiceAudioService _instance = VoiceAudioService._internal();
  factory VoiceAudioService() => _instance;
  VoiceAudioService._internal();

  final FlutterTts _tts = FlutterTts();
  final AudioPlayer _player = AudioPlayer();
  final stt.SpeechToText _speech = stt.SpeechToText();

  bool _isTtsInitialized = false;
  bool _isSpeechInitialized = false;
  bool _isSpeaking = false;
  bool _isListening = false;

  String? _hindiLocaleId;
  Timer? _speechTimeoutTimer;
  StreamSubscription<void>? _playerCompleteSub;

  /// `sarvam` when server WAV played, `device_tts` for FlutterTts fallback.
  String lastVoiceSource = 'none';

  final ValueNotifier<double> soundLevel = ValueNotifier<double>(0.0);

  bool get isSpeaking => _isSpeaking;
  bool get isListening => _isListening;
  bool get isSpeechAvailable => _isSpeechInitialized;

  Future<void> initTts() async {
    if (_isTtsInitialized) return;
    try {
      await _tts.setLanguage('hi-IN');
      await _tts.setSpeechRate(0.42);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);

      if (!kIsWeb) {
        try {
          await _tts.awaitSpeakCompletion(true);
        } catch (_) {}
      }

      _tts.setStartHandler(() => _isSpeaking = true);
      _tts.setCompletionHandler(() {
        _isSpeaking = false;
        _speechTimeoutTimer?.cancel();
      });
      _tts.setCancelHandler(() {
        _isSpeaking = false;
        _speechTimeoutTimer?.cancel();
      });
      _tts.setErrorHandler((dynamic msg) {
        _isSpeaking = false;
        _speechTimeoutTimer?.cancel();
      });

      _isTtsInitialized = true;
    } catch (e) {
      debugPrint('VoiceAudioService: TTS init failed: $e');
    }
  }

  /// Prefer Sarvam [audio] WAV from Serverpod; else speak [text] via device TTS.
  Future<void> speakTurn({
    required String text,
    ByteData? audio,
    VoidCallback? onComplete,
  }) async {
    final bytes = audio == null || audio.lengthInBytes == 0
        ? null
        : audio.buffer.asUint8List(audio.offsetInBytes, audio.lengthInBytes);

    if (bytes != null && bytes.length > 44) {
      lastVoiceSource = 'sarvam';
      debugPrint(
        'VoiceAudioService: playing Sarvam WAV (${bytes.length} bytes)',
      );
      await _playWavBytes(bytes, onComplete: onComplete);
      return;
    }

    lastVoiceSource = 'device_tts';
    debugPrint(
      'VoiceAudioService: no Sarvam audio — falling back to device TTS '
      '(browser/OS voice, not Sarvam)',
    );
    await speak(text, onComplete: onComplete);
  }

  Future<void> _playWavBytes(
    Uint8List bytes, {
    VoidCallback? onComplete,
  }) async {
    await stopSpeaking();

    bool hasCompleted = false;
    void finish() {
      if (hasCompleted) return;
      hasCompleted = true;
      _isSpeaking = false;
      _speechTimeoutTimer?.cancel();
      onComplete?.call();
    }

    try {
      _isSpeaking = true;
      await _playerCompleteSub?.cancel();
      _playerCompleteSub = _player.onPlayerComplete.listen((_) => finish());

      // Duration safety net (~ wave data size at 22kHz mono 16-bit ≈ 44KB/s)
      final timeoutSecs = (bytes.length / 20000).clamp(3.0, 45.0).ceil();
      _speechTimeoutTimer = Timer(Duration(seconds: timeoutSecs), finish);

      await _player.play(BytesSource(bytes, mimeType: 'audio/wav'));
    } catch (e) {
      debugPrint('VoiceAudioService: Sarvam WAV play failed: $e');
      finish();
    }
  }

  /// Device/browser Hindi TTS fallback only.
  Future<void> speak(String text, {VoidCallback? onComplete}) async {
    final cleanText = text.trim();
    if (cleanText.isEmpty) {
      onComplete?.call();
      return;
    }

    await initTts();
    await stopSpeaking();

    bool hasCompleted = false;
    void finish() {
      if (hasCompleted) return;
      hasCompleted = true;
      _isSpeaking = false;
      _speechTimeoutTimer?.cancel();
      onComplete?.call();
    }

    _tts.setCompletionHandler(() => finish());

    final timeoutSecs =
        ((cleanText.length * 0.08) + 2.0).clamp(3.0, 14.0).toInt();
    _speechTimeoutTimer = Timer(Duration(seconds: timeoutSecs), finish);

    try {
      _isSpeaking = true;
      final res = await _tts.speak(cleanText);
      if (res != 1 && res != true) {
        finish();
      }
    } catch (e) {
      debugPrint('VoiceAudioService: TTS speak error: $e');
      finish();
    }
  }

  Future<void> stopSpeaking() async {
    _speechTimeoutTimer?.cancel();
    _isSpeaking = false;
    try {
      await _player.stop();
    } catch (_) {}
    try {
      await _tts.stop();
    } catch (_) {}
  }

  /// Asks for mic access on Android/iOS before STT init (web skips).
  Future<bool> _ensureMicPermission() async {
    if (kIsWeb) return true;
    final status = await Permission.microphone.status;
    if (status.isGranted) return true;
    if (status.isPermanentlyDenied) {
      debugPrint('VoiceAudioService: mic permanently denied — open settings');
      return false;
    }
    final result = await Permission.microphone.request();
    return result.isGranted;
  }

  Future<bool> initSpeech() async {
    if (_isSpeechInitialized) return true;
    try {
      final micOk = await _ensureMicPermission();
      if (!micOk) {
        debugPrint('VoiceAudioService: microphone permission not granted');
        return false;
      }

      final available = await _speech.initialize(
        onError: (SpeechRecognitionError error) {
          debugPrint('VoiceAudioService: STT error: ${error.errorMsg}');
        },
        onStatus: (String status) {
          debugPrint('VoiceAudioService: STT status: $status');
          if (status == 'notListening' || status == 'done') {
            _isListening = false;
          }
        },
      );

      if (available) {
        _isSpeechInitialized = true;
        try {
          final locales = await _speech.locales();
          for (final loc in locales) {
            if (loc.localeId.toLowerCase().startsWith('hi')) {
              _hindiLocaleId = loc.localeId;
              break;
            }
          }
        } catch (_) {}
      }
      return available;
    } catch (e) {
      debugPrint('VoiceAudioService: STT init failed: $e');
      return false;
    }
  }

  Future<bool> startListening({
    required void Function(String words, bool isFinal) onResult,
    VoidCallback? onDone,
    void Function(String error)? onError,
  }) async {
    await stopSpeaking();

    final ready = await initSpeech();
    if (!ready) {
      onError?.call(
        'माइक्रोफ़ोन की अनुमति दें (Allow microphone in app settings)',
      );
      return false;
    }

    try {
      _isListening = true;
      await _speech.listen(
        onResult: (SpeechRecognitionResult result) {
          onResult(result.recognizedWords, result.finalResult);
          if (result.finalResult) {
            _isListening = false;
            onDone?.call();
          }
        },
        onSoundLevelChange: (level) {
          soundLevel.value = (level / 10.0).clamp(0.0, 1.0);
        },
        listenOptions: stt.SpeechListenOptions(
          localeId: _hindiLocaleId ?? 'hi_IN',
          listenFor: const Duration(seconds: 30),
          pauseFor: const Duration(seconds: 3),
          listenMode: stt.ListenMode.dictation,
          cancelOnError: false,
          partialResults: true,
        ),
      );
      return true;
    } catch (e) {
      _isListening = false;
      onError?.call(e.toString());
      return false;
    }
  }

  Future<void> stopListening() async {
    _isListening = false;
    soundLevel.value = 0.0;
    try {
      await _speech.stop();
    } catch (_) {}
  }

  Future<void> cancelListening() async {
    _isListening = false;
    soundLevel.value = 0.0;
    try {
      await _speech.cancel();
    } catch (_) {}
  }

  void dispose() {
    _speechTimeoutTimer?.cancel();
    _playerCompleteSub?.cancel();
    stopSpeaking();
    stopListening();
    _player.dispose();
  }
}
