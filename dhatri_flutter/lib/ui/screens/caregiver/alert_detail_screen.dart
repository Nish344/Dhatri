import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../models/models.dart';
import '../../../state/care_state.dart';
import '../../components/dhatri_buttons.dart';

class AlertDetailScreen extends StatelessWidget {
  final Alert alert;

  const AlertDetailScreen({
    super.key,
    required this.alert,
  });

  @override
  Widget build(BuildContext context) {
    final isMissedDose = alert.kind == AlertKind.missedDose;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alert Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Alert Type Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isMissedDose ? AppColors.errorBg : AppColors.warningBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isMissedDose ? AppColors.errorBorder : AppColors.warningBorder,
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isMissedDose ? Icons.error_rounded : Icons.warning_rounded,
                    color: isMissedDose ? AppColors.error : AppColors.warning,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isMissedDose ? 'CRITICAL MISSED DOSE' : 'REPEATED CONCERN',
                    style: AppTypography.statusLabel.copyWith(
                      color: isMissedDose ? AppColors.error : AppColors.warning,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Text(
              alert.message,
              style: AppTypography.displayLarge.copyWith(fontSize: 26),
            ),
            const SizedBox(height: 8),
            Text(
              'Reported ${DateFormatter.relativeDay(alert.createdAt)}',
              style: AppTypography.supporting,
            ),
            const SizedBox(height: 28),

            // Escalation Audit Log (Architecture §6)
            Text('ESCALATION CHRONOLOGY', style: AppTypography.statusLabel.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                children: [
                  _logStep('8:00 PM', 'Dose reminder sent to patient phone'),
                  const Divider(height: 20),
                  _logStep('8:15 PM', 'No confirmation logged from patient'),
                  const Divider(height: 20),
                  _logStep('8:20 PM', '20-min grace period expired -> Escalated to caregiver'),
                ],
              ),
            ),
            const SizedBox(height: 36),

            // Action Buttons
            DhatriPrimaryButton(
              label: 'Call ${alert.patientName}',
              icon: Icons.phone_rounded,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Calling ${alert.patientName} (+91 98765 43210)...'),
                    backgroundColor: AppColors.callGreen,
                  ),
                );
              },
              backgroundColor: AppColors.callGreen,
              height: 56,
            ),
            const SizedBox(height: 14),
            DhatriSecondaryButton(
              label: 'Mark as Handled / Dismiss',
              onPressed: () {
                context.read<CareState>().acknowledgeAlert(alert.id);
                Navigator.pop(context);
              },
              height: 50,
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _logStep(String time, String detail) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          time,
          style: AppTypography.statusLabel.copyWith(color: AppColors.primary),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            detail,
            style: AppTypography.bodyMedium,
          ),
        ),
      ],
    );
  }
}

