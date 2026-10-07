// Live checks against Gemini and Sarvam, no database needed (spike S6).
//
//   export GEMINI_API_KEY=... SARVAM_API_KEY=...
//   dart run bin/ai_smoke.dart extract samples/*.jpg   # prescription photos
//   dart run bin/ai_smoke.dart voice                    # TTS -> STT round trip
//   dart run bin/ai_smoke.dart checkin "आज फिर कमजोरी लग रही है"
//   dart run bin/ai_smoke.dart embed
//   dart run bin/ai_smoke.dart gate [samples-dir]   # Wed gate: pass 4/5
// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dhatri_server/src/generated/protocol.dart';
import 'package:dhatri_server/src/services/copy_hi.dart';
import 'package:dhatri_server/src/services/gemini.dart';
import 'package:dhatri_server/src/services/safety_rules.dart';
import 'package:dhatri_server/src/services/sarvam.dart';

Future<void> main(List<String> args) async {
  final env = Platform.environment;
  final gemini = Gemini(env['GEMINI_API_KEY'] ?? '');
  final sarvam = SarvamVoice(env['SARVAM_API_KEY'] ?? '');
  final watch = Stopwatch()..start();

  switch (args.firstOrNull) {
    case 'extract':
      for (final path in args.skip(1)) {
        final ext = path.split('.').last.toLowerCase();
        final json = await gemini.extractPrescription(
          File(path).readAsBytesSync(),
          ext == 'png' ? 'image/png' : 'image/jpeg',
        );
        print('== $path (${watch.elapsedMilliseconds} ms)');
        print('unreadable: ${(jsonDecode(json) as Map)['unreadable']}');
        for (final d in parseDrafts(json)) {
          print(
            '  ${d.uncertain ? '?' : ' '} ${d.name} ${d.strength ?? ''} · '
            '${d.doseText} · ${d.times.join(', ')} · ${d.durationDays} d · ${d.instructions ?? ''}',
          );
        }
        watch.reset();
      }
    case 'voice':
      final wav = await sarvam.speak(greetingHi('रमेश'));
      File('greeting.wav').writeAsBytesSync(wav.buffer.asUint8List());
      print(
        'speak: ${wav.lengthInBytes} bytes -> greeting.wav (${watch.elapsedMilliseconds} ms)',
      );
      watch.reset();
      final text = await sarvam.transcribe(wav.buffer.asUint8List());
      print('transcribe: "$text" (${watch.elapsedMilliseconds} ms)');
    case 'checkin':
      final transcript = args.skip(1).join(' ');
      final reading = await gemini.interpretCheckIn(
        CheckInPacket(
          patientName: 'Ramesh',
          transcript: transcript,
          symptomsLast7Days: [
            SymptomCount(symptom: 'weakness', count: 2, maxSeverity: 2),
          ],
          dosesToday: (taken: 1, missed: 0),
          dosesWeek: (taken: 12, missed: 2),
          memories: [
            '3 days ago: Patient reported weakness, mild, in the evening.',
          ],
          emergencyPhrases: scanEmergency(transcript),
          isLastTurn: false,
        ),
      );
      print(
        const JsonEncoder.withIndent('  ').convert({
          'mood': reading.mood,
          'symptoms': [
            for (final s in reading.symptoms) '${s.symptom}:${s.severity}',
          ],
          'observationsEn': reading.observationsEn,
          'summaryEn': reading.summaryEn,
          'replyHi': reading.replyHi,
          'needsFollowup': reading.needsFollowup,
          'ms': watch.elapsedMilliseconds,
        }),
      );
    case 'embed':
      final a = await gemini.embed('Patient reported weakness in the evening.');
      final b = await gemini.embed('मुझे आज फिर कमजोरी लग रही है', query: true);
      final c = await gemini.embed('Patient enjoyed a walk in the park.');
      print('dims: ${a.length} (${gemini.embedModel})');
      print(
        'weakness vs Hindi weakness query: ${_cos(a, b).toStringAsFixed(3)} distance',
      );
      print(
        'walk note vs Hindi weakness query: ${_cos(c, b).toStringAsFixed(3)} distance',
      );
    case 'gate':
      final dir = args.skip(1).firstOrNull ?? 'samples';
      final ok = await _extractionGate(gemini, dir);
      exit(ok ? 0 : 1);
    default:
      print(
        'usage: dart run bin/ai_smoke.dart extract <images...> | voice | checkin <hindi text> | embed | gate [dir]',
      );
      exit(64);
  }
  exit(0);
}

Future<bool> _extractionGate(Gemini gemini, String dirPath) async {
  final specFile = File('$dirPath/expected.json');
  if (!specFile.existsSync()) {
    print('missing $dirPath/expected.json');
    return false;
  }
  final spec = jsonDecode(specFile.readAsStringSync()) as Map<String, dynamic>;
  var passed = 0;
  final total = spec.length;
  for (final entry in spec.entries) {
    final fileName = entry.key;
    final rules = entry.value as Map<String, dynamic>;
    final path = '$dirPath/$fileName';
    if (!File(path).existsSync()) {
      print('FAIL $fileName (file missing)');
      continue;
    }
    final ext = fileName.split('.').last.toLowerCase();
    try {
      final json = await gemini.extractPrescription(
        File(path).readAsBytesSync(),
        ext == 'png' ? 'image/png' : 'image/jpeg',
      );
      final root = jsonDecode(json) as Map<String, dynamic>;
      if (root['unreadable'] == true) {
        print('FAIL $fileName (unreadable)');
        continue;
      }
      final drafts = parseDrafts(json);
      final names = drafts.map((d) => d.name.toLowerCase()).join(' ');
      final must = [
        for (final m in (rules['mustInclude'] as List? ?? const [])) '$m'.toLowerCase(),
      ];
      final minMeds = (rules['minMedications'] as num?)?.toInt() ?? must.length;
      final missing = must.where((m) => !names.contains(m)).toList();
      if (drafts.length < minMeds || missing.isNotEmpty) {
        print(
          'FAIL $fileName (drafts=${drafts.length}, missing=$missing, names=$names)',
        );
        continue;
      }
      passed++;
      print('PASS $fileName');
    } on GeminiException catch (e) {
      print('FAIL $fileName ($e)');
    }
  }
  print('Gate: $passed / $total (need ${(total * 0.8).ceil()}+)');
  return passed >= (total * 0.8).ceil();
}

double _cos(List<double> a, List<double> b) {
  var dot = 0.0, na = 0.0, nb = 0.0;
  for (var i = 0; i < a.length; i++) {
    dot += a[i] * b[i];
    na += a[i] * a[i];
    nb += b[i] * b[i];
  }
  return 1 - dot / (sqrt(na) * sqrt(nb));
}
