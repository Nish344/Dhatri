import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../repositories/dhatri_repository.dart';
import '../../../state/care_state.dart';
import '../../../state/auth_state.dart';
import '../../components/dhatri_insight_card.dart';
import '../../components/dhatri_timeline_item.dart';

class DoctorDashboardScreen extends StatelessWidget {
  const DoctorDashboardScreen({super.key});

  void _showLinkPatientDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Link Patient with Code'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter the 6-digit link code shown on the patient\'s profile or settings screen.',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: '6-digit Link Code',
                hintText: 'e.g. 482910',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final code = controller.text.trim();
              if (code.isEmpty) return;
              Navigator.pop(ctx);
              try {
                final repo = context.read<DhatriRepository>();
                final care = context.read<CareState>();
                final linked = await repo.linkWithCode(code);
                // Select the linked patient explicitly so insight loads even if
                // overview was empty before this link.
                if (linked.id > 0 && care.activePatientId != linked.id) {
                  care.setActivePatientId(linked.id);
                } else {
                  await care.loadAll();
                }
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '✓ Successfully linked with ${linked.name}!',
                      ),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to link patient: $e'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              }
            },
            child: const Text('Link Patient'),
          ),
        ],
      ),
    ).whenComplete(controller.dispose);
  }

  @override
  Widget build(BuildContext context) {
    final care = context.watch<CareState>();
    final auth = context.watch<AuthState>();
    final insight = care.patientInsight;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Clinical Portal',
              style: AppTypography.sectionTitle.copyWith(fontSize: 20),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '${auth.currentProfile.name} · Geriatric Medicine',
              style: AppTypography.supporting.copyWith(fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_rounded),
            tooltip: 'Link Patient with Code',
            onPressed: () => _showLinkPatientDialog(context),
          ),
          Container(
            margin: const EdgeInsets.only(right: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.lock_outline_rounded,
                  size: 13,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  'Read-Only',
                  style: AppTypography.supporting.copyWith(
                    fontSize: 11,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Log Out',
            onPressed: () => auth.signOut(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: insight == null
            ? Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 48,
                  horizontal: 24,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.people_alt_outlined,
                      size: 56,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No Patient Records Loaded',
                      style: AppTypography.cardTitle.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Link a patient with their 6-digit code to see clinical insights, symptom logs, and longitudinal timelines.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add_link),
                      label: const Text('Link Patient'),
                      onPressed: () => _showLinkPatientDialog(context),
                    ),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Patient Header Banner
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.cardBorder,
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: AppColors.primaryLight,
                          child: Text(
                            insight.patient.name.isNotEmpty
                                ? insight.patient.name[0].toUpperCase()
                                : 'P',
                            style: AppTypography.displayLarge.copyWith(
                              fontSize: 24,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${insight.patient.name}${insight.patient.age != null ? " · ${insight.patient.age} yrs" : ""}',
                                style: AppTypography.cardTitle.copyWith(
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                insight.patient.phone != null &&
                                        insight.patient.phone!.isNotEmpty
                                    ? 'Contact: ${insight.patient.phone}'
                                    : 'Patient Record ID #${insight.patient.id}',
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
                  if (insight.symptoms.isNotEmpty)
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: insight.symptoms.map((sym) {
                        final isSevere = sym.maxSeverity >= 4;
                        final isRepeated = sym.count >= 3;
                        final accentColor = isSevere
                            ? AppColors.error
                            : (isRepeated ? AppColors.warning : AppColors.info);
                        final borderColor = isSevere
                            ? AppColors.errorBorder
                            : (isRepeated
                                  ? AppColors.warningBorder
                                  : AppColors.cardBorder);

                        return Container(
                          width: (MediaQuery.of(context).size.width - 52) / 2,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: borderColor, width: 1.5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                sym.symptom.isNotEmpty
                                    ? sym.symptom[0].toUpperCase() +
                                          sym.symptom.substring(1)
                                    : 'Symptom',
                                style: AppTypography.cardTitle.copyWith(
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Text(
                                    '${sym.count}',
                                    style: AppTypography.displayLarge.copyWith(
                                      fontSize: 26,
                                      color: accentColor,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'report${sym.count > 1 ? "s" : ""}\n(Max severity ${sym.maxSeverity}/5)',
                                      style: AppTypography.supporting.copyWith(
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    )
                  else
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Text(
                        'No recurring symptoms reported this week.',
                        style: AppTypography.supporting,
                      ),
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
