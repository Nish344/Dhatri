import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class DhatriMemoryCard extends StatelessWidget {
  final List<String> memories;
  final String? title;

  const DhatriMemoryCard({
    super.key,
    required this.memories,
    this.title = 'What Dhatri remembered',
  });

  @override
  Widget build(BuildContext context) {
    if (memories.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB), // Warm amber background
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFDE68A), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🧠', style: TextStyle(fontSize: 22)),
              const SizedBox(width: 10),
              Text(
                title!,
                style: AppTypography.sectionTitle.copyWith(
                  fontSize: 18,
                  color: const Color(0xFF92400E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...memories.map((mem) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(fontSize: 18, color: Color(0xFFB45309))),
                    Expanded(
                      child: Text(
                        mem,
                        style: AppTypography.bodyMedium.copyWith(
                          color: const Color(0xFF78350F),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 4),
          Text(
            'Context-aware follow-up generated using Patient Memory layer.',
            style: AppTypography.supporting.copyWith(
              fontSize: 13,
              color: const Color(0xFF92400E),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

