import 'package:serverpod/serverpod.dart';

import '../services/dose_escalation.dart';
import '../services/dose_reminder.dart';

class DoseFutureCall extends FutureCall {
  Future<void> remind(Session session, int doseEventId) =>
      remindDose(session, doseEventId);

  Future<void> escalate(Session session, int doseEventId) =>
      escalateMissedDose(session, doseEventId);
}
