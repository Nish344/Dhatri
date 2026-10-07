import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'care_bus.dart';

typedef SymptomInput = ({String symptom, int severity});

/// Inserts symptom rows and applies repeat / severity alert rules.
Future<void> applySymptomRules(
  Session session,
  int patientId,
  int checkId,
  List<SymptomInput> symptoms,
) async {
  final now = DateTime.now().toUtc();
  for (final s in symptoms) {
    await SymptomReport.db.insertRow(
      session,
      SymptomReport(
        patientId: patientId,
        checkId: checkId,
        symptom: s.symptom,
        severity: s.severity,
        reportedAt: now,
      ),
    );

    final count = await SymptomReport.db.count(
      session,
      where: (t) =>
          t.patientId.equals(patientId) &
          t.symptom.equals(s.symptom) &
          (t.reportedAt > now.subtract(const Duration(days: 7))),
    );

    if (count >= 3) {
      final repeatedAlerts = await Alert.db.find(
        session,
        where: (t) =>
            t.patientId.equals(patientId) &
            t.kind.equals(AlertKind.repeatedSymptom) &
            t.symptom.equals(s.symptom),
      );
      final hasOpen = repeatedAlerts.any((a) => a.acknowledgedAt == null);
      if (!hasOpen) {
        final alert = await Alert.db.insertRow(
          session,
          Alert(
            patientId: patientId,
            kind: AlertKind.repeatedSymptom,
            priority: AlertPriority.important,
            symptom: s.symptom,
            message: '${s.symptom} reported 3 times in 7 days',
            createdAt: now,
          ),
        );
        await postUpdate(
          session,
          patientId,
          CareUpdate(patientId: patientId, alert: alert),
        );
      }
    }

    if (s.severity >= 4) {
      final alert = await Alert.db.insertRow(
        session,
        Alert(
          patientId: patientId,
          kind: AlertKind.severeSymptom,
          priority: AlertPriority.high,
          symptom: s.symptom,
          message: 'Immediate caregiver review recommended',
          createdAt: now,
        ),
      );
      await postUpdate(
        session,
        patientId,
        CareUpdate(patientId: patientId, alert: alert),
      );
    }
  }
}
