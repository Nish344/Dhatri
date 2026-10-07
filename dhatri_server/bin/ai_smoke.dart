// Live checks against Gemini and Sarvam, no database needed (spike S6).
//
//   export GEMINI_API_KEY=... SARVAM_API_KEY=...
//   dart run bin/ai_smoke.dart extract samples/*.jpg   # prescription photos
//   dart run bin/ai_smoke.dart voice                    # TTS -> STT round trip
//   dart run bin/ai_smoke.dart checkin "आज फिर कमजोरी लग रही है"
//   dart run bin/ai_smoke.dart embed
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
    default:
      print(
        'usage: dart run bin/ai_smoke.dart extract <images...> | voice | checkin <hindi text> | embed',
      );
      exit(64);
  }
  exit(0);
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
