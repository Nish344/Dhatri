import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/access.dart';

class AlertEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<Alert> acknowledge(Session session, int alertId) async {
    final alert = await Alert.db.findById(session, alertId);
    if (alert == null) {
      throw ArgumentError('Alert not found');
    }
    await requireAccess(session, alert.patientId, write: true);
    throw UnimplementedError();
  }

  Future<Alert> needHelp(Session session, int patientId) async {
    await requireAccess(session, patientId, write: true);
    throw UnimplementedError();
  }
}
