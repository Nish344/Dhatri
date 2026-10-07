import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class CheckInEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<void> startNow(Session session, int patientId) async =>
      throw UnimplementedError();

  Future<WellnessCheck?> pending(Session session, int patientId) async =>
      throw UnimplementedError();

  Future<CheckInTurn> accept(Session session, int checkId) async =>
      throw UnimplementedError();

  Future<void> snooze(Session session, int checkId) async =>
      throw UnimplementedError();

  Future<CheckInTurn> answer(
    Session session,
    int checkId,
    ByteData audio,
  ) async =>
      throw UnimplementedError();
}
