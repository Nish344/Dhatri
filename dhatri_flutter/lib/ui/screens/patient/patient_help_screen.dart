import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../state/care_state.dart';
import '../../../state/auth_state.dart';
import '../../components/dhatri_buttons.dart';

class PatientHelpScreen extends StatelessWidget {
  const PatientHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    final care = context.watch<CareState>();
    final caregiver = care.caregiverContact;

    return SingleChildScrollView(
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
                    label: 'Call 112 Now',
                    icon: Icons.emergency_rounded,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Calling 112 Emergency Services...')),
                      );
                    },
                    backgroundColor: AppColors.emergencyRed,
                    height: 54,
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
            if (caregiver != null)
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
                            caregiver.name.isNotEmpty
                                ? caregiver.name[0].toUpperCase()
                                : 'C',
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
                              Text(caregiver.name, style: AppTypography.cardTitle),
                              const SizedBox(height: 2),
                              Text(
                                caregiver.phone != null && caregiver.phone!.isNotEmpty
                                    ? 'Primary Caregiver · ${caregiver.phone}'
                                    : 'Primary Caregiver',
                                style: AppTypography.supporting,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    DhatriPrimaryButton(
                      label: 'Call ${caregiver.name}',
                      icon: Icons.phone_rounded,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(caregiver.phone != null
                                ? 'Calling ${caregiver.name} (${caregiver.phone})...'
                                : 'Calling ${caregiver.name}...'),
                          ),
                        );
                      },
                      backgroundColor: AppColors.callGreen,
                      height: 54,
                    ),
                  ],
                ),
              )
            else
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
                        const Icon(Icons.person_search_outlined, size: 28, color: AppColors.textSecondary),
                        const SizedBox(width: 10),
                        Text('No Caregiver Linked Yet', style: AppTypography.cardTitle),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Give your 6-digit link code to your caregiver so they can link to your account and receive updates:',
                      style: AppTypography.bodyMedium,
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'YOUR LINK CODE',
                                style: AppTypography.supporting.copyWith(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                              Text(
                                auth.currentProfile.linkCode ?? '------',
                                style: AppTypography.cardTitle.copyWith(
                                  fontSize: 22,
                                  letterSpacing: 3,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                            ],
                          ),
                          TextButton.icon(
                            icon: const Icon(Icons.copy, size: 16),
                            label: const Text('Copy'),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Link code ${auth.currentProfile.linkCode} copied!'),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
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
                    label: caregiver != null
                        ? 'Something Feels Wrong — Alert ${caregiver.name}'
                        : 'Something Feels Wrong — Send Alert',
                    icon: Icons.warning_amber_rounded,
                    onPressed: () {
                      context.read<CareState>().triggerEmergencyHelp();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(caregiver != null
                              ? '🚨 Urgent alert sent to ${caregiver.name}!'
                              : '🚨 Urgent alert sent!'),
                          backgroundColor: AppColors.error,
                        ),
                      );
                    },
                    height: 52,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      );
  }
}

