import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../state/care_state.dart';
import '../../components/dhatri_buttons.dart';

class PatientHelpScreen extends StatelessWidget {
  const PatientHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final care = context.read<CareState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Contacts'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Emergency 112 Card
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppColors.errorBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.errorBorder, width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.emergency_rounded, color: AppColors.error, size: 30),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          'MEDICAL EMERGENCY',
                          style: AppTypography.statusLabel.copyWith(
                            color: AppColors.error,
                            letterSpacing: 1.0,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'In an emergency, call 112 immediately.',
                    style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 18),
                  DhatriPrimaryButton(
                    label: '🚨 Call 112 Now',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Calling 112 Emergency Services...')),
                      );
                    },
                    backgroundColor: AppColors.emergencyRed,
                    height: 58,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Caregiver Contact Card
            Text(
              'YOUR CAREGIVER',
              style: AppTypography.statusLabel.copyWith(
                color: AppColors.textSecondary,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.cardBorder, width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: AppColors.primaryLight,
                        child: Text(
                          'A',
                          style: AppTypography.displayLarge.copyWith(
                            fontSize: 24,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Ananya Kumar', style: AppTypography.cardTitle),
                            const SizedBox(height: 2),
                            Text('Daughter · Primary Caregiver', style: AppTypography.supporting),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  DhatriPrimaryButton(
                    label: '📞 Call Ananya',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Calling Ananya (+91 98111 22233)...')),
                      );
                    },
                    backgroundColor: AppColors.callGreen,
                    height: 58,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Emergency Need Help trigger
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.warningBorder, width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 28),
                      const SizedBox(width: 10),
                      Text('Feeling Unwell?', style: AppTypography.cardTitle),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Tap below if something feels wrong or you need immediate check-in.',
                    style: AppTypography.bodyMedium,
                  ),
                  const SizedBox(height: 18),
                  DhatriSecondaryButton(
                    label: '⚠ Something Feels Wrong — Alert Ananya',
                    onPressed: () {
                      care.triggerEmergencyHelp();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('🚨 Urgent alert sent to Ananya!'),
                          backgroundColor: AppColors.error,
                        ),
                      );
                    },
                    height: 56,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

