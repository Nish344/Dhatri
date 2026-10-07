import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class InsightEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<PatientInsight> week(Session session, int patientId) async =>
      throw UnimplementedError();

  Future<List<TimelineItem>> timeline(
    Session session,
    int patientId,
    int days,
  ) async =>
      throw UnimplementedError();
}
