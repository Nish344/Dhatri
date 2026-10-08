import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/check_in_open.dart';

class CheckInFutureCall extends FutureCall {
  Future<void> open(
    Session session,
    int patientId,
    CheckTrigger trigger,
  ) => openCheckIn(session, patientId, trigger: trigger);

  Future<void> ring(Session session, int checkId) =>
      ringCheckIn(session, checkId);
}
