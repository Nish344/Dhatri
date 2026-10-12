import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/check_in_open.dart';

class CheckInFutureCall extends FutureCall {
  Future<void> open(
    Session session,
    int patientId,
    CheckTrigger trigger,
  ) {
    session.log(
      'futureCall.checkIn.open patient=$patientId trigger=${trigger.name}',
    );
    return openCheckIn(session, patientId, trigger: trigger);
  }

  Future<void> ring(Session session, int checkId) {
    session.log('futureCall.checkIn.ring id=$checkId');
    return ringCheckIn(session, checkId);
  }
}
