import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
class PatientsEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<List<PatientStatus>> overview(Session session) async {
    throw UnimplementedError();
  }
}
