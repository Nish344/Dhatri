import 'dart:convert';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'care_bus.dart';
import 'gemini.dart';

/// Body of `PrescriptionFutureCall.extract`: `uploaded → extracting →
/// extracted` (or `failed` with a caregiver-facing `error`). Safe to run twice:
/// a prescription that already left extraction is left alone.
Future<void> extractPrescription(
  Session session,
  int prescriptionId,
  Gemini gemini,
) async {
  var p = await Prescription.db.findById(session, prescriptionId);
  if (p == null ||
      !{
        PrescriptionStatus.uploaded,
        PrescriptionStatus.extracting,
      }.contains(p.status)) {
    return;
  }
  p = await _save(session, p.copyWith(status: PrescriptionStatus.extracting));

  try {
    final ByteData bytes;
    try {
      bytes = await session.storage.retrieveFile(
        storageId: p.storageId,
        path: p.path,
      );
    } on CloudStorageFileNotFoundException {
      await _save(
        session,
        p.copyWith(
          status: PrescriptionStatus.failed,
          error: 'The photo could not be found. Please upload it again.',
        ),
      );
      return;
    }
    final json = await gemini.extractPrescription(
      bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes),
      _mimeType(p.path),
    );
    final unreadable = (jsonDecode(json) as Map)['unreadable'] == true;
    await _save(
      session,
      unreadable || parseDrafts(json).isEmpty
          ? p.copyWith(
              status: PrescriptionStatus.failed,
              extractedJson: json,
              error:
                  'We could not read this prescription. Retake the photo in good light, or add the medicines by hand.',
            )
          : p.copyWith(
              status: PrescriptionStatus.extracted,
              extractedJson: json,
            ),
    );
  } catch (e, st) {
    session.log(
      'Prescription $prescriptionId extraction failed: $e',
      level: LogLevel.error,
      exception: e,
      stackTrace: st,
    );
    await _save(
      session,
      p.copyWith(
        status: PrescriptionStatus.failed,
        error:
            'Reading the prescription failed. Try again, or add the medicines by hand.',
      ),
    );
  }
}

Future<Prescription> _save(Session session, Prescription p) async {
  final saved = await Prescription.db.updateRow(session, p);
  await postUpdate(
    session,
    saved.patientId,
    CareUpdate(patientId: saved.patientId, prescription: saved),
  );
  return saved;
}

String _mimeType(String path) => switch (path.split('.').last.toLowerCase()) {
  'png' => 'image/png',
  'webp' => 'image/webp',
  'heic' => 'image/heic',
  _ => 'image/jpeg',
};
