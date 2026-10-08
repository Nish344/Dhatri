import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/models.dart';
import '../../services/serverpod_client_service.dart';
import '../../state/auth_state.dart';
import '../../state/care_state.dart';
import '../../state/voice_call_state.dart';

/// Floating interactive demo controller bar for 2-minute hackathon video recording & evaluation.
/// Enables role switching and triggering Serverpod care events on the fly.
class DhatriDemoController extends StatefulWidget {
  const DhatriDemoController({super.key});

  @override
  State<DhatriDemoController> createState() => _DhatriDemoControllerState();
}

class _DhatriDemoControllerState extends State<DhatriDemoController> {
  bool _isExpanded = false;
  bool _isActionRunning = false;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    final care = context.watch<CareState>();
    final voice = context.watch<VoiceCallState>();
    final clientService = context.watch<ServerpodClientService>();

    if (!_isExpanded) {
      return Positioned(
        bottom: 16,
        right: 16,
        child: FloatingActionButton.small(
          heroTag: 'demo_controller_toggle',
          backgroundColor: const Color(0xFF0F172A),
          foregroundColor: const Color(0xFF38BDF8),
          tooltip: 'Demo Event Controller',
          onPressed: () => setState(() => _isExpanded = true),
          child: const Icon(Icons.tune_rounded, size: 20),
        ),
      );
    }

    return Positioned(
      bottom: 12,
      left: 12,
      right: 12,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFF0F172A), // Dark slate floating HUD
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF334155), width: 1.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // HUD Header & Collapse Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF38BDF8).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'DEMO HUD',
                          style: AppTypography.statusLabel.copyWith(
                            color: const Color(0xFF38BDF8),
                            fontSize: 10,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Active: ${auth.activeRole.name.toUpperCase()}',
                        style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 18, color: Colors.white54),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => setState(() => _isExpanded = false),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Role Tabs
              Row(
                children: [
                  _roleButton(
                    label: '👴 Patient',
                    isSelected: auth.activeRole == Role.patient,
                    onTap: () {
                      auth.switchToRole(Role.patient);
                      care.loadAll();
                    },
                  ),
                  const SizedBox(width: 6),
                  _roleButton(
                    label: '👩‍💼 Caregiver',
                    isSelected: auth.activeRole == Role.caregiver,
                    onTap: () {
                      auth.switchToRole(Role.caregiver);
                      care.loadAll();
                    },
                  ),
                  const SizedBox(width: 6),
                  _roleButton(
                    label: '🩺 Doctor',
                    isSelected: auth.activeRole == Role.doctor,
                    onTap: () {
                      auth.switchToRole(Role.doctor);
                      care.loadAll();
                    },
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Action Trigger Chips
              Row(
                children: [
                  // 1. Ring Care Call
                  Expanded(
                    child: _actionButton(
                      icon: Icons.ring_volume_rounded,
                      label: 'Ring Call',
                      color: AppColors.callGreen,
                      onTap: _isActionRunning
                          ? null
                          : () async {
                              setState(() => _isActionRunning = true);
                              await voice.triggerCheckIn(care.activePatientId);
                              if (mounted) {
                                setState(() => _isActionRunning = false);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('📞 Wellness call triggered on Serverpod!'),
                                    backgroundColor: AppColors.callGreen,
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                    ),
                  ),
                  const SizedBox(width: 6),

                  // 2. Simulate Missed Dose / Urgent Alert
                  Expanded(
                    child: _actionButton(
                      icon: Icons.notification_important_rounded,
                      label: 'Miss Dose',
                      color: const Color(0xFFEF4444),
                      onTap: _isActionRunning
                          ? null
                          : () async {
                              setState(() => _isActionRunning = true);
                              await care.triggerEmergencyHelp();
                              await care.loadAll();
                              if (mounted) {
                                setState(() => _isActionRunning = false);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('🚨 Urgent alert escalated to Caregiver!'),
                                    backgroundColor: AppColors.error,
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                    ),
                  ),
                  const SizedBox(width: 6),

                  // 3. Reset / Seed Demo
                  Expanded(
                    child: _actionButton(
                      icon: Icons.restart_alt_rounded,
                      label: 'Reset Seed',
                      color: const Color(0xFFF59E0B),
                      onTap: _isActionRunning
                          ? null
                          : () async {
                              setState(() => _isActionRunning = true);
                              final ok = await clientService.seedDemoData();
                              await care.loadAll();
                              if (mounted) {
                                setState(() => _isActionRunning = false);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(ok ? '✓ 7-Day Ramesh Kumar dataset reset!' : 'Reset failed. Backend online?'),
                                    backgroundColor: ok ? AppColors.success : AppColors.error,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
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

  Widget _roleButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF38BDF8).withOpacity(0.2) : const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? const Color(0xFF38BDF8) : const Color(0xFF334155),
              width: 1.2,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? Colors.white : Colors.white60,
            ),
          ),
        ),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color.withOpacity(0.18),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.6), width: 1.2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

