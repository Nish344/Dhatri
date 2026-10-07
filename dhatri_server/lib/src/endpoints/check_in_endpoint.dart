import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/access.dart';
import '../services/check_in_service.dart';
import '../services/gemini.dart';
import '../services/memory_service.dart';
import '../services/sarvam.dart';

class CheckInEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<void> startNow(Session session, int patientId) async =>
      throw UnimplementedError();

  Future<WellnessCheck?> pending(Session session, int patientId) async {
    await requireAccess(session, patientId, write: false);
    return WellnessCheck.db.findFirstRow(
      session,
      where: (t) =>
          t.patientId.equals(patientId) &
          t.status.inSet({CheckStatus.pending, CheckStatus.snoozed}),
      orderBy: (t) => t.createdAt.desc(),
    );
  }

  Future<CheckInTurn> accept(Session session, int checkId) async {
    final check = await _check(session, checkId);
    return acceptCheckIn(session, check, SarvamVoice.of(session));
  }

  Future<void> snooze(Session session, int checkId) async =>
      throw UnimplementedError();

  Future<CheckInTurn> answer(
    Session session,
    int checkId,
    ByteData audio,
  ) async {
    final check = await _check(session, checkId);
    final gemini = Gemini.of(session);
    return answerCheckIn(
      session,
      check,
      audio.buffer.asUint8List(audio.offsetInBytes, audio.lengthInBytes),
      gemini: gemini,
      voice: SarvamVoice.of(session),
      memory: memoryServiceFor(gemini),
    );
  }

  Future<WellnessCheck> _check(Session session, int checkId) async {
    final check = await WellnessCheck.db.findById(session, checkId);
    if (check == null) throw ArgumentError('Check-in not found');
    await requireAccess(session, check.patientId, write: true);
    return check;
  }
}
