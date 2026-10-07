import 'dart:async';
import '../models/models.dart';
import '../core/constants/copy_hindi.dart';
import 'mock_database.dart';
import 'mock_care_stream.dart';

class CheckInTurnResult {
  final int turnIndex;
  final String dhatriTextHindi;
  final List<String> rememberedContext;
  final bool isDone;

  const CheckInTurnResult({
    required this.turnIndex,
    required this.dhatriTextHindi,
    this.rememberedContext = const [],
    this.isDone = false,
  });
}

/// Simulates Sarvam AI (Saaras STT & Bulbul TTS) and Gemini interpretCheckIn pipeline
class MockVoiceEngine {
  final MockDatabase db;
  final MockCareStream careStream;

  MockVoiceEngine(this.db, this.careStream);

  /// Called when the patient accepts the incoming call
  CheckInTurnResult startCall(WellnessCheck check) {
    return const CheckInTurnResult(
      turnIndex: 0,
      dhatriTextHindi: CopyHindi.greetingQuestion,
      rememberedContext: [],
      isDone: false,
    );
  }

  /// Processes patient turn with simulated speech recognition & Patient Memory retrieval
  Future<CheckInTurnResult> submitPatientSpeech({
    required WellnessCheck check,
    required int currentTurn,
    required String patientSpeechHindi,
  }) async {
    // Simulate natural processing delay (STT + Memory retrieval + LLM synthesis)
    await Future.delayed(const Duration(milliseconds: 1200));

    if (currentTurn == 0) {
      // Patient Memory Retrieval Demonstration!
      // Finds previous weakness report from 3 days ago:
      final recalledMemories = [
        'Patient reported weakness (severity 2) during evening check-in on 4 Oct (3 days ago)',
      ];

      return CheckInTurnResult(
        turnIndex: 1,
        dhatriTextHindi: CopyHindi.followUpWithMemory,
        rememberedContext: recalledMemories,
        isDone: false,
      );
    } else {
      // Turn 2: Closing turn
      // Save symptom and memory to DB
      final symptom = SymptomReport(
        id: DateTime.now().millisecondsSinceEpoch,
        patientId: check.patientId,
        checkId: check.id,
        symptom: 'weakness',
        severity: 3,
        reportedAt: DateTime.now(),
      );
      db.symptomReports.add(symptom);

      db.patientMemories.add(PatientMemory(
        id: DateTime.now().millisecondsSinceEpoch,
        patientId: check.patientId,
        kind: 'symptom',
        content: 'Patient reported worsening weakness and mild dizziness in evening check-in.',
        sourceCheckId: check.id,
        createdAt: DateTime.now(),
      ));

      // Mark check as completed
      final completedCheck = check.copyWith(
        status: CheckStatus.completed,
        turnCount: 2,
        replyText: CopyHindi.closingThankYou,
        mood: 'low',
        summaryEn: 'Patient reported recurring weakness (severity 3) and dizziness.',
        memoryUsed: ['Weakness reported 3 days ago'],
        completedAt: DateTime.now(),
      );

      final index = db.wellnessChecks.indexWhere((c) => c.id == check.id);
      if (index != -1) {
        db.wellnessChecks[index] = completedCheck;
      }

      careStream.postUpdate(CareUpdate(
        patientId: check.patientId,
        check: completedCheck,
      ));

      return const CheckInTurnResult(
        turnIndex: 2,
        dhatriTextHindi: CopyHindi.closingThankYou,
        rememberedContext: ['Logged observation to health timeline and alerted daughter Ananya'],
        isDone: true,
      );
    }
  }
}

