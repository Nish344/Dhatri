import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

const symptomNames = [
  'weakness', 'dizziness', 'fever', 'pain', 'nausea', 'breathlessness', //
  'sleep', 'appetite', 'other',
];

class GeminiException implements Exception {
  GeminiException(this.message);
  final String message;
  @override
  String toString() => 'GeminiException: $message';
}

/// What Gemini understood from one patient answer.
class CheckInReading {
  CheckInReading({
    required this.mood,
    required this.symptoms,
    required this.observationsEn,
    required this.summaryEn,
    required this.replyHi,
    required this.needsFollowup,
  });

  factory CheckInReading.fromJson(Map<String, dynamic> j) => CheckInReading(
    mood: j['mood'] as String?,
    symptoms: [
      for (final s in (j['symptoms'] as List? ?? const []))
        if (symptomNames.contains(s['symptom']))
          (
            symptom: s['symptom'] as String,
            severity: ((s['severity'] as num?)?.toInt() ?? 1).clamp(1, 5),
          ),
    ],
    observationsEn: [
      for (final o in (j['observationsEn'] as List? ?? const []))
        if ((o as String).trim().isNotEmpty) o.trim(),
    ],
    summaryEn: j['summaryEn'] as String? ?? '',
    replyHi: j['replyHi'] as String? ?? '',
    needsFollowup: j['needsFollowup'] as bool? ?? false,
  );

  final String? mood;
  final List<({String symptom, int severity})> symptoms;
  final List<String> observationsEn;
  final String summaryEn;
  final String replyHi;
  final bool needsFollowup;
}

/// The Patient Memory context packet sent with each answer (ARCHITECTURE §7).
class CheckInPacket {
  CheckInPacket({
    required this.patientName,
    required this.transcript,
    required this.symptomsLast7Days,
    required this.dosesToday,
    required this.dosesWeek,
    required this.memories,
    required this.emergencyPhrases,
    required this.isLastTurn,
  });

  final String patientName;
  final String transcript;
  final List<SymptomCount> symptomsLast7Days;
  final ({int taken, int missed}) dosesToday;
  final ({int taken, int missed}) dosesWeek;

  /// Earlier observations with their dates, e.g. "4 Oct: Patient reported weakness".
  final List<String> memories;
  final List<String> emergencyPhrases;
  final bool isLastTurn;

  String toPrompt() => [
    'Patient name: $patientName',
    'Patient just said (Hindi transcript): "$transcript"',
    'Symptoms reported in the last 7 days: ${symptomsLast7Days.isEmpty ? 'none' : symptomsLast7Days.map((s) => '${s.symptom} ${s.count}x (max severity ${s.maxSeverity})').join(', ')}',
    'Doses today: ${dosesToday.taken} taken, ${dosesToday.missed} missed. This week: ${dosesWeek.taken} taken, ${dosesWeek.missed} missed.',
    'Remembered from earlier check-ins: ${memories.isEmpty ? 'nothing' : memories.join(' | ')}',
    if (emergencyPhrases.isNotEmpty)
      'Emergency words detected: ${emergencyPhrases.join(', ')}. The caregiver is being informed.',
    isLastTurn
        ? 'This is the last turn: set needsFollowup to false.'
        : 'You may ask one follow-up question if something needs clarifying.',
  ].join('\n');
}

class Gemini {
  Gemini(this._apiKey, {http.Client? client}) : _http = client ?? http.Client();

  factory Gemini.of(Session session) {
    final key = session.serverpod.getPassword('geminiApiKey');
    if (key == null || key.isEmpty) {
      throw StateError('geminiApiKey is missing from config/passwords.yaml');
    }
    return Gemini(key);
  }

  final String _apiKey;
  final http.Client _http;

  static final _env = Platform.environment;
  final model = _env['GEMINI_MODEL'] ?? 'gemini-3.5-flash';
  final embedModel = _env['GEMINI_EMBED_MODEL'] ?? 'gemini-embedding-001';
  final embedDim = int.parse(_env['GEMINI_EMBED_DIM'] ?? '768');

  static const _base =
      'https://generativelanguage.googleapis.com/v1beta/models';

  /// Returns the extraction as a JSON string, stored as-is in
  /// `Prescription.extractedJson` and read back by [parseDrafts].
  Future<String> extractPrescription(Uint8List image, String mimeType) async {
    final json = await _generateJson(
      system: _extractionRules,
      parts: [
        {
          'inlineData': {'mimeType': mimeType, 'data': base64Encode(image)},
        },
        {'text': 'List the medicines on this prescription.'},
      ],
      schema: _extractionSchema,
    );
    return jsonEncode(json);
  }

