import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../models/models.dart';
import '../../../mock_engine/mock_care_stream.dart';
import '../../../mock_engine/mock_database.dart';
import '../../../state/care_state.dart';
import '../../../state/auth_state.dart';
import '../../components/dhatri_buttons.dart';
import '../../components/dhatri_status_chip.dart';
import '../../components/dhatri_memory_card.dart';
import '../../components/dhatri_timeline_item.dart';

class PatientDetailScreen extends StatelessWidget {
  final PatientStatus status;

  const PatientDetailScreen({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final care = context.watch<CareState>();
    final stream = context.read<MockCareStream>();
    final db = context.read<MockDatabase>();
    final patient = status.patient;

    final memories = db.patientMemories
        .where((m) => m.patientId == patient.id)
        .map((m) => m.content)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(patient.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.cardBorder, width: 1.2),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: AppColors.primaryLight,
                    child: Text(
                      patient.name.substring(0, 1),
                      style: AppTypography.displayLarge.copyWith(
                        fontSize: 28,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${patient.name} · ${patient.age ?? 72}',
                          style: AppTypography.cardTitle.copyWith(fontSize: 22),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Link Code: ${patient.linkCode ?? "482910"}',
                          style: AppTypography.supporting,
                        ),
                        const SizedBox(height: 6),
                        DhatriStatusChip.fromPatientState(status.state),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Remote Wellness Call Trigger (Guide §13)
            DhatriPrimaryButton(
              label: '🎙 Initiate Wellness Call Now',
              onPressed: () {
                stream.triggerIncomingCall();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Care check-in triggered! Switched to Patient phone.'),
                    backgroundColor: AppColors.callGreen,
                  ),
                );
                // Switch role so presenter sees ringing phone
                context.read<AuthState>().switchToRole(Role.patient);
                Navigator.pop(context);
              },
              backgroundColor: AppColors.callGreen,
              height: 56,
            ),

            const SizedBox(height: 28),

            // Patient Memory Context Section (Guide §23)
            Text(
              'DHATRI PATIENT MEMORY',
              style: AppTypography.statusLabel.copyWith(
                color: AppColors.textSecondary,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 10),
            DhatriMemoryCard(
              memories: memories,
              title: 'Longitudinal context stored by Dhatri',
            ),

            const SizedBox(height: 28),

            // Active Medications
            Text(
              'ACTIVE PRESCRIPTIONS',
              style: AppTypography.statusLabel.copyWith(
                color: AppColors.textSecondary,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 10),
            ...db.medications.map((med) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${med.name} ${med.strength ?? ""}', style: AppTypography.cardTitle.copyWith(fontSize: 18)),
                          const SizedBox(height: 4),
                          Text('${med.doseText} · ${med.instructions ?? "With meals"}', style: AppTypography.supporting),
                        ],
                      ),
                      Text(
                        med.times.join(', '),
                        style: AppTypography.statusLabel.copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                )),

            const SizedBox(height: 28),

            // Recent Timeline
            Text(
              'RECENT CARE TIMELINE',
              style: AppTypography.statusLabel.copyWith(
                color: AppColors.textSecondary,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 12),
            ...care.timeline.take(4).map((item) => DhatriTimelineItemCard(item: item)),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

