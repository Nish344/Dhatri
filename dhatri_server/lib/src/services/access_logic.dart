import '../generated/protocol.dart';
import 'access_denied.dart';

/// Pure access rules from ARCHITECTURE.md §5 (doctor is read-only).
void verifyAccess(
  Profile caller,
  Profile patient, {
  required bool write,
}) {
  if (caller.role == Role.doctor && write) {
    throw const AccessDeniedException('Doctor cannot write');
  }

  final allowed =
      caller.id == patient.id ||
      (caller.role == Role.caregiver && patient.caregiverId == caller.id) ||
      (caller.role == Role.doctor && patient.doctorId == caller.id);

  if (!allowed) {
    throw const AccessDeniedException();
  }
}
