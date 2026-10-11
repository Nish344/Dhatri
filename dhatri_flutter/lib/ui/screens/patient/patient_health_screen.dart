import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_typography.dart';
import '../../../state/care_state.dart';
import '../../components/dhatri_timeline_item.dart';

class PatientHealthScreen extends StatelessWidget {
  final bool showAppBar;

  const PatientHealthScreen({super.key, this.showAppBar = false});

  @override
  Widget build(BuildContext context) {
    final care = context.watch<CareState>();

    final content = SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your daily doses and wellness check-in records',
            style: AppTypography.supporting,
          ),
          const SizedBox(height: 24),
          if (care.timeline.isEmpty)
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
                  const Icon(Icons.history_rounded, size: 48, color: Color(0xFF94A3B8)),
                  const SizedBox(height: 12),
                  Text(
                    'No health events recorded yet',
                    style: AppTypography.cardTitle.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'As doses are confirmed and wellness check-ins are completed, your health journey will appear here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                  ),
                ],
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: care.timeline.length,
              itemBuilder: (context, index) {
                final item = care.timeline[index];
                final isLast = index == care.timeline.length - 1;
                return DhatriTimelineItemCard(
                  item: item,
                  isLast: isLast,
                );
              },
            ),
          const SizedBox(height: 80),
        ],
      ),
    );

    if (showAppBar) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Health Timeline'),
        ),
        body: content,
      );
    }

    return content;
  }
}

