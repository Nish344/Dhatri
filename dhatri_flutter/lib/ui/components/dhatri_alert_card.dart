import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/date_formatter.dart';
import '../../models/models.dart';
import 'dhatri_buttons.dart';

class DhatriAlertCard extends StatelessWidget {
  final Alert alert;
  final VoidCallback onCallPatient;
  final VoidCallback onAcknowledge;

  const DhatriAlertCard({
    super.key,
    required this.alert,
    required this.onCallPatient,
    required this.onAcknowledge,
  });

  @override
  Widget build(BuildContext context) {
    final isMissedDose = alert.kind == AlertKind.missedDose;
    final borderColor = isMissedDose ? AppColors.error : AppColors.warning;
    final bgColor = isMissedDose ? AppColors.errorBg.withOpacity(0.4) : AppColors.warningBg.withOpacity(0.4);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 2),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    isMissedDose ? Icons.warning_rounded : Icons.info_outline_rounded,
                    color: borderColor,
                    size: 26,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isMissedDose ? 'MISSED DOSE ALERT' : 'SYMPTOM ALERT',
                    style: AppTypography.statusLabel.copyWith(
                      color: borderColor,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              Text(
                DateFormatter.relativeDay(alert.createdAt),
                style: AppTypography.supporting.copyWith(fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${alert.patientName} · 72',
            style: AppTypography.sectionTitle.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 6),
          Text(
            alert.message,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: DhatriPrimaryButton(
                  label: '📞 CALL RAMESH',
                  onPressed: onCallPatient,
                  backgroundColor: AppColors.callGreen,
                  height: 52,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: DhatriSecondaryButton(
                  label: 'Dismiss',
                  onPressed: onAcknowledge,
                  height: 52,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

