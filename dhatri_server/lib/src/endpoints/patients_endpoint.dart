import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/access.dart';
import '../services/patients_overview.dart';

class PatientsEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<List<PatientStatus>> overview(Session session) async {
    final caller = await callerProfile(session);
    return switch (caller.role) {
      Role.caregiver => caregiverOverview(session, caller),
      Role.doctor => doctorOverview(session, caller),
      _ => throw StateError('Patients overview is for caregivers and doctors'),
    };
  }
}
