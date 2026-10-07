import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/date_formatter.dart';
import '../../models/models.dart';

class DhatriTimelineItemCard extends StatelessWidget {
  final TimelineItem item;
  final bool isLast;

  const DhatriTimelineItemCard({
    super.key,
    required this.item,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color iconColor;
    Color bgColor;

    switch (item.tone) {
      case TimelineTone.good:
        icon = Icons.check_circle_rounded;
        iconColor = AppColors.success;
        bgColor = AppColors.successBg;
        break;
      case TimelineTone.warning:
        icon = Icons.warning_amber_rounded;
        iconColor = AppColors.warning;
        bgColor = AppColors.warningBg;
        break;
      case TimelineTone.missed:
        icon = Icons.cancel_rounded;
        iconColor = AppColors.error;
        bgColor = AppColors.errorBg;
        break;
      case TimelineTone.neutral:
        icon = Icons.health_and_safety_rounded;
        iconColor = AppColors.info;
        bgColor = AppColors.infoBg;
        break;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator line
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: iconColor, width: 2),
                ),
                child: Icon(icon, size: 20, color: iconColor),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2.5,
                    color: AppColors.cardBorder,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Content Card
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorder, width: 1.2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            item.title,
                            style: AppTypography.cardTitle.copyWith(fontSize: 17),
                          ),
                        ),
                        Text(
                          DateFormatter.relativeDay(item.at),
                          style: AppTypography.supporting.copyWith(fontSize: 13),
                        ),
                      ],
                    ),
                    if (item.detail != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        item.detail!,
                        style: AppTypography.bodyMedium,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