  Future<List<double>> embed(String text, {bool query = false}) async {
    final body = await _post('$embedModel:embedContent', {
      'content': {
        'parts': [
          {'text': text},
        ],
      },
      'taskType': query ? 'RETRIEVAL_QUERY' : 'RETRIEVAL_DOCUMENT',
      'outputDimensionality': embedDim,
    });
    final values = [
      for (final v in body['embedding']['values'] as List)
        (v as num).toDouble(),
    ];
    if (values.length != embedDim) {
      throw GeminiException(
        'embedding has ${values.length} dims, expected $embedDim',
      );
    }
    return values;
  }

  Future<CheckInReading> interpretCheckIn(CheckInPacket packet) async =>
      CheckInReading.fromJson(
        await _generateJson(
          system: _checkInRules,
          parts: [
            {'text': packet.toPrompt()},
          ],
          schema: _checkInSchema,
        ),
      );

  Future<String> summarizeWeek(PatientInsight facts) async {
    final json = await _generateJson(
      system: _summaryRules,
      parts: [
        {
          'text': jsonEncode({
            'patientName': facts.patient.name,
            'adherencePct': facts.adherencePct,
            'previousWeekAdherencePct': facts.prevAdherencePct,
            'dosesTaken': facts.dosesTaken,
            'dosesMissed': facts.dosesMissed,
            'checkInsCompleted': facts.checkIns,
            'symptoms': [
              for (final s in facts.symptoms)
                {
                  'symptom': s.symptom,
                  'count': s.count,
                  'maxSeverity': s.maxSeverity,
                },
            ],
            'openAlerts': [for (final a in facts.openAlerts) a.message],
          }),
        },
      ],
      schema: {
        'type': 'OBJECT',
        'properties': {
          'summary': {'type': 'STRING'},
        },
        'required': ['summary'],
      },
    );
    return (json['summary'] as String).trim();
  }

  Future<Map<String, dynamic>> _generateJson({
    required String system,
    required List<Map<String, dynamic>> parts,
    required Map<String, dynamic> schema,
  }) async {
    final body = await _post('$model:generateContent', {
      'systemInstruction': {
        'parts': [
          {'text': system},
        ],
      },
      'contents': [
        {'role': 'user', 'parts': parts},
      ],
      'generationConfig': {
        'temperature': 0.2,
        'responseMimeType': 'application/json',
        'responseSchema': schema,
      },
    });
    final candidates = body['candidates'] as List?;
    if (candidates == null || candidates.isEmpty) {
      throw GeminiException('no candidates: ${body['promptFeedback'] ?? body}');
    }
    final text = [
      for (final p
          in (candidates.first['content']?['parts'] as List? ?? const []))
        if (p['thought'] != true && p['text'] != null) p['text'] as String,
    ].join();
    try {
      return jsonDecode(text) as Map<String, dynamic>;
    } on FormatException {
      throw GeminiException('model did not return JSON: $text');
    }
  }

  Future<Map<String, dynamic>> _post(
    String path,
    Map<String, dynamic> body,
  ) async {
    final response = await _http
        .post(
          Uri.parse('$_base/$path'),
          headers: {
            'x-goog-api-key': _apiKey,
            'Content-Type': 'application/json',
          },
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 45));
    if (response.statusCode != 200) {
      throw GeminiException('HTTP ${response.statusCode}: ${response.body}');
    }
    return jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
  }
}

/// Parses `Prescription.extractedJson`. Times that are not valid HH:MM are
/// dropped and the row is flagged so the caregiver checks it.
List<MedicationDraft> parseDrafts(String? extractedJson) {
  if (extractedJson == null) return [];
  final json = jsonDecode(extractedJson) as Map<String, dynamic>;
  final timePattern = RegExp(r'^([01]\d|2[0-3]):[0-5]\d$');
  return [
    for (final m in (json['medications'] as List? ?? const []))
      () {
        final rawTimes = [
          for (final t in (m['times'] as List? ?? const [])) '$t',
        ];
        final times = rawTimes.where(timePattern.hasMatch).toSet().toList()
          ..sort();
        final days = (m['durationDays'] as num?)?.toInt();
        return MedicationDraft(
          name: (m['name'] as String? ?? '').trim(),
          strength: m['strength'] as String?,
          doseText: m['doseText'] as String? ?? '',
          instructions: m['instructions'] as String?,
          times: times,
          durationDays: (days ?? 30).clamp(1, 30),
          uncertain:
              m['uncertain'] == true ||
              times.isEmpty ||
              times.length != rawTimes.length ||
              days == null ||
              days < 1 ||
              days > 30,
        );
      }(),
  ];
}

