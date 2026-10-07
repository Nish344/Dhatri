import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../core/constants/copy_hindi.dart';
import '../mock_engine/mock_voice_engine.dart';
import '../mock_engine/mock_care_stream.dart';

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
  final MockVoiceEngine voiceEngine;
  final MockCareStream careStream;

  CallUIPhase _phase = CallUIPhase.incoming;
  WellnessCheck? _activeCheck;
  int _currentTurn = 0;
  String _currentDhatriText = CopyHindi.greetingQuestion;
  String _currentPatientSpeech = '';
  List<String> _rememberedContext = [];
  bool _isDone = false;

  VoiceCallState({
    required this.voiceEngine,
    required this.careStream,
  });

  CallUIPhase get phase => _phase;
  WellnessCheck? get activeCheck => _activeCheck;
  int get currentTurn => _currentTurn;
  String get currentDhatriText => _currentDhatriText;
  String get currentPatientSpeech => _currentPatientSpeech;
  List<String> get rememberedContext => _rememberedContext;
  bool get isDone => _isDone;

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
    notifyListeners();
  }

  void acceptCall() {
    _phase = CallUIPhase.connected;
    notifyListeners();

    // After brief connect, Dhatri speaks greeting
    Future.delayed(const Duration(milliseconds: 600), () {
      _phase = CallUIPhase.dhatriSpeaking;
      _currentDhatriText = CopyHindi.greetingQuestion;
      notifyListeners();

      // Dhatri finishes greeting -> patient turn
      Future.delayed(const Duration(seconds: 2), () {
        _phase = CallUIPhase.yourTurn;
        notifyListeners();
      });
    });
  }

  void startListening() {
    _phase = CallUIPhase.listening;
    notifyListeners();
  }

  /// Patient speaks or selects quick Hindi answer chip
  Future<void> submitPatientResponse(String text) async {
    _currentPatientSpeech = text;
    _phase = CallUIPhase.thinking;
    notifyListeners();

    if (_activeCheck == null) return;

    final result = await voiceEngine.submitPatientSpeech(
      check: _activeCheck!,
      currentTurn: _currentTurn,
      patientSpeechHindi: text,
    );

    _currentTurn = result.turnIndex;
    _currentDhatriText = result.dhatriTextHindi;
    _rememberedContext = result.rememberedContext;
    _isDone = result.isDone;

    _phase = CallUIPhase.dhatriSpeaking;
    notifyListeners();

    if (!_isDone) {
      // Allow user to respond to turn 2
      Future.delayed(const Duration(seconds: 3), () {
        _phase = CallUIPhase.yourTurn;
        notifyListeners();
      });
    } else {
      // Call completes after closing sentence
      Future.delayed(const Duration(seconds: 4), () {
        _phase = CallUIPhase.ended;
        notifyListeners();
      });
    }
  }

  void endCall() {
    _phase = CallUIPhase.ended;
    notifyListeners();
  }
}

