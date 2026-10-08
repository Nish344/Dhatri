import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class DhatriConnectionBanner extends StatelessWidget {
  final bool isOnline;
  final String? serverUrl;

  const DhatriConnectionBanner({
    super.key,
    required this.isOnline,
    this.serverUrl,
  });

  @override
  Widget build(BuildContext context) {
    if (isOnline) {
      // In production, when connected cleanly, no intrusive banner is needed
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppColors.warning.withOpacity(0.12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cloud_sync_rounded, size: 16, color: AppColors.warning),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              'Connecting to Serverpod backend at ${serverUrl ?? "localhost:8080"}...',
              style: AppTypography.supporting.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.warning,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
