import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../models/models.dart';
import '../../../state/care_state.dart';
import '../../../state/voice_call_state.dart';
import '../../components/dhatri_buttons.dart';
import '../../components/dhatri_status_chip.dart';
import '../../components/dhatri_memory_card.dart';
import '../../components/dhatri_timeline_item.dart';

class PatientDetailScreen extends StatefulWidget {
  final PatientStatus status;

  const PatientDetailScreen({
    super.key,
    required this.status,
  });

  @override
  State<PatientDetailScreen> createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CareState>().setActivePatientId(widget.status.patient.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final care = context.watch<CareState>();
    final status = widget.status;
    final patient = widget.status.patient;

    final memories = care.patientInsight?.latestCheck?.memoryUsed ??
        (care.patientInsight?.aiSummary != null
            ? [care.patientInsight!.aiSummary]
            : <String>['No recorded clinical memories yet.']);

    return Scaffold(
      appBar: AppBar(
        title: Text(patient.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient Header Card
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
                    radius: 32,
                    backgroundColor: AppColors.primaryLight,
                    child: Text(
                      patient.name.isNotEmpty ? patient.name.substring(0, 1) : 'P',
                      style: AppTypography.displayLarge.copyWith(
                        fontSize: 28,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          patient.name,
                          style: AppTypography.cardTitle.copyWith(fontSize: 22),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${patient.age ?? "--"} yrs · ${patient.phone ?? "No phone"}',
                          style: AppTypography.supporting,
                        ),
                        const SizedBox(height: 8),
                        DhatriStatusChip.fromPatientState(status.state),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Remote Wellness Call Trigger
            DhatriPrimaryButton(
              label: 'Initiate Wellness Call Now',
              icon: Icons.mic_rounded,
              onPressed: () {
                context.read<VoiceCallState>().triggerCheckIn(patient.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Wellness check-in call queued on Serverpod!'),
                    backgroundColor: AppColors.callGreen,
                  ),
                );
              },
              backgroundColor: AppColors.callGreen,
              height: 54,
            ),

            const SizedBox(height: 28),

            // Patient Memory Context Section
            Text(
              'DHATRI PATIENT MEMORY',
              style: AppTypography.statusLabel.copyWith(
                color: AppColors.textSecondary,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 10),
            DhatriMemoryCard(
              memories: memories,
              title: 'Longitudinal context stored by Dhatri',
            ),

            const SizedBox(height: 28),

            // Active Medications
            Text(
              'ACTIVE MEDICATIONS',
              style: AppTypography.statusLabel.copyWith(
                color: AppColors.textSecondary,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 10),
            if (care.todayDoses.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text('No active scheduled doses.', style: AppTypography.supporting),
              )
            else
              ...care.todayDoses.map((dose) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(dose.medicationName,
                                  style: AppTypography.cardTitle.copyWith(fontSize: 18)),
                              const SizedBox(height: 4),
                              Text('${dose.doseText} · ${dose.instructions}',
                                  style: AppTypography.supporting),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${dose.scheduledAt.hour.toString().padLeft(2, "0")}:${dose.scheduledAt.minute.toString().padLeft(2, "0")}',
                          style: AppTypography.statusLabel.copyWith(color: AppColors.primary),
                        ),
                      ],
                    ),
                  )),

            const SizedBox(height: 28),

            // Recent Timeline
            Text(
              'RECENT CARE TIMELINE',
              style: AppTypography.statusLabel.copyWith(
                color: AppColors.textSecondary,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 12),
            if (care.timeline.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text('No recent care events recorded.', style: AppTypography.supporting),
              )
            else
              ...care.timeline.take(4).map((item) => DhatriTimelineItemCard(item: item)),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
