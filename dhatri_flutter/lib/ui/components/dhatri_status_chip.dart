import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/models.dart';

/// Semantic Status Chip strictly adhering to: Icon + Label + Accessible Color.
/// Never relies on color alone.
class DhatriStatusChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;

  const DhatriStatusChip({
    super.key,
    required this.label,
    required this.icon,
    required this.textColor,
    required this.backgroundColor,
    required this.borderColor,
  });

  factory DhatriStatusChip.fromDoseStatus(DoseStatus status) {
    switch (status) {
      case DoseStatus.taken:
        return const DhatriStatusChip(
          label: '✓ TAKEN',
          icon: Icons.check_circle_rounded,
          textColor: AppColors.success,
          backgroundColor: AppColors.successBg,
          borderColor: AppColors.successBorder,
        );
      case DoseStatus.missed:
        return const DhatriStatusChip(
          label: '❌ MISSED',
          icon: Icons.cancel_rounded,
          textColor: AppColors.error,
          backgroundColor: AppColors.errorBg,
          borderColor: AppColors.errorBorder,
        );
      case DoseStatus.reminded:
        return const DhatriStatusChip(
          label: '🔔 REMINDED',
          icon: Icons.notifications_active_rounded,
          textColor: AppColors.warning,
          backgroundColor: AppColors.warningBg,
          borderColor: AppColors.warningBorder,
        );
      case DoseStatus.scheduled:
        return const DhatriStatusChip(
          label: '○ UPCOMING',
          icon: Icons.schedule_rounded,
          textColor: AppColors.info,
          backgroundColor: AppColors.infoBg,
          borderColor: AppColors.infoBorder,
        );
    }
  }

  factory DhatriStatusChip.fromPatientState(PatientState state) {
    switch (state) {
      case PatientState.allGood:
        return const DhatriStatusChip(
          label: '✓ All good',
          icon: Icons.check_circle_outline_rounded,
          textColor: AppColors.success,
          backgroundColor: AppColors.successBg,
          borderColor: AppColors.successBorder,
        );
      case PatientState.checkInNeeded:
        return const DhatriStatusChip(
          label: '⚠ Check-in needed',
          icon: Icons.phone_callback_rounded,
          textColor: AppColors.warning,
          backgroundColor: AppColors.warningBg,
          borderColor: AppColors.warningBorder,
        );
      case PatientState.medicationMissed:
        return const DhatriStatusChip(
          label: '❌ Dose missed',
          icon: Icons.error_outline_rounded,
          textColor: AppColors.error,
          backgroundColor: AppColors.errorBg,
          borderColor: AppColors.errorBorder,
        );
      case PatientState.attention:
        return const DhatriStatusChip(
          label: '⚠ Review alert',
          icon: Icons.warning_amber_rounded,
          textColor: AppColors.warning,
          backgroundColor: AppColors.warningBg,
          borderColor: AppColors.warningBorder,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: textColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTypography.statusLabel.copyWith(color: textColor),
          ),
        ],
      ),
    );
  }
}

