import 'package:serverpod/serverpod.dart';

import '../services/dose_escalation.dart';
import '../services/dose_reminder.dart';

class DoseFutureCall extends FutureCall {
  Future<void> remind(Session session, int doseEventId) {
    session.log('futureCall.dose.remind id=$doseEventId');
    return remindDose(session, doseEventId);
  }

  Future<void> escalate(Session session, int doseEventId) {
    session.log('futureCall.dose.escalate id=$doseEventId');
    return escalateMissedDose(session, doseEventId);
  }
}
