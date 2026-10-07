import 'dart:convert';

import 'package:dhatri_server/src/generated/protocol.dart';
import 'package:dhatri_server/src/services/gemini.dart';
import 'package:dhatri_server/src/services/insight_service.dart';
import 'package:dhatri_server/src/services/safety_rules.dart';
import 'package:dhatri_server/src/services/sarvam.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';

http.Response geminiJson(Object json) => http.Response(
  jsonEncode({
    'candidates': [
      {
        'content': {
          'parts': [
            {'text': 'thinking...', 'thought': true},
            {'text': jsonEncode(json)},
          ],
        },
      },
    ],
  }),
  200,
);

void main() {
  group('parseDrafts', () {
    test('keeps valid rows and flags guesses for the caregiver', () {
      final drafts = parseDrafts(
        jsonEncode({
          'unreadable': false,
          'medications': [
            {
              'name': 'Metformin',
              'strength': '500 mg',
              'doseText': '1 tablet',
              'instructions': 'After food',
              'times': ['20:00', '08:00'],
              'durationDays': 30,
              'uncertain': false,
            },
            {
              'name': 'Amlodipine',
              'doseText': '1 tablet',
              'times': ['8 am'],
              'durationDays': 90,
              'uncertain': false,
            },
          ],
        }),
      );
      expect(drafts[0].times, ['08:00', '20:00']);
      expect(drafts[0].uncertain, isFalse);
      expect(drafts[1].times, isEmpty);
      expect(drafts[1].durationDays, 30);
      expect(drafts[1].uncertain, isTrue);
    });

    test('null JSON gives no drafts', () => expect(parseDrafts(null), isEmpty));
  });

  test('scanEmergency catches Hindi, Hinglish and English phrases', () {
    expect(scanEmergency('कल रात सीने में दर्द हुआ'), isNotEmpty);
    expect(scanEmergency('Saans lene mein dikkat hai'), isNotEmpty);
    expect(scanEmergency('I fell in the bathroom'), isNotEmpty);
    expect(scanEmergency('थोड़ी कमजोरी है बस'), isEmpty);
  });

  test('CheckInReading drops unknown symptoms and clamps severity', () {
    final r = CheckInReading.fromJson({
      'mood': 'low',
      'symptoms': [
        {'symptom': 'weakness', 'severity': 9},
        {'symptom': 'cancer', 'severity': 2},
      ],
      'observationsEn': ['Weak.', ' '],
      'summaryEn': 's',
      'replyHi': 'r',
      'needsFollowup': true,
    });
    expect(r.symptoms, [(symptom: 'weakness', severity: 5)]);
    expect(r.observationsEn, ['Weak.']);
  });

  test('templateSummary states only the numbers', () {
    final text = templateSummary(
      PatientInsight(
        patient: Profile(name: 'Ramesh', role: Role.patient),
        adherencePct: 86,
        prevAdherencePct: 92,
        dosesTaken: 12,
        dosesMissed: 2,
        checkIns: 4,
        symptoms: [SymptomCount(symptom: 'weakness', count: 3, maxSeverity: 3)],
        openAlerts: [],
        reviewRecommended: true,
        aiSummary: '',
        generatedAt: DateTime.now(),
      ),
    );
    expect(
      text,
      '12 of 14 doses were taken this week (adherence 86%, previous week 92%). '
      'Weakness was reported 3 times across 4 completed check-ins.',
    );
  });

  test('istDayStartUtc is 18:30 UTC the previous day', () {
    expect(
      istDayStartUtc(DateTime.utc(2026, 10, 7, 20)),
      DateTime.utc(2026, 10, 7, 18, 30),
    );
    expect(
      istDayStartUtc(DateTime.utc(2026, 10, 7, 10)),
      DateTime.utc(2026, 10, 6, 18, 30),
    );
  });

  group('Gemini', () {
    test(
      'extraction sends the image with a JSON schema and skips thought parts',
      () async {
        late Map<String, dynamic> sent;
        final gemini = Gemini(
          'key',
          client: MockClient((req) async {
            expect(req.headers['x-goog-api-key'], 'key');
            expect(req.url.path, endsWith(':generateContent'));
            sent = jsonDecode(req.body) as Map<String, dynamic>;
            return geminiJson({'unreadable': true, 'medications': []});
          }),
        );
        final json = await gemini.extractPrescription(
          utf8.encode('img'),
          'image/jpeg',
        );
        expect(jsonDecode(json), {'unreadable': true, 'medications': []});
        expect(
          sent['contents'][0]['parts'][0]['inlineData']['mimeType'],
          'image/jpeg',
        );
        expect(sent['generationConfig']['responseSchema'], isNotNull);
      },
    );

    test('embed rejects a wrong dimension', () async {
      final gemini = Gemini(
        'key',
        client: MockClient((req) async {
          expect(jsonDecode(req.body)['taskType'], 'RETRIEVAL_QUERY');
          return http.Response(
            jsonEncode({
              'embedding': {
                'values': [0.1, 0.2],
              },
            }),
            200,
          );
        }),
      );
      expect(gemini.embed('x', query: true), throwsA(isA<GeminiException>()));
    });

    test('HTTP errors surface as GeminiException', () async {
      final gemini = Gemini(
        'key',
        client: MockClient((_) async => http.Response('quota', 429)),
      );
      expect(gemini.embed('x'), throwsA(isA<GeminiException>()));
    });
  });

  group('Sarvam', () {
    test('speak decodes base64 WAV and caches by text', () async {
      var calls = 0;
      final sarvam = SarvamVoice(
        'key',
        client: MockClient((req) async {
          calls++;
          final body = jsonDecode(req.body);
          expect(body['language_code'], 'hi-IN');
          expect(req.headers['api-subscription-key'], 'key');
          return http.Response(
            jsonEncode({
              'audios': [
                base64Encode([1, 2, 3]),
              ],
            }),
            200,
          );
        }),
      );
      final text = 'नमस्ते ${DateTime.now().microsecondsSinceEpoch}';
      expect((await sarvam.speak(text)).lengthInBytes, 3);
      await sarvam.speak(text);
      expect(calls, 1);
    });

    test('transcribe posts multipart Hindi and trims', () async {
      final sarvam = SarvamVoice(
        'key',
        client: MockClient((req) async {
          expect(
            req.headers['content-type'],
            startsWith('multipart/form-data'),
          );
          expect(req.body, contains('hi-IN'));
          return http.Response.bytes(
            utf8.encode(jsonEncode({'transcript': '  कमजोरी है  '})),
            200,
          );
        }),
      );
      expect(await sarvam.transcribe(utf8.encode('aac')), 'कमजोरी है');
    });
  });
}
