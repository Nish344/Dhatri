import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/access.dart';
import '../services/gemini.dart';

class PrescriptionEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<UploadTicket> uploadTicket(Session session, int patientId) async =>
      throw UnimplementedError();

  Future<Prescription> submit(
    Session session,
    int patientId,
    String path,
  ) async => throw UnimplementedError();

  Future<List<MedicationDraft>> drafts(
    Session session,
    int prescriptionId,
  ) async {
    final p = await Prescription.db.findById(session, prescriptionId);
    if (p == null) throw ArgumentError('Prescription not found');
    await requireAccess(session, p.patientId, write: true);
    return parseDrafts(p.extractedJson);
  }

  Future<List<Medication>> confirm(
    Session session,
    int prescriptionId,
    List<MedicationDraft> meds,
  ) async => throw UnimplementedError();
}
