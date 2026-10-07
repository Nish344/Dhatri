import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class ProfileEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<Profile?> me(Session session) async => throw UnimplementedError();

  Future<Profile> register(
    Session session,
    String name,
    Role role,
    int? age,
    String? phone,
  ) async =>
      throw UnimplementedError();

  Future<Profile> link(Session session, String code) async =>
      throw UnimplementedError();

  Future<List<Profile>> myPatients(Session session) async =>
      throw UnimplementedError();

  Future<Profile?> caregiverContact(Session session, int patientId) async =>
      throw UnimplementedError();
}
