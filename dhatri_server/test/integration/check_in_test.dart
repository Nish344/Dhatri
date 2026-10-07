import 'dart:convert';
import 'dart:typed_data';

import 'package:dhatri_server/src/generated/protocol.dart';
import 'package:dhatri_server/src/services/check_in_service.dart';
import 'package:dhatri_server/src/services/copy_hi.dart';
import 'package:dhatri_server/src/services/gemini.dart';
import 'package:dhatri_server/src/services/insight_service.dart';
import 'package:dhatri_server/src/services/memory_service.dart';
import 'package:dhatri_server/src/services/voice_engine.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'fixtures.dart';
import 'test_tools/serverpod_test_tools.dart';

class FakeVoice implements VoiceEngine {
  FakeVoice(this.transcript);
  final String transcript;
  @override
  Future<String> transcribe(Uint8List audio) async => transcript;
  @override
  Future<ByteData> speak(String text) async => ByteData(4);
}

Vector weakVec() => Vector([1.0, ...List.filled(767, 0.0)]);

/// Gemini over a fake HTTP client: embeddings all point "weakness"-ward,
/// generateContent returns [reading] (or fails when null). Prompts are kept.
Gemini fakeGemini(Map<String, dynamic>? reading, List<String> prompts) =>
    Gemini(
      'test',
      client: MockClient((req) async {
        if (req.url.path.endsWith(':embedContent')) {
          return http.Response(
            jsonEncode({
              'embedding': {'values': weakVec().toList()},
            }),
            200,
          );
        }
        prompts.add(utf8.decode(req.bodyBytes));
        if (reading == null) return http.Response('overloaded', 503);
        return http.Response.bytes(
          utf8.encode(
            jsonEncode({
              'candidates': [
                {
                  'content': {
                    'parts': [
                      {'text': jsonEncode(reading)},
                    ],
                  },
                },
              ],
            }),
          ),
          200,
        );
      }),
    );

Map<String, dynamic> reading({
  List<Map<String, Object>> symptoms = const [],
  bool followup = false,
}) => {
  'mood': 'low',
  'symptoms': symptoms,
  'observationsEn': ['Patient reported weakness, moderate, in the evening.'],
  'summaryEn': 'Feels weak again.',
  'replyHi': 'आपने कुछ दिन पहले भी कमजोरी की बात कही थी। क्या आज यह ज्यादा है?',
  'needsFollowup': followup,
};

void main() {
  withServerpod('Care call pipeline', (sessionBuilder, _) {
    late Session session;
    late Profile patient;
    late WellnessCheck check;

    setUp(() async {
      session = sessionBuilder.build();
      patient = await insertProfile(
        session,
        authUserId: 'call-${DateTime.now().microsecondsSinceEpoch}',
        name: 'Ramesh',
        role: Role.patient,
      );
      check = await insertCheck(session, patient.id!);
    });

    Future<CheckInTurn> answer(Gemini gemini, String said) => answerCheckIn(
      session,
      check,
      Uint8List(8),
      gemini: gemini,
      voice: FakeVoice(said),
      memory: memoryServiceFor(gemini),
    );

    test(
      'recalls earlier weakness, stores the symptom and remembers the turn',
      () async {
        await PatientMemory.db.insertRow(
          session,
          PatientMemory(
            patientId: patient.id!,
            kind: 'symptom',
            content: 'Patient reported weakness, mild, in the evening.',
            embedding: weakVec(),
            createdAt: DateTime.now().toUtc().subtract(const Duration(days: 3)),
          ),
        );
        final prompts = <String>[];
        final turn = await answer(
          fakeGemini(
            reading(
              symptoms: [
                {'symptom': 'weakness', 'severity': 3},
              ],
              followup: true,
            ),
            prompts,
          ),
          'आज फिर कमजोरी लग रही है',
        );

        expect(
          prompts.single,
          contains('3 days ago: Patient reported weakness, mild'),
        );
        expect(turn.done, isFalse);
        expect(turn.turnIndex, 1);
        expect(turn.text, contains('कमजोरी'));

        final saved = await WellnessCheck.db.findById(session, check.id!);
        expect(saved!.status, CheckStatus.active);
        expect(saved.memoryUsed, [
          'Patient reported weakness, mild, in the evening.',
        ]);
        expect(
          await SymptomReport.db.count(
            session,
            where: (t) => t.checkId.equals(check.id!),
          ),
          1,
        );
        expect(
          await PatientMemory.db.count(
            session,
            where: (t) => t.sourceCheckId.equals(check.id!),
          ),
          1,
        );
      },
    );

    test(
      'an emergency phrase alerts the caregiver even if the model misses it',
      () async {
        final turn = await answer(
          fakeGemini(reading(), []),
          'मुझे सीने में दर्द हो रहा है',
        );

        expect(turn.done, isTrue);
        expect(turn.text, startsWith(caregiverInformedHi));
        expect(
          await Alert.db.count(
            session,
            where: (t) =>
                t.patientId.equals(patient.id!) &
                t.kind.equals(AlertKind.severeSymptom),
          ),
          1,
        );
      },
    );

    test('a Gemini outage still closes the call politely', () async {
      final turn = await answer(fakeGemini(null, []), 'ठीक हूँ');
      expect(turn.done, isTrue);
      expect(turn.text, closingHi('Ramesh'));
      expect(
        (await WellnessCheck.db.findById(session, check.id!))!.status,
        CheckStatus.completed,
      );
    });

    test('silence asks again without using up a turn', () async {
      final turn = await answer(fakeGemini(reading(), []), '');
      expect(turn.text, sayAgainHi);
      expect(
        (await WellnessCheck.db.findById(session, check.id!))!.turnCount,
        0,
      );
    });

    test(
      'weekly insight: adherence, review flag and template summary',
      () async {
        final now = DateTime.now().toUtc();
        for (final (i, status) in [
          DoseStatus.taken,
          DoseStatus.taken,
          DoseStatus.missed,
          DoseStatus.missed,
        ].indexed) {
          await DoseEvent.db.insertRow(
            session,
            DoseEvent(
              patientId: patient.id!,
              medicationId: 900 + i,
              scheduledAt: now.subtract(Duration(hours: 2 + i)),
              status: status,
            ),
          );
        }
        final insight = await weekInsight(session, patient);
        expect(insight.adherencePct, 50);
        expect(insight.prevAdherencePct, isNull);
        expect(insight.reviewRecommended, isTrue);
        expect(
          insight.aiSummary,
          startsWith('2 of 4 doses were taken this week (adherence 50%)'),
        );
      },
    );
  });
}
