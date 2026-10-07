import 'package:serverpod/serverpod.dart';

import 'package:dhatri_server/src/generated/protocol.dart';

Future<Profile> insertProfile(
  Session session, {
  required String authUserId,
  required String name,
  required Role role,
  int? caregiverId,
  int? doctorId,
}) async {
  return Profile.db.insertRow(
    session,
    Profile(
      authUserId: authUserId,
      name: name,
      role: role,
      caregiverId: caregiverId,
      doctorId: doctorId,
      linkCode: role == Role.patient ? '123456' : null,
    ),
  );
}

Future<DoseEvent> insertRemindedDose(
  Session session, {
  required int patientId,
  int medicationId = 1,
}) async {
  return DoseEvent.db.insertRow(
    session,
    DoseEvent(
      patientId: patientId,
      medicationId: medicationId,
      scheduledAt: DateTime.now().toUtc().subtract(const Duration(hours: 1)),
      status: DoseStatus.reminded,
      remindedAt: DateTime.now().toUtc(),
    ),
  );
}

Future<WellnessCheck> insertCheck(Session session, int patientId) async {
  return WellnessCheck.db.insertRow(
    session,
    WellnessCheck(
      patientId: patientId,
      status: CheckStatus.active,
      trigger: CheckTrigger.daily,
    ),
  );
}

Future<int> missedDoseAlertCount(Session session, int patientId) async {
  return Alert.db.count(
    session,
    where: (t) =>
        t.patientId.equals(patientId) & t.kind.equals(AlertKind.missedDose),
  );
}
