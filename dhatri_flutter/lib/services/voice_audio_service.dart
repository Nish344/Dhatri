import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

/// Service managing on-device Text-to-Speech (TTS) for Dhatri's Hindi voice
/// and live Speech-to-Text (STT) for capturing the patient's voice via microphone.
class VoiceAudioService {
  static final VoiceAudioService _instance = VoiceAudioService._internal();
  factory VoiceAudioService() => _instance;
  VoiceAudioService._internal();

  final FlutterTts _tts = FlutterTts();
  final stt.SpeechToText _speech = stt.SpeechToText();

  bool _isTtsInitialized = false;
  bool _isSpeechInitialized = false;
  bool _isSpeaking = false;
  bool _isListening = false;

  String? _hindiLocaleId;
  Timer? _speechTimeoutTimer;

  final ValueNotifier<double> soundLevel = ValueNotifier<double>(0.0);

  bool get isSpeaking => _isSpeaking;
  bool get isListening => _isListening;
  bool get isSpeechAvailable => _isSpeechInitialized;

  // ---------------------------------------------------------------------------
  // TEXT-TO-SPEECH (Dhatri speaking to patient)
  // ---------------------------------------------------------------------------

  Future<void> initTts() async {
    if (_isTtsInitialized) return;
    try {
      // Configure Hindi for Indian elder comprehension
      await _tts.setLanguage('hi-IN');
      await _tts.setSpeechRate(0.42); // Gentle, calm tempo for elderly ears
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);

      if (!kIsWeb) {
        try {
          await _tts.awaitSpeakCompletion(true);
        } catch (_) {}
      }

      _tts.setStartHandler(() {
        _isSpeaking = true;
      });

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

  /// Speaks [text] out loud through the device speakers in Hindi.
  /// Fires [onComplete] when finished or after safety timeout.
  Future<void> speak(String text, {VoidCallback? onComplete}) async {
    final cleanText = text.trim();
    if (cleanText.isEmpty) {
      onComplete?.call();
      return;
    }

    await initTts();
    _speechTimeoutTimer?.cancel();

    bool hasCompleted = false;
    void finish() {
      if (hasCompleted) return;
      hasCompleted = true;
      _isSpeaking = false;
      _speechTimeoutTimer?.cancel();
      onComplete?.call();
    }

    _tts.setCompletionHandler(() => finish());

    // Fallback safety timeout (prevents getting stuck if TTS completion hook fails)
    final timeoutSecs = ((cleanText.length * 0.08) + 2.0).clamp(3.0, 14.0).toInt();
    _speechTimeoutTimer = Timer(Duration(seconds: timeoutSecs), () {
      finish();
    });

    try {
      _isSpeaking = true;
      final res = await _tts.speak(cleanText);
      if (res != 1 && res != true) {
        // Fallback if platform TTS returns immediately or fails
        finish();
      }
    } catch (e) {
      debugPrint('VoiceAudioService: TTS speak error: $e');
      finish();
    }
  }

  /// Stops ongoing speech playback.
  Future<void> stopSpeaking() async {
    _speechTimeoutTimer?.cancel();
    _isSpeaking = false;
    try {
      await _tts.stop();
    } catch (_) {}
  }

  // ---------------------------------------------------------------------------
  // SPEECH-TO-TEXT (Patient speaking into microphone)
  // ---------------------------------------------------------------------------

  Future<bool> initSpeech() async {
    if (_isSpeechInitialized) return true;
    try {
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

  /// Activates the device microphone and listens to the patient.
  /// [onResult] is called with recognized words in real time as they speak.
  Future<bool> startListening({
    required void Function(String words, bool isFinal) onResult,
    VoidCallback? onDone,
    void Function(String error)? onError,
  }) async {
    // Stop any ongoing TTS before listening so mic doesn't catch Dhatri's own voice
    await stopSpeaking();

    final ready = await initSpeech();
    if (!ready) {
      onError?.call('माइक्रोफ़ोन या वाक् पहचान उपलब्ध नहीं है (Microphone unavailable)');
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
          // Normalized level between 0.0 and 1.0 for waveform
          soundLevel.value = (level / 10.0).clamp(0.0, 1.0);
        },
        localeId: _hindiLocaleId ?? 'hi_IN',
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3), // 3s pause completes turn
        listenMode: stt.ListenMode.dictation,
        cancelOnError: false,
        partialResults: true,
      );
      return true;
    } catch (e) {
      _isListening = false;
      onError?.call(e.toString());
      return false;
    }
  }

  /// Stops recording and finalizes words.
  Future<void> stopListening() async {
    _isListening = false;
    soundLevel.value = 0.0;
    try {
      await _speech.stop();
    } catch (_) {}
  }

  /// Cancels recording and discards.
  Future<void> cancelListening() async {
    _isListening = false;
    soundLevel.value = 0.0;
    try {
      await _speech.cancel();
    } catch (_) {}
  }

  void dispose() {
    _speechTimeoutTimer?.cancel();
    stopSpeaking();
    stopListening();
  }
}

