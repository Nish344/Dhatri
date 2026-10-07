import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/date_formatter.dart';
import '../../models/models.dart';
import 'dhatri_buttons.dart';
import 'dhatri_status_chip.dart';

class DhatriMedicationCard extends StatelessWidget {
  final DoseEvent dose;
  final bool isDominantNextDose;
  final VoidCallback? onTakeNow;
  final String? optimisticStatus; // 'saving' | 'saved'

  const DhatriMedicationCard({
    super.key,
    required this.dose,
    this.isDominantNextDose = false,
    this.onTakeNow,
    this.optimisticStatus,
  });

  @override
  Widget build(BuildContext context) {
    final isTaken = dose.status == DoseStatus.taken || optimisticStatus == 'saved';
    final isSaving = optimisticStatus == 'saving';

    if (isDominantNextDose) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isTaken ? AppColors.successBorder : AppColors.primary,
            width: isTaken ? 2 : 2.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isTaken ? AppColors.successBg : AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        isTaken ? '✓' : '💊',
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'NEXT MEDICINE',
                          style: AppTypography.statusLabel.copyWith(
                            color: AppColors.primary,
                            letterSpacing: 1.0,
                          ),
                        ),
                        Text(
                          DateFormatter.formatTime(dose.scheduledAt),
                          style: AppTypography.pageTitle.copyWith(fontSize: 24),
                        ),
                      ],
                    ),
                  ],
                ),
                if (isTaken)
                  const DhatriStatusChip(
                    label: '✓ TAKEN',
                    icon: Icons.check_circle_rounded,
                    textColor: AppColors.success,
                    backgroundColor: AppColors.successBg,
                    borderColor: AppColors.successBorder,
                  )
                else
                  DhatriStatusChip.fromDoseStatus(dose.status),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              dose.medicationName,
              style: AppTypography.displayLarge.copyWith(fontSize: 30),
            ),
            const SizedBox(height: 6),
            Text(
              '${dose.doseText} · ${dose.instructions ?? "With water"}',
              style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            if (isSaving)
              Container(
                constraints: const BoxConstraints(minHeight: 56),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.successBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.successBorder, width: 1.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.success),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        '✓ TAKEN · Saving...',
                        style: AppTypography.primaryAction.copyWith(
                          color: AppColors.success,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              )
            else if (isTaken)
              Container(
                constraints: const BoxConstraints(minHeight: 56),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.successBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.successBorder, width: 1.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 24),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        '✓ TAKEN · Confirmed',
                        style: AppTypography.primaryAction.copyWith(
                          color: AppColors.success,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              )
            else
              DhatriPrimaryButton(
                label: 'Take Now',
                icon: Icons.check_circle_rounded,
                onPressed: onTakeNow,
                height: 56,
                backgroundColor: AppColors.primary,
              ),
          ],
        ),
      );
    }

    // Standard list item
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isTaken ? AppColors.successBorder : AppColors.cardBorder,
          width: 1.2,
        ),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              Text(
                '💊 ${DateFormatter.formatTime(dose.scheduledAt)}',
                style: AppTypography.sectionTitle.copyWith(fontSize: 18),
              ),
              if (isTaken)
                const DhatriStatusChip(
                  label: '✓ TAKEN',
                  icon: Icons.check_circle_rounded,
                  textColor: AppColors.success,
                  backgroundColor: AppColors.successBg,
                  borderColor: AppColors.successBorder,
                )
              else
                DhatriStatusChip.fromDoseStatus(dose.status),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            dose.medicationName,
            style: AppTypography.cardTitle,
          ),
          const SizedBox(height: 4),
          Text(
            '${dose.doseText} · ${dose.instructions ?? "As directed"}',
            style: AppTypography.supporting,
          ),
          if (!isTaken && dose.status != DoseStatus.missed) ...[
            const SizedBox(height: 16),
            DhatriSecondaryButton(
              label: 'Mark as Taken',
              onPressed: onTakeNow,
              height: 48,
            ),
          ],
        ],
      ),
    );
  }
}

