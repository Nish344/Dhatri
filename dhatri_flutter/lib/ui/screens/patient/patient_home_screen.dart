import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../state/care_state.dart';
import '../../../state/voice_call_state.dart';
import '../../../mock_engine/mock_database.dart';
import '../../components/dhatri_medication_card.dart';
import '../../components/dhatri_buttons.dart';

class PatientHomeScreen extends StatelessWidget {
  final VoidCallback onOpenVoiceCall;

  const PatientHomeScreen({
    super.key,
    required this.onOpenVoiceCall,
  });

  @override
  Widget build(BuildContext context) {
    final care = context.watch<CareState>();
    final nextDose = care.nextDose;
    final now = DateTime.now();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting & Date
          Text(
            'Good evening, Ramesh',
            style: AppTypography.pageTitle,
          ),
          const SizedBox(height: 4),
          Text(
            DateFormatter.formatFullDate(now),
            style: AppTypography.supporting.copyWith(fontSize: 17),
          ),
          const SizedBox(height: 24),

          // Dominant Next Dose Hero Card
          if (nextDose != null)
            DhatriMedicationCard(
              dose: nextDose,
              isDominantNextDose: true,
              optimisticStatus: care.getOptimisticStatus(nextDose.id),
              onTakeNow: () => care.markTaken(nextDose.id),
            )
          else
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.successBorder, width: 2),
              ),
              child: Row(
                children: [
                  const Text('🎉', style: TextStyle(fontSize: 32)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('All caught up for today!', style: AppTypography.cardTitle),
                        const SizedBox(height: 4),
                        Text(
                          'You have taken all your scheduled medications.',
                          style: AppTypography.supporting,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 28),

          // Today's Routine Overview
          Text(
            'TODAY\'S SCHEDULE',
            style: AppTypography.statusLabel.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: care.todayDoses.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final dose = care.todayDoses[index];
              return DhatriMedicationCard(
                dose: dose,
                isDominantNextDose: false,
                optimisticStatus: care.getOptimisticStatus(dose.id),
                onTakeNow: () => care.markTaken(dose.id),
              );
            },
          ),

          const SizedBox(height: 28),

          // Talk to Dhatri Voice Check-In Action
          InkWell(
            onTap: onOpenVoiceCall,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 1.5),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.mic_rounded, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Talk to Dhatri',
                          style: AppTypography.cardTitle.copyWith(color: AppColors.primary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'How are you feeling today? Tap to check in in Hindi.',
                          style: AppTypography.supporting.copyWith(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: AppColors.primary, size: 28),
                ],
              ),
            ),
          ),
          const SizedBox(height: 80), // Padding for floating toolbar
        ],
      ),
    );
  }
}

