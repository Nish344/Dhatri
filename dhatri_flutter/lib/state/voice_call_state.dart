import 'dart:async';

import 'package:flutter/foundation.dart';

import '../core/constants/copy_hindi.dart';
import '../models/models.dart';
import '../repositories/dhatri_repository.dart';
import '../services/voice_audio_service.dart';

enum CallUIPhase {
  incoming,
  connected,
  dhatriSpeaking,
  yourTurn,
  listening,
  thinking,
  ended,
}

class VoiceCallState extends ChangeNotifier {
  final DhatriRepository repository;
  final VoiceAudioService _voiceService = VoiceAudioService();

  CallUIPhase _phase = CallUIPhase.ended;
  WellnessCheck? _activeCheck;
  int _currentTurn = 0;
  String _currentDhatriText = CopyHindi.greetingQuestion;
  String _currentPatientSpeech = '';
  List<String> _rememberedContext = [];
  bool _isDone = false;
  String? _voiceErrorMessage;
  String _lastVoiceSource = 'none';
  bool _starting = false;

  VoiceCallState({required this.repository});

  CallUIPhase get phase => _phase;
  WellnessCheck? get activeCheck => _activeCheck;
  int get currentTurn => _currentTurn;
  String get currentDhatriText => _currentDhatriText;
  String get currentPatientSpeech => _currentPatientSpeech;
  List<String> get rememberedContext => _rememberedContext;
  bool get isDone => _isDone;
  String? get voiceErrorMessage => _voiceErrorMessage;
  VoiceAudioService get voiceService => _voiceService;
  String get lastVoiceSource => _lastVoiceSource;

  String get phaseLabel {
    switch (_phase) {
      case CallUIPhase.incoming:
        return 'आने वाली कॉल (Incoming Call)';
      case CallUIPhase.connected:
        return CopyHindi.stateConnected;
      case CallUIPhase.dhatriSpeaking:
        return CopyHindi.stateDhatriSpeaking;
      case CallUIPhase.yourTurn:
        return CopyHindi.stateYourTurn;
      case CallUIPhase.listening:
        return CopyHindi.stateListening;
      case CallUIPhase.thinking:
        return CopyHindi.stateThinking;
      case CallUIPhase.ended:
        return 'कॉल समाप्त (Call Ended)';
    }
  }

  void receiveIncomingCall(WellnessCheck check) {
    if (_starting) return;
    if (_phase != CallUIPhase.ended && _phase != CallUIPhase.incoming) {
      debugPrint(
        'VoiceCallState: ignore incoming id=${check.id} while phase=$_phase',
      );
      return;
    }
    if (_phase == CallUIPhase.incoming && _activeCheck?.id == check.id) {
      return;
    }
    debugPrint('VoiceCallState: ringing patient for check id=${check.id}');
    _activeCheck = check;
    _phase = CallUIPhase.incoming;
    _currentTurn = 0;
    _currentDhatriText = CopyHindi.greetingQuestion;
    _currentPatientSpeech = '';
    _rememberedContext = [];
    _isDone = false;
    _voiceErrorMessage = null;
    notifyListeners();
  }

  /// Caregiver / demo HUD: queue on server only (patient browser rings).
  Future<bool> triggerCheckIn(int patientId) async {
    try {
      debugPrint('VoiceCallState: startNow patient=$patientId');
      await repository.startCheckIn(patientId);
      final check = await repository.getPendingCheckIn(patientId);
      debugPrint(
        'VoiceCallState: startNow done pendingId=${check?.id} '
        'status=${check?.status.name}',
      );
      return check != null;
    } catch (e, st) {
      debugPrint('VoiceCallState: startNow FAILED: $e\n$st');
      _voiceErrorMessage = 'Could not start check-in: $e';
      notifyListeners();
      return false;
    }
  }

