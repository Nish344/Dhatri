import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../state/care_state.dart';
import '../../../state/auth_state.dart';
import '../../../models/models.dart';
import '../../components/dhatri_alert_card.dart';
import '../../components/dhatri_patient_card.dart';
import 'alert_detail_screen.dart';
import 'patient_detail_screen.dart';
import 'prescription_upload_screen.dart';
import '../../components/dhatri_role_switcher.dart';

class CaregiverHomeScreen extends StatelessWidget {
  const CaregiverHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final care = context.watch<CareState>();
    final auth = context.read<AuthState>();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Caregiver Portal', style: AppTypography.sectionTitle.copyWith(fontSize: 20)),
            Text('${auth.currentProfile.name} · Primary Caregiver', style: AppTypography.supporting.copyWith(fontSize: 12)),
          ],
        ),
        actions: [
          const DhatriRoleSwitcherButton(),
          IconButton(
            icon: const Icon(Icons.document_scanner_rounded),
            tooltip: 'Add Prescription',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PrescriptionUploadScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Triage Counter Banner (Guide §13)
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.analytics_outlined, color: AppColors.primary, size: 28),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TODAY\'S CARE OVERVIEW',
                          style: AppTypography.statusLabel.copyWith(
                            color: AppColors.primary,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '8 patients monitored · ${care.openAlerts.length} need attention',
                          style: AppTypography.cardTitle.copyWith(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // URGENT NEEDS ATTENTION SECTION
            if (care.openAlerts.isNotEmpty) ...[
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'NEEDS ATTENTION NOW',
                    style: AppTypography.statusLabel.copyWith(
                      color: AppColors.error,
                      letterSpacing: 0.8,
                    ),
                  ),
                  Text(
                    '${care.openAlerts.length} open',
                    style: AppTypography.supporting.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: care.openAlerts.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final alert = care.openAlerts[index];
                  return DhatriAlertCard(
                    alert: alert,
                    onCallPatient: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Calling ${alert.patientName} (+91 98765 43210)...'),
                          backgroundColor: AppColors.callGreen,
                        ),
                      );
                    },
                    onAcknowledge: () => care.acknowledgeAlert(alert.id),
                  );
                },
              ),
            ],

            const SizedBox(height: 28),

            // ALL PATIENTS LIST
            Text(
              'ALL MONITORED PATIENTS',
              style: AppTypography.statusLabel.copyWith(
                color: AppColors.textSecondary,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: care.overview.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final status = care.overview[index];
                return DhatriPatientCard(
                  status: status,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PatientDetailScreen(status: status),
                      ),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PrescriptionUploadScreen()),
            );
          },
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add_a_photo_rounded),
          label: const Text('Add Prescription'),
        ),
      ),
    );
  }
}

