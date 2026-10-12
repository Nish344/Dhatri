import 'dart:io';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'care_bus.dart';
import 'copy_hi.dart';
import 'gemini.dart';
import 'insight_service.dart';
import 'memory_service.dart';
import 'safety_rules.dart';
import 'symptom_rules.dart';
import 'voice_engine.dart';

final maxTurns = int.parse(Platform.environment['MAX_TURNS'] ?? '2');

/// `pending/snoozed → active`, returns turn 0: the Hindi greeting.
/// Accepting an already active check (app reconnect) just repeats the greeting.
Future<CheckInTurn> acceptCheckIn(
  Session session,
  WellnessCheck check,
  VoiceEngine voice,
) async {
  session.log(
    'checkIn.accept id=${check.id} patient=${check.patientId} '
    'status=${check.status.name} rings=${check.ringCount} '
    'snoozes=${check.snoozeCount}',
  );
  if (check.status == CheckStatus.completed) {
    throw StateError('This check-in has already finished');
  }
  if (check.status != CheckStatus.active) {
    // Reset turnCount so ring/snooze counters never bleed into speech turns.
    check = await WellnessCheck.db.updateRow(
      session,
      check.copyWith(status: CheckStatus.active, turnCount: 0),
    );
    await postUpdate(
      session,
      check.patientId,
      CareUpdate(patientId: check.patientId, check: check),
    );
    session.log('checkIn.accept activated id=${check.id}');
  }
  final patient = await Profile.db.findById(session, check.patientId);
  final text = greetingHi(patient!.name);
  final audio = await _speakOrSilence(session, voice, text);
  session.log(
    'checkIn.accept greeting ready id=${check.id} '
    'audioBytes=${audio.lengthInBytes}',
  );
  return CheckInTurn(
    checkId: check.id!,
    turnIndex: 0,
    text: text,
    audio: audio,
    done: false,
  );
}

/// Speech path: AAC → Sarvam STT → [answerCheckInWithTranscript].
Future<CheckInTurn> answerCheckIn(
  Session session,
  WellnessCheck check,
  Uint8List audio, {
  required Gemini gemini,
  required VoiceEngine voice,
  required MemoryService memory,
}) async {
  if (check.status != CheckStatus.active) {
    throw StateError('This check-in is not active');
  }

  session.log(
    'checkIn.answer(audio) id=${check.id} patient=${check.patientId} '
    'turn=${check.turnCount} audioBytes=${audio.length}',
  );
  final sttStarted = DateTime.now().toUtc();
  final transcript = await voice.transcribe(audio);
  final sttMs = DateTime.now().toUtc().difference(sttStarted).inMilliseconds;
  session.log(
    'checkIn.stt id=${check.id} ms=$sttMs chars=${transcript.length} '
    'empty=${transcript.isEmpty}',
  );
  if (transcript.isEmpty) {
    return CheckInTurn(
      checkId: check.id!,
      turnIndex: check.turnCount,
      text: sayAgainHi,
      audio: await _speakOrSilence(session, voice, sayAgainHi),
      done: false,
    );
  }
  return answerCheckInWithTranscript(
    session,
    check,
    transcript,
    gemini: gemini,
    voice: voice,
    memory: memory,
  );
}

