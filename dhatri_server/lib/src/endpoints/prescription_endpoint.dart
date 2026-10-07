import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class PrescriptionEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<UploadTicket> uploadTicket(Session session, int patientId) async =>
      throw UnimplementedError();

  Future<Prescription> submit(
    Session session,
    int patientId,
    String path,
  ) async =>
      throw UnimplementedError();

  Future<List<MedicationDraft>> drafts(
    Session session,
    int prescriptionId,
  ) async =>
      throw UnimplementedError();

  Future<List<Medication>> confirm(
    Session session,
    int prescriptionId,
    List<MedicationDraft> meds,
  ) async =>
      throw UnimplementedError();
}
