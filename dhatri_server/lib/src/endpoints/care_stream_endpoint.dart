import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/access.dart';

class CareStreamEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Stream<CareUpdate> watch(Session session, int patientId) async* {
    await requireAccess(session, patientId, write: false);
    yield* session.messages.createStream<CareUpdate>('patient_$patientId');
  }
}
