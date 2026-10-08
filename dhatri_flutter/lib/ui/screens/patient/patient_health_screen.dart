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