  /// Patient starts a call from Home ("Talk to Dhatri").
  Future<void> startDirectCall(int patientId) async {
    if (_starting) return;
    _starting = true;

    await _voiceService.stopSpeaking();
    await _voiceService.stopListening();

    // Drop any stale local check — hang-up must not leave us binding to an
    // already-active row that pending() cannot see.
    _activeCheck = null;
    _isDone = false;
    _currentTurn = 0;
    _currentPatientSpeech = '';
    _rememberedContext = [];
    _voiceErrorMessage = null;
    _phase = CallUIPhase.connected;
    notifyListeners();

    try {
      await repository.startCheckIn(patientId);
      final check = await repository.getPendingCheckIn(patientId);
      if (check != null) {
        _activeCheck = check;
      } else {
        debugPrint(
          'VoiceCallState: startDirectCall got null pending for patient=$patientId',
        );
      }
    } catch (e, st) {
      debugPrint('VoiceCallState: startDirectCall FAILED: $e\n$st');
      _voiceErrorMessage = 'Check-in could not be started: $e';
    }

    if (_activeCheck == null) {
      _phase = CallUIPhase.ended;
      _voiceErrorMessage ??=
          'Check-in could not be started. Is the server online?';
      _starting = false;
      notifyListeners();
      return;
    }

    try {
      await acceptCall();
    } finally {
      _starting = false;
    }
  }

  Future<void> acceptCall() async {
    _phase = CallUIPhase.connected;
    _voiceErrorMessage = null;
    notifyListeners();

    final checkId = _activeCheck?.id;
    if (checkId == null || checkId <= 0) {
      _voiceErrorMessage = 'No active check-in to accept';
      _phase = CallUIPhase.ended;
      _activeCheck = null;
      notifyListeners();
      return;
    }

    String greeting = CopyHindi.greetingQuestion;
    ByteData? audio;

    try {
      final turn = await repository.acceptCheckIn(checkId);
      if (turn.text.trim().isNotEmpty) {
        greeting = turn.text;
      }
      audio = turn.audio;
    } catch (e, st) {
      debugPrint('VoiceCallState: acceptCheckIn FAILED: $e\n$st');
      _voiceErrorMessage = 'Accept failed: $e';
      _phase = CallUIPhase.ended;
      _activeCheck = null;
      notifyListeners();
      return;
    }

    _currentDhatriText = greeting;
    _phase = CallUIPhase.dhatriSpeaking;
    notifyListeners();

    await _speakTurn(greeting, audio, onComplete: () {
      if (_phase == CallUIPhase.dhatriSpeaking) {
        _phase = CallUIPhase.yourTurn;
        notifyListeners();
      }
    });
  }

  Future<void> startListening() async {
    if (_phase == CallUIPhase.listening) {
      await stopListeningAndSubmit();
      return;
    }

    await _voiceService.stopSpeaking();
    _currentPatientSpeech = '';
    _voiceErrorMessage = null;
    _phase = CallUIPhase.listening;
    notifyListeners();

    final started = await _voiceService.startListening(
      onResult: (words, isFinal) {
        _currentPatientSpeech = words;
        notifyListeners();
        if (isFinal && words.trim().isNotEmpty) {
          submitPatientResponse(words);
        }
      },
      onDone: () {
        if (_phase == CallUIPhase.listening) {
          if (_currentPatientSpeech.trim().isNotEmpty) {
            submitPatientResponse(_currentPatientSpeech);
          } else {
            _phase = CallUIPhase.yourTurn;
            notifyListeners();
          }
        }
      },
      onError: (error) {
        _voiceErrorMessage = error;
        if (_phase == CallUIPhase.listening) {
          _phase = CallUIPhase.yourTurn;
          notifyListeners();
        }
      },
    );

    if (!started) {
      _voiceErrorMessage =
          'कृपया माइक्रोफ़ोन की अनुमति दें (Please allow microphone access)';
      _phase = CallUIPhase.yourTurn;
      notifyListeners();
    }
  }

  Future<void> stopListeningAndSubmit() async {
    await _voiceService.stopListening();
    final words = _currentPatientSpeech.trim();
    if (words.isNotEmpty) {
      await submitPatientResponse(words);
    } else {
      _phase = CallUIPhase.yourTurn;
      notifyListeners();
    }
  }

