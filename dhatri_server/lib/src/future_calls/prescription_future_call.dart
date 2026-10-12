import 'package:serverpod/serverpod.dart';

import '../services/gemini.dart';
import '../services/prescription_extraction.dart';

class PrescriptionFutureCall extends FutureCall {
  Future<void> extract(Session session, int prescriptionId) {
    session.log('futureCall.rx.extract id=$prescriptionId');
    return extractPrescription(session, prescriptionId, Gemini.of(session));
  }
}
