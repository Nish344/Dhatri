import 'package:serverpod/serverpod.dart';

import '../services/gemini.dart';
import '../services/prescription_extraction.dart';

class PrescriptionFutureCall extends FutureCall {
  Future<void> extract(Session session, int prescriptionId) =>
      extractPrescription(session, prescriptionId, Gemini.of(session));
}
