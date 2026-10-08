import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../mock_engine/mock_care_stream.dart';

class DhatriConnectionBanner extends StatelessWidget {
  final CareConnectionState state;
  final bool isLiveServerpod;
  final String? serverUrl;

  const DhatriConnectionBanner({
    super.key,
    this.state = CareConnectionState.live,
    this.isLiveServerpod = false,
    this.serverUrl,
  });

  @override
  Widget build(BuildContext context) {
    String text;
    IconData icon;
    Color color;

    if (isLiveServerpod) {
      switch (state) {
        case CareConnectionState.live:
          text = '🟢 Connected to Serverpod Backend · Real-time WebSocket Stream';
          icon = Icons.cloud_done_rounded;
          color = AppColors.success;
          break;
        case CareConnectionState.reconnecting:
          text = '🟡 Connecting to Serverpod at ${serverUrl ?? "localhost:8080"}...';
          icon = Icons.cloud_sync_rounded;
          color = AppColors.warning;
          break;
        case CareConnectionState.offline:
          text = '⚪ Serverpod Disconnected · Reconnecting stream...';
          icon = Icons.cloud_off_rounded;
          color = AppColors.textSecondary;
          break;
      }
    } else {
      switch (state) {
        case CareConnectionState.live:
          text = 'Local Demo Engine · Real-time Care Simulation';
          icon = Icons.devices_other_rounded;
          color = AppColors.info;
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
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      color: color.withOpacity(0.08),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: AppTypography.supporting.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
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
