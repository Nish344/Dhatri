import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../state/care_state.dart';
import '../../components/dhatri_insight_card.dart';
import '../../components/dhatri_timeline_item.dart';

class DoctorDashboardScreen extends StatelessWidget {
  const DoctorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final care = context.watch<CareState>();
    final insight = care.patientInsight;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Doctor Clinical Portal', style: AppTypography.pageTitle.copyWith(fontSize: 22)),
            Text('Dr. Priya Sharma · Geriatric Medicine', style: AppTypography.supporting.copyWith(fontSize: 13)),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.lock_outline_rounded, size: 14, color: AppColors.primary),
                const SizedBox(width: 4),
                Text(
                  'Read-Only',
                  style: AppTypography.supporting.copyWith(fontSize: 12, color: AppColors.primary),
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
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.warningBorder, width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Weakness', style: AppTypography.cardTitle.copyWith(fontSize: 18)),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Text('3', style: AppTypography.displayLarge.copyWith(fontSize: 26, color: AppColors.warning)),
                            const SizedBox(width: 8),
                            Text('reports\n(Max severity 3/5)', style: AppTypography.supporting.copyWith(fontSize: 11)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Dizziness', style: AppTypography.cardTitle.copyWith(fontSize: 18)),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Text('1', style: AppTypography.displayLarge.copyWith(fontSize: 26, color: AppColors.info)),
                            const SizedBox(width: 8),
                            Text('report\n(Severity 2/5)', style: AppTypography.supporting.copyWith(fontSize: 11)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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

