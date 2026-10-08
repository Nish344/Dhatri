import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../state/care_state.dart';
import '../../../state/auth_state.dart';
import '../../components/dhatri_insight_card.dart';
import '../../components/dhatri_timeline_item.dart';
import '../../components/dhatri_role_switcher.dart';

class DoctorDashboardScreen extends StatelessWidget {
  const DoctorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final care = context.watch<CareState>();
    final auth = context.watch<AuthState>();
    final insight = care.patientInsight;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Clinical Portal', style: AppTypography.sectionTitle.copyWith(fontSize: 20)),
            Text('${auth.currentProfile.name} · Geriatric Medicine', style: AppTypography.supporting.copyWith(fontSize: 12)),
          ],
        ),
        actions: [
          const DhatriRoleSwitcherButton(),
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline_rounded, size: 13, color: AppColors.primary),
                const SizedBox(width: 4),
                Text(
                  'Read-Only',
                  style: AppTypography.supporting.copyWith(
                    fontSize: 11,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient Header Banner
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
                    radius: 28,
                    backgroundColor: AppColors.primaryLight,
                    child: Text(
                      'R',
                      style: AppTypography.displayLarge.copyWith(fontSize: 24, color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ramesh Kumar · 72', style: AppTypography.cardTitle.copyWith(fontSize: 20)),
                        const SizedBox(height: 2),
                        Text(
                          'Type-2 Diabetes & Hypertension · Monitored since Oct 2026',
                          style: AppTypography.supporting,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // AI Clinical Summary Card (Guide §14, §25)
            if (insight != null)
              DhatriInsightCard(insight: insight),

            const SizedBox(height: 28),

            // Recurring Symptoms Frequency Count (Architecture §7)
            Text(
              'SYMPTOM FREQUENCY (LAST 7 DAYS)',
              style: AppTypography.statusLabel.copyWith(
                color: AppColors.textSecondary,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 12),
            if (insight != null && insight.symptoms.isNotEmpty)
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: insight.symptoms.map((sym) {
                  final isSevere = sym.maxSeverity >= 4;
                  final isRepeated = sym.count >= 3;
                  final accentColor = isSevere
                      ? AppColors.error
                      : (isRepeated ? AppColors.warning : AppColors.info);
                  final borderColor = isSevere
                      ? AppColors.errorBorder
                      : (isRepeated ? AppColors.warningBorder : AppColors.cardBorder);

                  return Container(
                    width: (MediaQuery.of(context).size.width - 52) / 2,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderColor, width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sym.symptom.isNotEmpty
                              ? sym.symptom[0].toUpperCase() + sym.symptom.substring(1)
                              : 'Symptom',
                          style: AppTypography.cardTitle.copyWith(fontSize: 18),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              '${sym.count}',
                              style: AppTypography.displayLarge.copyWith(
                                fontSize: 26,
                                color: accentColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'report${sym.count > 1 ? "s" : ""}\n(Max severity ${sym.maxSeverity}/5)',
                                style: AppTypography.supporting.copyWith(fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Text(
                  'No recurring symptoms reported this week.',
                  style: AppTypography.supporting,
                ),
              ),

            const SizedBox(height: 28),

            // Longitudinal Clinical Timeline
            Text(
              'LONGITUDINAL PATIENT TIMELINE',
              style: AppTypography.statusLabel.copyWith(
                color: AppColors.textSecondary,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: care.timeline.length,
              itemBuilder: (context, index) {
                final item = care.timeline[index];
                return DhatriTimelineItemCard(
                  item: item,
                  isLast: index == care.timeline.length - 1,
                );
              },
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

