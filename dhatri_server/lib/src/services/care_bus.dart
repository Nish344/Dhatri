import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

Future<void> postUpdate(Session session, int patientId, CareUpdate update) =>
    session.messages.postMessage('patient_$patientId', update);
