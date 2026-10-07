import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../state/voice_call_state.dart';
import '../../components/dhatri_buttons.dart';

class IncomingCallScreen extends StatelessWidget {
  final VoidCallback onAnswer;
  final VoidCallback onDecline;

  const IncomingCallScreen({
    super.key,
    required this.onAnswer,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Dark slate telephony backdrop
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Caller Info
              Column(
                children: [
                  const SizedBox(height: 30),
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                      border: Border.all(color: Colors.white24, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.5),
                          blurRadius: 30,
                          spreadRadius: 8,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Text('🌿', style: TextStyle(fontSize: 48)),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Dhātrī',
                    style: AppTypography.displayLarge.copyWith(
                      color: Colors.white,
                      fontSize: 34,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your Care Companion',
                    style: AppTypography.bodyLarge.copyWith(
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '📞 Incoming Daily Health Call',
                      style: AppTypography.statusLabel.copyWith(
                        color: const Color(0xFF38BDF8),
                      ),
                    ),
                  ),
                ],
              ),

              // Action Buttons
              Column(
                children: [
                  DhatriCallButton(
                    label: 'ANSWER',
                    onPressed: onAnswer,
                    icon: Icons.call,
                    color: AppColors.callGreen,
                  ),
                  const SizedBox(height: 18),
                  TextButton(
                    onPressed: onDecline,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white70,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: Text(
                      'Remind me later (15 min)',
                      style: AppTypography.supporting.copyWith(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

