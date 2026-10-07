import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/models.dart';
import 'dhatri_status_chip.dart';

class DhatriPatientCard extends StatelessWidget {
  final PatientStatus status;
  final VoidCallback onTap;

  const DhatriPatientCard({
    super.key,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder, width: 1.2),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: AppColors.primaryLight,
              child: Text(
                status.patient.name.substring(0, 1),
                style: AppTypography.sectionTitle.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${status.patient.name}${status.patient.age != null ? ' · ${status.patient.age}' : ''}',
                        style: AppTypography.cardTitle,
                      ),
                      DhatriStatusChip.fromPatientState(status.state),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    status.headline,
                    style: AppTypography.supporting,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

