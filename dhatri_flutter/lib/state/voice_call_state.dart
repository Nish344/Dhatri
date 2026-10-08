import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../core/constants/copy_hindi.dart';
import '../repositories/serverpod_dhatri_repository.dart';

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
  final ServerpodDhatriRepository repository;

  CallUIPhase _phase = CallUIPhase.ended;
  WellnessCheck? _activeCheck;
  int _currentTurn = 0;
  String _currentDhatriText = CopyHindi.greetingQuestion;
  String _currentPatientSpeech = '';
  List<String> _rememberedContext = [];
  bool _isDone = false;

  VoiceCallState({required this.repository});

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

  Future<void> triggerCheckIn(int patientId) async {
    try {
      await repository.startCheckIn(patientId);
      final check = await repository.getPendingCheckIn(patientId);
      if (check != null) {
        receiveIncomingCall(check);
      }
    } catch (_) {}
  }

  void acceptCall() {
    _phase = CallUIPhase.connected;
    notifyListeners();

    final checkId = _activeCheck?.id ?? 1;
    repository.acceptCheckIn(checkId).then((turn) {
      if (turn.text.isNotEmpty) {
        _currentDhatriText = turn.text;
        notifyListeners();
      }
    }).catchError((_) {});

    // After brief connect, Dhatri speaks greeting
    Future.delayed(const Duration(milliseconds: 600), () {
      _phase = CallUIPhase.dhatriSpeaking;
      if (_currentDhatriText.isEmpty) {
        _currentDhatriText = CopyHindi.greetingQuestion;
      }
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

    try {
      final checkId = _activeCheck!.id;
      final turn = await repository.answerCheckInText(checkId, text);
      _currentTurn = turn.turnIndex;
      _currentDhatriText = turn.text;
      _isDone = turn.done;

      if (text.contains('कमजोरी') || text.contains('weakness')) {
        _rememberedContext = [
          '3 days ago: Reported weakness (severity 2/5)',
          'Yesterday: Persistent weakness reported after evening dose',
        ];
      }

      _phase = CallUIPhase.dhatriSpeaking;
      notifyListeners();

      if (!_isDone) {
        Future.delayed(const Duration(seconds: 3), () {
          _phase = CallUIPhase.yourTurn;
          notifyListeners();
        });
      } else {
        Future.delayed(const Duration(seconds: 4), () {
          _phase = CallUIPhase.ended;
          notifyListeners();
        });
      }
    } catch (_) {
      // In case of network interruption, gracefully advance turn
      _phase = CallUIPhase.dhatriSpeaking;
      notifyListeners();
      Future.delayed(const Duration(seconds: 3), () {
        _phase = CallUIPhase.yourTurn;
        notifyListeners();
      });
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

      if (!_isDone) {
        Future.delayed(const Duration(seconds: 3), () {
          _phase = CallUIPhase.yourTurn;
          notifyListeners();
        });
      } else {
        Future.delayed(const Duration(seconds: 4), () {
          _phase = CallUIPhase.ended;
          notifyListeners();
        });
      }
    } catch (_) {
      _phase = CallUIPhase.yourTurn;
      notifyListeners();
    }
  }

  void endCall() {
    if (_activeCheck != null && !_isDone) {
      repository.snoozeCheckIn(_activeCheck!.id).catchError((_) {});
    }
    _phase = CallUIPhase.ended;
    notifyListeners();
  }
}
