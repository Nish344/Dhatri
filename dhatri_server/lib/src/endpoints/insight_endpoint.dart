import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/access.dart';
import '../services/gemini.dart';
import '../services/insight_service.dart';

class InsightEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<PatientInsight> week(Session session, int patientId) async {
    await requireAccess(session, patientId, write: false);
    final patient = await Profile.db.findById(session, patientId);
    Gemini? gemini;
    try {
      gemini = Gemini.of(session);
    } on StateError {
      // No key configured: the template summary still works.
    }
    return weekInsight(session, patient!, gemini: gemini);
  }

  Future<List<TimelineItem>> timeline(
    Session session,
    int patientId,
    int days,
  ) async => throw UnimplementedError();
}