const _extractionRules = '''
You read a photo of an Indian doctor's prescription and list the medicines a caregiver must schedule. A caregiver reviews everything you return before anything is scheduled, so mark doubt honestly instead of guessing silently.

Rules:
- One entry per medicine actually written on the paper. Never invent a medicine. Ignore diagnoses, tests, advice, the doctor's details and the letterhead.
- name: the brand or generic name as written, corrected only for obvious spelling.
- strength: e.g. "500 mg", "10 ml", or null if not written.
- doseText: amount per dose, e.g. "1 tablet", "1/2 tablet", "5 ml", "2 puffs".
- instructions: food timing and other notes, e.g. "After food", "Before breakfast", or null.
- times: 24-hour "HH:MM" in Indian time. Frequency mapping:
  OD / once daily / 1-0-0 -> ["08:00"]; 0-1-0 -> ["14:00"]; 0-0-1 -> ["20:00"]
  BD / BID / twice daily / 1-0-1 -> ["08:00","20:00"]
  TDS / TID / thrice daily / 1-1-1 -> ["08:00","14:00","20:00"]
  QID / four times daily -> ["08:00","12:00","16:00","20:00"]
  HS / at bedtime -> ["22:00"]
  SOS / PRN / as needed -> [] and uncertain true.
  Before food (AC) or after food (PC) goes into instructions, never changes the times.
- durationDays: "x 5 days" -> 5, "x 2 weeks" -> 14, "x 1 month" -> 30. Use at most 30. If no duration is written, use 30 and set uncertain true.
- uncertain: true when you are guessing any part of the name, dose, frequency or duration, including unclear handwriting or an unknown abbreviation.
- unreadable: true with an empty medications list if the image is not a prescription or cannot be read at all.
''';

const _extractionSchema = {
  'type': 'OBJECT',
  'properties': {
    'unreadable': {'type': 'BOOLEAN'},
    'medications': {
      'type': 'ARRAY',
      'items': {
        'type': 'OBJECT',
        'properties': {
          'name': {'type': 'STRING'},
          'strength': {'type': 'STRING', 'nullable': true},
          'doseText': {'type': 'STRING'},
          'instructions': {'type': 'STRING', 'nullable': true},
          'times': {
            'type': 'ARRAY',
            'items': {'type': 'STRING'},
          },
          'durationDays': {'type': 'INTEGER'},
          'uncertain': {'type': 'BOOLEAN'},
        },
        'required': ['name', 'doseText', 'times', 'durationDays', 'uncertain'],
      },
    },
  },
  'required': ['unreadable', 'medications'],
};

const _checkInRules = '''
You are Dhatri, a gentle Hindi voice companion that checks on an elderly patient each evening. You are not a doctor.

Read what the patient said and return JSON:
- mood: "good", "okay" or "low".
- symptoms: every symptom the patient mentions, using only the listed names. severity 1 (mild) to 5 (severe), judged from the patient's words. Empty if none.
- observationsEn: one short factual English sentence per symptom or notable statement, e.g. "Patient reported weakness, moderate, in the evening." Facts only.
- summaryEn: one short English sentence for the caregiver.
- replyHi: what you say next, in Hindi (Devanagari), at most two short sentences, simple everyday words, addressing the patient as "<name> जी".
- needsFollowup: true only if one more question would genuinely help (for example, a symptom is new or worse).

Strict rules for replyHi:
- Never diagnose, never name a disease, never suggest or change a medicine or dose, never reassure that a symptom is fine or normal.
- If any symptom has severity 4 or more, or emergency words were detected, say that you are informing their family now.
- Refer to earlier symptoms only when they appear under "Remembered from earlier check-ins", and say when (for example "कुछ दिन पहले").
- If needsFollowup is true, ask exactly one simple question. Otherwise thank them warmly.
''';

const _checkInSchema = {
  'type': 'OBJECT',
  'properties': {
    'mood': {
      'type': 'STRING',
      'enum': ['good', 'okay', 'low'],
    },
    'symptoms': {
      'type': 'ARRAY',
      'items': {
        'type': 'OBJECT',
        'properties': {
          'symptom': {'type': 'STRING', 'enum': symptomNames},
          'severity': {'type': 'INTEGER'},
        },
        'required': ['symptom', 'severity'],
      },
    },
    'observationsEn': {
      'type': 'ARRAY',
      'items': {'type': 'STRING'},
    },
    'summaryEn': {'type': 'STRING'},
    'replyHi': {'type': 'STRING'},
    'needsFollowup': {'type': 'BOOLEAN'},
  },
  'required': [
    'mood',
    'symptoms',
    'observationsEn',
    'summaryEn',
    'replyHi',
    'needsFollowup',
  ],
};

const _summaryRules = '''
Write a 2-3 sentence factual weekly summary for a caregiver and doctor, in plain English, from the JSON numbers given.
- Use only the numbers supplied. Do not add causes, diagnoses, advice or reassurance.
- Mention adherence and how it changed from last week when both are present, missed doses, repeated or severe symptoms, and open alerts.
- If a number is null, say it is not available yet rather than guessing.
Example: "Weakness was reported in 3 of 4 check-ins this week. Two doses were missed. Adherence is 86%, down from 92%."
''';
