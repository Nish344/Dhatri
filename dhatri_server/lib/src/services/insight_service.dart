import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'gemini.dart';

const _ist = Duration(hours: 5, minutes: 30);

/// Start of today in IST, as a UTC instant.
DateTime istDayStartUtc([DateTime? now]) {
  final ist = (now ?? DateTime.now()).toUtc().add(_ist);
  return DateTime.utc(ist.year, ist.month, ist.day).subtract(_ist);
}

/// Symptom counts in `[from, to)`, most frequent first.
Future<List<SymptomCount>> symptomCounts(
  Session session,
  int patientId,
  DateTime from,
  DateTime to,
) async {
  final rows = await SymptomReport.db.find(
    session,
    where: (t) =>
        t.patientId.equals(patientId) &
        (t.reportedAt >= from) &
        (t.reportedAt < to),
  );
  final bySymptom = <String, SymptomCount>{};
  for (final r in rows) {
    final c = bySymptom[r.symptom];
    bySymptom[r.symptom] = SymptomCount(
      symptom: r.symptom,
      count: (c?.count ?? 0) + 1,
      maxSeverity: c == null || r.severity > c.maxSeverity
          ? r.severity
          : c.maxSeverity,
    );
  }
  return bySymptom.values.toList()..sort((a, b) => b.count.compareTo(a.count));
}

/// Taken and missed doses scheduled in `[from, to)`.
Future<({int taken, int missed})> doseCounts(
  Session session,
  int patientId,
  DateTime from,
  DateTime to,
) async {
  final rows = await DoseEvent.db.find(
    session,
    where: (t) =>
        t.patientId.equals(patientId) &
        (t.scheduledAt >= from) &
        (t.scheduledAt < to),
  );
  return (
    taken: rows.where((d) => d.status == DoseStatus.taken).length,
    missed: rows.where((d) => d.status == DoseStatus.missed).length,
  );
}

int? _pct(({int taken, int missed}) d) => d.taken + d.missed == 0
    ? null
    : (100 * d.taken / (d.taken + d.missed)).round();

final _summaryCache = <String, ({DateTime at, String text})>{};

/// The weekly picture for the caregiver summary, doctor dashboard and patient
/// detail. Numbers and the review flag come from SQL and rules; only the
/// wording comes from Gemini, with a template when Gemini fails.
Future<PatientInsight> weekInsight(
  Session session,
  Profile patient, {
  Gemini? gemini,
}) async {
  final patientId = patient.id!;
  final now = DateTime.now().toUtc();
  final weekAgo = now.subtract(const Duration(days: 7));
  final twoWeeksAgo = now.subtract(const Duration(days: 14));

  final week = await doseCounts(session, patientId, weekAgo, now);
  final prev = await doseCounts(session, patientId, twoWeeksAgo, weekAgo);
  final symptoms = await symptomCounts(session, patientId, weekAgo, now);
  final checkIns = await WellnessCheck.db.count(
    session,
    where: (t) =>
        t.patientId.equals(patientId) &
        t.status.equals(CheckStatus.completed) &
        (t.createdAt > weekAgo),
  );
  final openAlerts = await Alert.db.find(
    session,
    where: (t) => t.patientId.equals(patientId) & t.acknowledgedAt.equals(null),
    orderBy: (t) => t.createdAt.desc(),
  );
  final latestCheck = await WellnessCheck.db.findFirstRow(
    session,
    where: (t) =>
        t.patientId.equals(patientId) & t.status.equals(CheckStatus.completed),
    orderBy: (t) => t.createdAt.desc(),
  );

  final adherence = _pct(week);
  final insight = PatientInsight(
    patient: patient,
    adherencePct: adherence,
    prevAdherencePct: _pct(prev),
    dosesTaken: week.taken,
    dosesMissed: week.missed,
    checkIns: checkIns,
    symptoms: symptoms,
    openAlerts: openAlerts,
    reviewRecommended:
        openAlerts.any(
          (a) =>
              a.kind == AlertKind.repeatedSymptom ||
              a.kind == AlertKind.severeSymptom,
        ) ||
        (adherence != null && adherence < 80) ||
        week.missed >= 2,
    aiSummary: '',
    latestCheck: latestCheck,
    generatedAt: now,
  );
  return insight.copyWith(aiSummary: await _summary(session, insight, gemini));
}

Future<String> _summary(
  Session session,
  PatientInsight facts,
  Gemini? gemini,
) async {
  final key = [
    facts.patient.id,
    facts.adherencePct,
    facts.prevAdherencePct,
    facts.dosesTaken,
    facts.dosesMissed,
    facts.checkIns,
    for (final s in facts.symptoms) '${s.symptom}${s.count}/${s.maxSeverity}',
    for (final a in facts.openAlerts) a.id,
  ].join('|');
  final cached = _summaryCache[key];
  if (cached != null && DateTime.now().difference(cached.at).inMinutes < 5) {
    return cached.text;
  }
  var text = templateSummary(facts);
  if (gemini != null) {
    try {
      text = await gemini.summarizeWeek(facts);
    } catch (e) {
      session.log(
        'Weekly summary fell back to template: $e',
        level: LogLevel.warning,
      );
    }
  }
  _summaryCache[key] = (at: DateTime.now(), text: text);
  return text;
}

/// Deterministic summary used when Gemini is unavailable.
String templateSummary(PatientInsight f) {
  final total = f.dosesTaken + f.dosesMissed;
  final lines = <String>[
    if (total == 0)
      'No doses have come due this week yet.'
    else
      '${f.dosesTaken} of $total doses were taken this week'
          '${f.adherencePct == null ? '' : ' (adherence ${f.adherencePct}%'
                    '${f.prevAdherencePct == null ? ')' : ', previous week ${f.prevAdherencePct}%)'}'}.',
    if (f.symptoms.isNotEmpty)
      '${f.symptoms.map((s) => '${_cap(s.symptom)} was reported ${s.count} ${s.count == 1 ? 'time' : 'times'}').join('; ')} '
          'across ${f.checkIns} completed check-ins.'
    else
      'No symptoms were reported across ${f.checkIns} completed check-ins.',
    if (f.openAlerts.isNotEmpty)
      '${f.openAlerts.length} ${f.openAlerts.length == 1 ? 'alert is' : 'alerts are'} still open.',
  ];
  return lines.join(' ');
}

String _cap(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
