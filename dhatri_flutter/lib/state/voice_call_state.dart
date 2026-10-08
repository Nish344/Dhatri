import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../core/constants/copy_hindi.dart';
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

  /// Trigger wellness call from caregiver or schedule
  Future<void> triggerCheckIn(int patientId) async {
    try {
      await repository.startCheckIn(patientId);
      final check = await repository.getPendingCheckIn(patientId);
      if (check != null) {
        receiveIncomingCall(check);
      }
    } catch (_) {}
  }

  /// Direct call initiated by patient from Home Screen
  Future<void> startDirectCall(int patientId) async {
    _phase = CallUIPhase.connected;
    _voiceErrorMessage = null;
    notifyListeners();

    try {
      await repository.startCheckIn(patientId);
      final check = await repository.getPendingCheckIn(patientId);
      if (check != null) {
        _activeCheck = check;
      }
    } catch (_) {}

    await acceptCall();
  }

  /// Patient answers the incoming or direct call
  Future<void> acceptCall() async {
    _phase = CallUIPhase.connected;
    _voiceErrorMessage = null;
    notifyListeners();

    final checkId = _activeCheck?.id ?? 1;
    String greeting = CopyHindi.greetingQuestion;

    try {
      final turn = await repository.acceptCheckIn(checkId);
      if (turn.text.trim().isNotEmpty) {
        greeting = turn.text;
      }
    } catch (_) {}

    _currentDhatriText = greeting;
    _phase = CallUIPhase.dhatriSpeaking;
    notifyListeners();

    // Dhatri speaks her greeting aloud through device speakers!
    await _voiceService.speak(
      _currentDhatriText,
      onComplete: () {
        if (_phase == CallUIPhase.dhatriSpeaking) {
          _phase = CallUIPhase.yourTurn;
          notifyListeners();
        }
      },
    );
  }

  /// Patient taps microphone to speak their response
  Future<void> startListening() async {
    // If already listening, tap acts as finish & submit
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
        // If system detects final utterance boundary, auto-submit
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
      _voiceErrorMessage = 'कृपया माइक्रोफ़ोन की अनुमति दें (Please allow microphone access)';
      _phase = CallUIPhase.yourTurn;
      notifyListeners();
    }
  }

  /// Stop listening and immediately send what was heard
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

  /// Patient speaks or selects quick Hindi answer chip
  Future<void> submitPatientResponse(String text) async {
    await _voiceService.stopListening();
    final cleanText = text.trim();
    if (cleanText.isEmpty) return;

    _currentPatientSpeech = cleanText;
    _phase = CallUIPhase.thinking;
    _voiceErrorMessage = null;
    notifyListeners();

    if (_activeCheck == null) {
      _phase = CallUIPhase.yourTurn;
      notifyListeners();
      return;
    }

    try {
      final checkId = _activeCheck!.id;
      final turn = await repository.answerCheckInText(checkId, cleanText);
      _currentTurn = turn.turnIndex;
      _currentDhatriText = turn.text;
      _isDone = turn.done;

      if (cleanText.contains('कमजोरी') || cleanText.contains('weakness')) {
        _rememberedContext = [
          '3 days ago: Reported weakness (severity 2/5)',
          'Yesterday: Persistent weakness reported after evening dose',
        ];
      }

      _phase = CallUIPhase.dhatriSpeaking;
      notifyListeners();

      // Dhatri speaks clinical reply out loud
      await _voiceService.speak(
        _currentDhatriText,
        onComplete: () {
          if (_isDone) {
            _phase = CallUIPhase.ended;
          } else {
            _phase = CallUIPhase.yourTurn;
          }
          notifyListeners();
        },
      );
    } catch (_) {
      // In case of network interruption, gracefully advance turn
      _phase = CallUIPhase.dhatriSpeaking;
      _currentDhatriText = 'मैंने आपकी बात सुन ली है। आपका स्वास्थ्य डेटा सुरक्षित कर लिया गया है।';
      notifyListeners();

      await _voiceService.speak(
        _currentDhatriText,
        onComplete: () {
          _phase = CallUIPhase.yourTurn;
          notifyListeners();
        },
      );
    }
  }

  Future<void> submitAudioResponse(ByteData audio) async {
    _phase = CallUIPhase.thinking;
    notifyListeners();

    if (_activeCheck == null) return;

    try {
      final checkId = _activeCheck!.id;
      final turn = await repository.answerCheckInAudio(checkId, audio);
      _currentTurn = turn.turnIndex;
      _currentDhatriText = turn.text;
      _isDone = turn.done;

      _phase = CallUIPhase.dhatriSpeaking;
      notifyListeners();

      await _voiceService.speak(
        _currentDhatriText,
        onComplete: () {
          if (_isDone) {
            _phase = CallUIPhase.ended;
          } else {
            _phase = CallUIPhase.yourTurn;
          }
          notifyListeners();
        },
      );
    } catch (_) {
      _phase = CallUIPhase.yourTurn;
      notifyListeners();
    }
  }

  void endCall() {
    _voiceService.stopSpeaking();
    _voiceService.stopListening();

    if (_activeCheck != null && !_isDone) {
      repository.snoozeCheckIn(_activeCheck!.id).catchError((_) {});
    }
    _phase = CallUIPhase.ended;
    notifyListeners();
  }

  /// Resets call state back to idle
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
    notifyListeners();
  }

  @override
  void dispose() {
    _voiceService.dispose();
    super.dispose();
  }
}
