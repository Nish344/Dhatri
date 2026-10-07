import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import 'dhatri_buttons.dart';

class DhatriEmptyState extends StatelessWidget {
  final String title;
  final String description;
  final String emoji;
  final String? actionLabel;
  final VoidCallback? onAction;

  const DhatriEmptyState({
    super.key,
    required this.title,
    required this.description,
    this.emoji = '✓',
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 40),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: AppTypography.sectionTitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              DhatriSecondaryButton(
                label: actionLabel!,
                onPressed: onAction,
                height: 48,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

