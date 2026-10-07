import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/models.dart';

class DhatriInsightCard extends StatelessWidget {
  final PatientInsight insight;

  const DhatriInsightCard({
    super.key,
    required this.insight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('✨', style: TextStyle(fontSize: 22)),
                  const SizedBox(width: 8),
                  Text(
                    'AI CARE SUMMARY',
                    style: AppTypography.statusLabel.copyWith(
                      color: AppColors.primary,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              if (insight.reviewRecommended)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.warningBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.warningBorder),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.warning_amber_rounded, size: 14, color: AppColors.warning),
                      const SizedBox(width: 4),
                      Text(
                        'Review Recommended',
                        style: AppTypography.statusLabel.copyWith(
                          fontSize: 11,
                          color: AppColors.warning,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            insight.aiSummary,
            style: AppTypography.bodyLarge.copyWith(height: 1.5),
          ),
          const SizedBox(height: 18),
          const Divider(height: 1),
          const SizedBox(height: 16),
          // Clinical Key Indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _metricColumn(
                label: 'Adherence',
                value: '${insight.adherencePct ?? 0}%',
                change: '↓ from ${insight.prevAdherencePct ?? 0}%',
                changeColor: AppColors.error,
              ),
              Container(width: 1, height: 40, color: AppColors.divider),
              _metricColumn(
                label: 'Missed Doses',
                value: '${insight.dosesMissed}',
                change: 'this week',
                changeColor: AppColors.warning,
              ),
              Container(width: 1, height: 40, color: AppColors.divider),
              _metricColumn(
                label: 'Check-ins',
                value: '${insight.checkIns}',
                change: 'completed',
                changeColor: AppColors.success,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metricColumn({
    required String label,
    required String value,
    required String change,
    required Color changeColor,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.displayLarge.copyWith(fontSize: 26),
        ),
        Text(
          label,
          style: AppTypography.supporting.copyWith(fontSize: 13),
        ),
        Text(
          change,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: changeColor,
          ),
        ),
      ],
    );
  }
}

