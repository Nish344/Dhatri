import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_typography.dart';
import '../../../state/care_state.dart';
import '../../components/dhatri_medication_card.dart';

class PatientMedicinesScreen extends StatelessWidget {
  const PatientMedicinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final care = context.watch<CareState>();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your daily prescription schedule',
            style: AppTypography.supporting,
          ),
          const SizedBox(height: 20),
          if (care.todayDoses.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  const Icon(Icons.medication_outlined, size: 48, color: Color(0xFF94A3B8)),
                  const SizedBox(height: 12),
                  Text(
                    'No active medicines scheduled',
                    style: AppTypography.cardTitle.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'When prescriptions are uploaded and confirmed, your medicines and reminder timings will be listed here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                  ),
                ],
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: care.todayDoses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final dose = care.todayDoses[index];
                return DhatriMedicationCard(
                  dose: dose,
                  isDominantNextDose: false,
                  optimisticStatus: care.getOptimisticStatus(dose.id),
                  onTakeNow: () => care.markTaken(dose.id),
                );
              },
            ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