  Future<void> submitPatientResponse(String text) async {
    await _voiceService.stopListening();
    final cleanText = text.trim();
    if (cleanText.isEmpty) return;

    _currentPatientSpeech = cleanText;
    _phase = CallUIPhase.thinking;
    _voiceErrorMessage = null;
    notifyListeners();

    final checkId = _activeCheck?.id;
    if (checkId == null || checkId <= 0) {
      _voiceErrorMessage = 'No active check-in';
      _phase = CallUIPhase.yourTurn;
      notifyListeners();
      return;
    }

    try {
      final turn = await repository.answerCheckInText(checkId, cleanText);
      _currentTurn = turn.turnIndex;
      _currentDhatriText = turn.text;
      _isDone = turn.done;

      if (cleanText.contains('कमजोरी') ||
          cleanText.contains('weakness') ||
          cleanText.contains('चक्कर') ||
          cleanText.contains('dizzy') ||
          turn.text.contains('3 दिन पहले') ||
          turn.text.contains('कुछ दिन पहले')) {
        _rememberedContext = [
          'Earlier check-in: weakness recalled via Patient Memory',
        ];
      }

      _phase = CallUIPhase.dhatriSpeaking;
      notifyListeners();

      await _speakTurn(
        _currentDhatriText,
        turn.audio,
        onComplete: () {
          if (_isDone) {
            _phase = CallUIPhase.ended;
            _activeCheck = null;
          } else {
            _phase = CallUIPhase.yourTurn;
          }
          notifyListeners();
        },
      );
    } catch (e, st) {
      debugPrint('VoiceCallState: answerText FAILED: $e\n$st');
      _voiceErrorMessage = 'Reply failed: $e';
      _phase = CallUIPhase.yourTurn;
      notifyListeners();
    }
  }

  Future<void> submitAudioResponse(ByteData audio) async {
    _phase = CallUIPhase.thinking;
    notifyListeners();

    final checkId = _activeCheck?.id;
    if (checkId == null) return;

    try {
      final turn = await repository.answerCheckInAudio(checkId, audio);
      _currentTurn = turn.turnIndex;
      _currentDhatriText = turn.text;
      _isDone = turn.done;

      _phase = CallUIPhase.dhatriSpeaking;
      notifyListeners();

      await _speakTurn(
        _currentDhatriText,
        turn.audio,
        onComplete: () {
          if (_isDone) {
            _phase = CallUIPhase.ended;
            _activeCheck = null;
          } else {
            _phase = CallUIPhase.yourTurn;
          }
          notifyListeners();
        },
      );
    } catch (e, st) {
      debugPrint('VoiceCallState: answerAudio FAILED: $e\n$st');
      _voiceErrorMessage = 'Audio answer failed: $e';
      _phase = CallUIPhase.yourTurn;
      notifyListeners();
    }
  }

  Future<void> _speakTurn(
    String text,
    ByteData? audio, {
    VoidCallback? onComplete,
  }) async {
    await _voiceService.speakTurn(
      text: text,
      audio: audio,
      onComplete: onComplete,
    );
    _lastVoiceSource = _voiceService.lastVoiceSource;
    notifyListeners();
  }

  /// Hang up / decline. Always clears local state so Talk-to-Dhatri works again.
  Future<void> endCall() async {
    await _voiceService.stopSpeaking();
    await _voiceService.stopListening();

    final checkId = _activeCheck?.id;
    final shouldNotifyServer = checkId != null && checkId > 0 && !_isDone;

    _phase = CallUIPhase.ended;
    _activeCheck = null;
    _isDone = false;
    _currentTurn = 0;
    _currentPatientSpeech = '';
    _starting = false;
    notifyListeners();

    if (shouldNotifyServer) {
      try {
        // Server: active → completed (hang-up); pending → snoozed (decline).
        await repository.snoozeCheckIn(checkId);
      } catch (e) {
        debugPrint('VoiceCallState: hangUp/snooze failed: $e');
      }
    }
  }

  void resetCall() {
    _voiceService.stopSpeaking();
    _voiceService.stopListening();
    _phase = CallUIPhase.ended;
    _activeCheck = null;
    _currentTurn = 0;
    _currentDhatriText = CopyHindi.greetingQuestion;
    _currentPatientSpeech = '';
    _rememberedContext = [];
    _isDone = false;
    _voiceErrorMessage = null;
    _lastVoiceSource = 'none';
    _starting = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _voiceService.dispose();
    super.dispose();
  }
}
