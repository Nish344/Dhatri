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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Today\'s Medicines'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your daily prescription schedule',
              style: AppTypography.supporting,
            ),
            const SizedBox(height: 20),
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
      ),
    );
  }
}