/// Text path for the four Hindi answer buttons when STT is unreliable.
Future<CheckInTurn> answerCheckInWithTranscript(
  Session session,
  WellnessCheck check,
  String transcript, {
  required Gemini gemini,
  required VoiceEngine voice,
  required MemoryService memory,
}) async {
  if (check.status != CheckStatus.active) {
    throw StateError('This check-in is not active');
  }
  final patientId = check.patientId;
  final cleaned = transcript.trim();
  session.log(
    'checkIn.answer(text) id=${check.id} patient=$patientId '
    'turn=${check.turnCount} chars=${cleaned.length}',
  );
  if (cleaned.isEmpty) {
    return CheckInTurn(
      checkId: check.id!,
      turnIndex: check.turnCount,
      text: sayAgainHi,
      audio: await _speakOrSilence(session, voice, sayAgainHi),
      done: false,
    );
  }

  final now = DateTime.now().toUtc();
  final weekAgo = now.subtract(const Duration(days: 7));
  final (patient, symptoms, today, week, memories) = await (
    Profile.db.findById(session, patientId),
    symptomCounts(session, patientId, weekAgo, now),
    doseCounts(session, patientId, istDayStartUtc(now), now),
    doseCounts(session, patientId, weekAgo, now),
    // Retrieval runs before this turn is remembered, so it never finds itself.
    memory.retrieve(session, patientId, cleaned).catchError((Object e) {
      session.log('Memory retrieval failed: $e', level: LogLevel.warning);
      return <PatientMemory>[];
    }),
  ).wait;
  final name = patient!.name;
  final emergency = scanEmergency(cleaned);
  final turnCount = check.turnCount + 1;
  final lastTurn = turnCount >= maxTurns;
  session.log(
    'checkIn.context id=${check.id} turn=$turnCount/$maxTurns '
    'memories=${memories.length} symptoms7d=${symptoms.length} '
    'dosesToday=${today.taken}/${today.missed} '
    'emergency=${emergency.isNotEmpty}',
  );

  CheckInReading reading;
  final geminiStarted = DateTime.now().toUtc();
  try {
    reading = await gemini.interpretCheckIn(
      CheckInPacket(
        patientName: name,
        transcript: cleaned,
        symptomsLast7Days: symptoms,
        dosesToday: today,
        dosesWeek: week,
        memories: [
          for (final m in memories)
            '${now.difference(m.createdAt).inDays} days ago: ${m.content}',
        ],
        emergencyPhrases: emergency,
        isLastTurn: lastTurn,
      ),
    );
    session.log(
      'checkIn.gemini id=${check.id} '
      'ms=${DateTime.now().toUtc().difference(geminiStarted).inMilliseconds} '
      'mood=${reading.mood} symptoms=${reading.symptoms.length} '
      'followup=${reading.needsFollowup} '
      'observations=${reading.observationsEn.length}',
    );
  } catch (e) {
    // The call must still end politely and the safety rule must still fire.
    session.log('interpretCheckIn failed: $e', level: LogLevel.error);
    reading = CheckInReading(
      mood: null,
      symptoms: [],
      observationsEn: [],
      summaryEn:
          'Patient answered; the answer could not be interpreted automatically.',
      replyHi: '',
      needsFollowup: false,
    );
  }

  final severe =
      emergency.isNotEmpty || reading.symptoms.any((s) => s.severity >= 4);
  final done = lastTurn || !reading.needsFollowup || severe;
  final reply = severe
      ? '$caregiverInformedHi ${closingHi(name)}'
      : done
      ? (reading.replyHi.isEmpty
            ? closingHi(name)
            : '${reading.replyHi} ${closingHi(name)}')
      : reading.replyHi;

  final updated = await WellnessCheck.db.updateRow(
    session,
    check.copyWith(
      turnCount: turnCount,
      transcript: [
        if (check.transcript != null) check.transcript!,
        cleaned,
      ].join('\n'),
      replyText: reply,
      mood: reading.mood ?? check.mood,
      summaryEn: reading.summaryEn.isEmpty
          ? check.summaryEn
          : reading.summaryEn,
      memoryUsed: [...?check.memoryUsed, for (final m in memories) m.content],
      status: done ? CheckStatus.completed : CheckStatus.active,
      completedAt: done ? now : null,
    ),
  );

  await applySymptomRules(session, patientId, check.id!, reading.symptoms);
  if (emergency.isNotEmpty && !reading.symptoms.any((s) => s.severity >= 4)) {
    final alert = await Alert.db.insertRow(
      session,
      Alert(
        patientId: patientId,
        kind: AlertKind.severeSymptom,
        priority: AlertPriority.high,
        message: 'Immediate caregiver review recommended',
        createdAt: now,
      ),
    );
    session.log(
      'checkIn.emergencyAlert id=${check.id} alertId=${alert.id} '
      'phrases=${emergency.join(",")}',
      level: LogLevel.warning,
    );
    await postUpdate(
      session,
      patientId,
      CareUpdate(patientId: patientId, alert: alert),
    );
  }

  final (replyAudio, _) = await (
    _speakOrSilence(session, voice, reply),
    _remember(session, patientId, check.id!, reading, gemini, memory),
  ).wait;

  await postUpdate(
    session,
    patientId,
    CareUpdate(patientId: patientId, check: updated),
  );
  session.log(
    'checkIn.turnDone id=${check.id} turn=$turnCount done=$done '
    'severe=$severe status=${updated.status.name} '
    'replyChars=${reply.length} audioBytes=${replyAudio.lengthInBytes}',
  );
  return CheckInTurn(
    checkId: check.id!,
    turnIndex: turnCount,
    text: reply,
    audio: replyAudio,
    done: done,
  );
}

Future<void> _remember(
  Session session,
  int patientId,
  int checkId,
  CheckInReading reading,
  Gemini gemini,
  MemoryService memory,
) async {
  final mentionsSymptom = reading.symptoms.isNotEmpty;
  if (reading.observationsEn.isEmpty) {
    session.log('checkIn.memory skip checkId=$checkId (no observations)');
    return;
  }
  session.log(
    'checkIn.memory store checkId=$checkId '
    'count=${reading.observationsEn.length} kind='
    '${mentionsSymptom ? 'symptom' : 'note'}',
  );
  for (final observation in reading.observationsEn) {
    try {
      final embedding = Vector(await gemini.embed(observation));
      await memory.remember(
        session,
        patientId,
        mentionsSymptom ? 'symptom' : 'note',
        observation,
        checkId,
        embedding,
      );
    } catch (e) {
      session.log(
        'Could not store memory "$observation": $e',
        level: LogLevel.warning,
      );
    }
  }
}

/// The app always shows the text, so a TTS outage degrades to silent text.
Future<ByteData> _speakOrSilence(
  Session session,
  VoiceEngine voice,
  String text,
) async {
  try {
    final started = DateTime.now().toUtc();
    final audio = await voice.speak(text);
    session.log(
      'checkIn.tts chars=${text.length} bytes=${audio.lengthInBytes} '
      'ms=${DateTime.now().toUtc().difference(started).inMilliseconds}',
    );
    return audio;
  } catch (e) {
    session.log('Text-to-speech failed: $e', level: LogLevel.warning);
    return ByteData(0);
  }
}
