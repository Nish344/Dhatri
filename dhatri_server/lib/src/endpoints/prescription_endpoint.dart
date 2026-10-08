import 'package:serverpod/serverpod.dart';

import '../generated/future_calls.dart';
import '../generated/protocol.dart';
import '../services/access.dart';
import '../services/gemini.dart';
import '../services/prescription_confirm.dart';

class PrescriptionEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  static const _storageId = 'private';

  Future<UploadTicket> uploadTicket(Session session, int patientId) async {
    await requireAccess(session, patientId, write: true);
    final path = 'prescriptions/$patientId/${Uuid().v4()}.jpg';
    final description = await session.storage.createUploadDescription(
      storageId: _storageId,
      path: path,
    );
    return UploadTicket(path: path, description: description);
  }

  Future<Prescription> submit(
    Session session,
    int patientId,
    String path,
  ) async {
    await requireAccess(session, patientId, write: true);
    if (!path.startsWith('prescriptions/$patientId/')) {
      throw ArgumentError('Invalid upload path');
    }
    final ok = await session.storage.verifyUpload(
      storageId: _storageId,
      path: path,
    );
    if (!ok) {
      throw StateError('Upload not verified');
    }

    final rx = await Prescription.db.insertRow(
      session,
      Prescription(
        patientId: patientId,
        storageId: _storageId,
        path: path,
        status: PrescriptionStatus.uploaded,
      ),
    );

    await session.serverpod.futureCalls
        .callWithDelay(Duration.zero)
        .prescription
        .extract(rx.id!);

    return rx;
  }

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
  ) async {
    final p = await Prescription.db.findById(session, prescriptionId);
    if (p == null) throw ArgumentError('Prescription not found');
    await requireAccess(session, p.patientId, write: true);
    return confirmPrescription(session, prescriptionId, meds);
  }
}
