import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/access.dart';
import '../services/care_bus.dart';

class AlertEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<Alert> acknowledge(Session session, int alertId) async {
    final alert = await Alert.db.findById(session, alertId);
    if (alert == null) {
      throw ArgumentError('Alert not found');
    }
    await requireAccess(session, alert.patientId, write: true);
    final updated = await Alert.db.updateRow(
      session,
      alert.copyWith(acknowledgedAt: DateTime.now().toUtc()),
    );
    await postUpdate(
      session,
      alert.patientId,
      CareUpdate(patientId: alert.patientId, alert: updated),
    );
    return updated;
  }

  Future<Alert> needHelp(Session session, int patientId) async {
    await requireAccess(session, patientId, write: true);
    final patient = await Profile.db.findById(session, patientId);
    final alert = await Alert.db.insertRow(
      session,
      Alert(
        patientId: patientId,
        kind: AlertKind.patientHelp,
        priority: AlertPriority.high,
        message: '${patient?.name ?? 'Patient'} requested help from the app',
      ),
    );
    await postUpdate(
      session,
      patientId,
      CareUpdate(patientId: patientId, alert: alert),
    );
    return alert;
  }
}
