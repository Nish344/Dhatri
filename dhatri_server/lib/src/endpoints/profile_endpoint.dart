import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/access.dart';
import '../services/profile_service.dart';

class ProfileEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<Profile?> me(Session session) async => currentProfile(session);

  Future<Profile> register(
    Session session,
    String name,
    Role role,
    int? age,
    String? phone,
  ) async => registerProfile(session, name, role, age, phone);

  Future<Profile> link(Session session, String code) async =>
      linkWithCode(session, code);

  Future<List<Profile>> myPatients(Session session) async =>
      linkedPatients(session);

  Future<Profile?> caregiverContact(Session session, int patientId) async {
    await requireAccess(session, patientId, write: false);
    final patient = await Profile.db.findById(session, patientId);
    if (patient?.caregiverId == null) return null;
    return Profile.db.findById(session, patient!.caregiverId!);
  }
}
