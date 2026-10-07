import 'package:serverpod/serverpod.dart';
import 'package:serverpod_database/serverpod_database.dart';

import '../generated/protocol.dart';

/// Serializable dose status change (ARCHITECTURE.md §6 Rule 2).
Future<bool> transitionDoseStatus(
  Session session,
  int doseEventId, {
  required Set<DoseStatus> from,
  required DoseStatus to,
}) async {
  try {
    return await session.db.transaction(
      (tx) async {
        final event = await DoseEvent.db.findById(
          session,
          doseEventId,
          transaction: tx,
        );
        if (event == null || !from.contains(event.status)) return false;

        final now = DateTime.now().toUtc();
        await DoseEvent.db.updateRow(
          session,
          event.copyWith(
            status: to,
            takenAt: to == DoseStatus.taken ? now : event.takenAt,
            remindedAt: to == DoseStatus.reminded ? now : event.remindedAt,
          ),
          transaction: tx,
        );
        return true;
      },
      settings: const TransactionSettings(
        isolationLevel: IsolationLevel.serializable,
      ),
    );
  } on DatabaseQueryException catch (e) {
    if (e.code == PgErrorCode.serializationFailure) return false;
    rethrow;
  }
}
