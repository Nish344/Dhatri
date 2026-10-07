import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/access.dart';
import '../services/dose_escalation.dart';
import '../services/insight_service.dart';

class DoseEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<List<DoseEvent>> today(Session session, int patientId) async {
    await requireAccess(session, patientId, write: false);
    final start = istDayStartUtc();
    final end = start.add(const Duration(days: 1));
    return DoseEvent.db.find(
      session,
      where: (t) =>
          t.patientId.equals(patientId) &
          (t.scheduledAt >= start) &
          (t.scheduledAt < end),
      orderBy: (t) => t.scheduledAt,
    );
  }

  Future<DoseEvent> markTaken(Session session, int doseEventId) async {
    final event = await DoseEvent.db.findById(session, doseEventId);
    if (event == null) {
      throw ArgumentError('Dose not found');
    }
    await requireAccess(session, event.patientId, write: true);
    final updated = await markDoseTaken(session, doseEventId);
    if (updated == null) {
      throw StateError('Dose not found');
    }
    return updated;
  }
}
