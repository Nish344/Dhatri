import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../mock_engine/mock_care_stream.dart';

class DhatriConnectionBanner extends StatelessWidget {
  final CareConnectionState state;

  const DhatriConnectionBanner({
    super.key,
    this.state = CareConnectionState.live,
  });

  @override
  Widget build(BuildContext context) {
    String text;
    IconData icon;
    Color color;

    switch (state) {
      case CareConnectionState.live:
        text = 'Live Care Stream · Updated just now';
        icon = Icons.wifi_rounded;
        color = AppColors.success;
        break;
      case CareConnectionState.reconnecting:
        text = 'Reconnecting care stream...';
        icon = Icons.wifi_find_rounded;
        color = AppColors.warning;
        break;
      case CareConnectionState.offline:
        text = 'Offline — showing last known state';
        icon = Icons.wifi_off_rounded;
        color = AppColors.textSecondary;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      color: color.withOpacity(0.08),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 8),
          Text(
            text,
            style: AppTypography.supporting.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

