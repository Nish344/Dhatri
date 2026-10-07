import 'dart:math';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'access.dart';

Future<Profile?> currentProfile(Session session) async {
  final auth = session.authenticated;
  if (auth == null) return null;
  return Profile.db.findFirstRow(
    session,
    where: (t) => t.authUserId.equals(auth.userIdentifier),
  );
}

Future<Profile> registerProfile(
  Session session,
  String name,
  Role role,
  int? age,
  String? phone,
) async {
  final auth = session.authenticated;
  if (auth == null) {
    throw StateError('Sign in required');
  }
  final existing = await Profile.db.findFirstRow(
    session,
    where: (t) => t.authUserId.equals(auth.userIdentifier),
  );
  if (existing != null) {
    throw StateError('Profile already exists');
  }

  String? linkCode;
  if (role == Role.patient) {
    linkCode = await _uniqueLinkCode(session);
  }

  return Profile.db.insertRow(
    session,
    Profile(
      authUserId: auth.userIdentifier,
      name: name,
      role: role,
      age: age,
      phone: phone,
      linkCode: linkCode,
    ),
  );
}

Future<Profile> linkWithCode(Session session, String code) async {
  final caller = await callerProfile(session);
  if (caller.role != Role.caregiver && caller.role != Role.doctor) {
    throw StateError('Only caregivers and doctors can link');
  }
  final patient = await Profile.db.findFirstRow(
    session,
    where: (t) => t.linkCode.equals(code.trim()),
  );
  if (patient == null || patient.role != Role.patient) {
    throw ArgumentError('Invalid link code');
  }

  if (caller.role == Role.caregiver) {
    return Profile.db.updateRow(
      session,
      patient.copyWith(caregiverId: caller.id),
    );
  }
  return Profile.db.updateRow(
    session,
    patient.copyWith(doctorId: caller.id),
  );
}

Future<List<Profile>> linkedPatients(Session session) async {
  final caller = await callerProfile(session);
  if (caller.role == Role.caregiver) {
    return Profile.db.find(
      session,
      where: (t) => t.caregiverId.equals(caller.id!),
      orderBy: (t) => t.name,
    );
  }
  if (caller.role == Role.doctor) {
    return Profile.db.find(
      session,
      where: (t) => t.doctorId.equals(caller.id!),
      orderBy: (t) => t.name,
    );
  }
  return [];
}

Future<String> _uniqueLinkCode(Session session) async {
  final rng = Random.secure();
  for (var i = 0; i < 20; i++) {
    final code = (100000 + rng.nextInt(900000)).toString();
    final taken = await Profile.db.findFirstRow(
      session,
      where: (t) => t.linkCode.equals(code),
    );
    if (taken == null) return code;
  }
  throw StateError('Could not allocate link code');
}
