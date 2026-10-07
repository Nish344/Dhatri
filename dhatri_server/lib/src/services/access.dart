import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'access_denied.dart';
import 'access_logic.dart';

Future<Profile> callerProfile(Session session) async {
  final auth = session.authenticated;
  if (auth == null) {
    throw const AccessDeniedException('Not signed in');
  }
  final profile = await Profile.db.findFirstRow(
    session,
    where: (t) => t.authUserId.equals(auth.userIdentifier),
  );
  if (profile == null) {
    throw const AccessDeniedException('No profile for this account');
  }
  return profile;
}

/// Ensures the caller may read or write data for [patientId].
Future<Profile> requireAccess(
  Session session,
  int patientId, {
  required bool write,
}) async {
  final caller = await callerProfile(session);
  final patient = await Profile.db.findById(session, patientId);
  if (patient == null) {
    throw const AccessDeniedException('Patient not found');
  }
  verifyAccess(caller, patient, write: write);
  return caller;
}
