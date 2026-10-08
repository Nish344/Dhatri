import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../models/models.dart';
import '../../../repositories/dhatri_repository.dart';
import '../../../state/care_state.dart';
import '../../components/dhatri_buttons.dart';

class PrescriptionReviewScreen extends StatefulWidget {
  final int? prescriptionId;
  final List<MedicationDraft>? initialDrafts;

  const PrescriptionReviewScreen({
    super.key,
    this.prescriptionId,
    this.initialDrafts,
  });

  @override
  State<PrescriptionReviewScreen> createState() => _PrescriptionReviewScreenState();
}

class _PrescriptionReviewScreenState extends State<PrescriptionReviewScreen> {
  late List<MedicationDraft> _drafts;
  bool _isConfirming = false;

  @override
  void initState() {
    super.initState();
    _drafts = widget.initialDrafts != null && widget.initialDrafts!.isNotEmpty
        ? List.from(widget.initialDrafts!)
        : [
            MedicationDraft(
              name: 'Metformin',
              strength: '500 mg',
              doseText: '1 tablet',
              instructions: 'After dinner with water',
              times: ['08:00', '20:00'],
              durationDays: 30,
              uncertain: false,
            ),
            MedicationDraft(
              name: 'Amlodipine',
              strength: '5 mg',
              doseText: '1 tablet',
              instructions: 'Morning with water',
              times: ['08:00'],
              durationDays: 30,
              uncertain: true,
            ),
          ];
  }

  void _showEditSheet(int index) {
    final draft = _drafts[index];
    final nameController = TextEditingController(text: draft.name);
    final strengthController = TextEditingController(text: draft.strength ?? '');
    final instructionsController = TextEditingController(text: draft.instructions ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Edit Medicine Schedule', style: AppTypography.sectionTitle),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
                    tooltip: 'Remove',
                    onPressed: () {
                      setState(() => _drafts.removeAt(index));
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Medicine Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: strengthController,
                decoration: const InputDecoration(
                  labelText: 'Strength (e.g. 500 mg)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: instructionsController,
                decoration: const InputDecoration(
                  labelText: 'Instructions (e.g. After meals)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              DhatriPrimaryButton(
                label: 'Save Changes',
                onPressed: () {
                  setState(() {
                    draft.name = nameController.text;
                    draft.strength = strengthController.text;
                    draft.instructions = instructionsController.text;
                    draft.uncertain = false; // Resolved by human review!
                  });
                  Navigator.pop(context);
                },
                height: 54,
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddSheet() {
    final nameController = TextEditingController();
    final strengthController = TextEditingController();
    final instructionsController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add Medicine to Schedule', style: AppTypography.sectionTitle),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Medicine Name',
                  hintText: 'e.g. Atorvastatin',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: strengthController,
                decoration: const InputDecoration(
                  labelText: 'Strength',
                  hintText: 'e.g. 20 mg',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: instructionsController,
                decoration: const InputDecoration(
                  labelText: 'Instructions',
                  hintText: 'e.g. At bedtime with water',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              DhatriPrimaryButton(
                label: 'Add to Schedule',
                onPressed: () {
                  if (nameController.text.trim().isNotEmpty) {
                    setState(() {
                      _drafts.add(
                        MedicationDraft(
                          name: nameController.text.trim(),
                          strength: strengthController.text.trim().isNotEmpty
                              ? strengthController.text.trim()
                              : null,
                          doseText: '1 tablet',
                          instructions: instructionsController.text.trim().isNotEmpty
                              ? instructionsController.text.trim()
                              : 'With water',
                          times: ['22:00'],
                          durationDays: 30,
                          uncertain: false,
                        ),
                      );
                    });
                  }
                  Navigator.pop(context);
                },
                height: 54,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirm() async {
    setState(() => _isConfirming = true);
    final repo = context.read<DhatriRepository>();
    final care = context.read<CareState>();

    await repo.confirmPrescription(widget.prescriptionId ?? 1, _drafts);
    await care.loadAll();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✓ Prescription confirmed! Dose events activated.'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Schedule'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mandatory Human-in-the-Loop Safety Banner (Guide §16, Arch §7)
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7), // Amber background
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF59E0B), width: 1.5),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.verified_user_rounded, color: Color(0xFFB45309), size: 26),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI-Assisted Schedule Review',
                          style: AppTypography.cardTitle.copyWith(
                            fontSize: 17,
                            color: const Color(0xFF92400E),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Dhatri extracted this schedule from the photo. Please verify before activating.',
                          style: AppTypography.bodyMedium.copyWith(
                            color: const Color(0xFF78350F),
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Draft Medication Cards
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _drafts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final draft = _drafts[index];
                return Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: draft.uncertain ? AppColors.warning : AppColors.cardBorder,
                      width: draft.uncertain ? 2 : 1.2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${draft.name} ${draft.strength ?? ""}',
                              style: AppTypography.cardTitle.copyWith(fontSize: 19),
                            ),
                          ),
                          TextButton.icon(
                            icon: const Icon(Icons.edit_outlined, size: 18),
                            label: const Text('EDIT'),
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              visualDensity: VisualDensity.compact,
                            ),
                            onPressed: () => _showEditSheet(index),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${draft.doseText} · ${draft.times.length} times/day (${draft.times.join(", ")})',
                        style: AppTypography.bodyMedium,
                      ),
                      Text(
                        draft.instructions ?? 'As directed',
                        style: AppTypography.supporting,
                      ),
                      if (draft.uncertain) ...[
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.warningBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '⚠ Please check bedtime timing and strength',
                            style: AppTypography.statusLabel.copyWith(
                              fontSize: 12,
                              color: AppColors.warning,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 14),

            DhatriSecondaryButton(
              label: 'Add Another Medicine',
              icon: Icons.add_circle_outline_rounded,
              onPressed: _showAddSheet,
              height: 48,
            ),

            const SizedBox(height: 24),

            DhatriPrimaryButton(
              label: 'Confirm & Activate Schedule',
              icon: Icons.check_circle_outline_rounded,
              onPressed: _isConfirming ? null : _confirm,
              isLoading: _isConfirming,
              height: 58,
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

