import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

Future<List<TimelineItem>> buildTimeline(
  Session session,
  int patientId,
  int days,
) async {
  final cap = days.clamp(1, 14);
  final since = DateTime.now().toUtc().subtract(Duration(days: cap));
  final items = <TimelineItem>[];

  final doses = await DoseEvent.db.find(
    session,
    where: (t) => t.patientId.equals(patientId) & (t.scheduledAt >= since),
    orderBy: (t) => t.scheduledAt.desc(),
  );
  for (final d in doses) {
    final (tone, title) = switch (d.status) {
      DoseStatus.taken => (TimelineTone.good, 'Dose taken'),
      DoseStatus.missed => (TimelineTone.missed, 'Dose missed'),
      DoseStatus.reminded => (TimelineTone.warning, 'Dose reminder sent'),
      _ => (TimelineTone.neutral, 'Dose scheduled'),
    };
    items.add(
      TimelineItem(
        at: d.takenAt ?? d.remindedAt ?? d.scheduledAt,
        kind: TimelineKind.dose,
        tone: tone,
        title: title,
        detail:
            'Medication #${d.medicationId} at ${d.scheduledAt.toIso8601String()}',
      ),
    );
  }

  final checks = await WellnessCheck.db.find(
    session,
    where: (t) => t.patientId.equals(patientId) & (t.createdAt >= since),
    orderBy: (t) => t.createdAt.desc(),
  );
  for (final c in checks) {
    if (c.status == CheckStatus.completed) {
      items.add(
        TimelineItem(
          at: c.completedAt ?? c.createdAt,
          kind: TimelineKind.wellness,
          tone: c.mood == 'low' ? TimelineTone.warning : TimelineTone.neutral,
          title: 'Care check-in',
          detail: c.summaryEn ?? 'Check-in completed',
        ),
      );
    } else if (c.status == CheckStatus.snoozed && c.ringCount >= 2) {
      items.add(
        TimelineItem(
          at: c.createdAt,
          kind: TimelineKind.wellness,
          tone: TimelineTone.warning,
          title: 'Check-in not answered',
          detail: 'The evening care call rang twice with no answer.',
        ),
      );
    }
  }

  final alerts = await Alert.db.find(
    session,
    where: (t) => t.patientId.equals(patientId) & (t.createdAt >= since),
    orderBy: (t) => t.createdAt.desc(),
  );
  for (final a in alerts) {
    items.add(
      TimelineItem(
        at: a.createdAt,
        kind: TimelineKind.alert,
        tone: a.priority == AlertPriority.high
            ? TimelineTone.missed
            : TimelineTone.warning,
        title: switch (a.kind) {
          AlertKind.missedDose => 'Missed dose alert',
          AlertKind.repeatedSymptom => 'Repeated symptom',
          AlertKind.severeSymptom => 'Severe symptom',
          AlertKind.patientHelp => 'Patient requested help',
        },
        detail: a.message,
      ),
    );
  }

  items.sort((a, b) => b.at.compareTo(a.at));
  return items.take(50).toList();
}
