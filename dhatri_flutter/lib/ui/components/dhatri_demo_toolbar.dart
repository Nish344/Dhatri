import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/models.dart';
import '../../state/auth_state.dart';
import '../../mock_engine/mock_care_stream.dart';
import '../../mock_engine/mock_database.dart';
import '../../state/care_state.dart';
import '../../state/voice_call_state.dart';

/// Interactive Floating Demo Toolbar designed for rapid role switching
/// and deterministic video scenario triggers.
class DhatriDemoToolbar extends StatefulWidget {
  final MockCareStream careStream;
  final MockDatabase db;

  const DhatriDemoToolbar({
    super.key,
    required this.careStream,
    required this.db,
  });

  @override
  State<DhatriDemoToolbar> createState() => _DhatriDemoToolbarState();
}

class _DhatriDemoToolbarState extends State<DhatriDemoToolbar> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    final care = context.read<CareState>();
    final voice = context.read<VoiceCallState>();

    return Positioned(
      bottom: 12,
      left: 12,
      right: 12,
      child: Material(
        elevation: 8,
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B), // Dark slate floating panel
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF334155), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top control bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text('🎬', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Text(
                        'DEMO MODE',
                        style: AppTypography.statusLabel.copyWith(
                          color: const Color(0xFF38BDF8),
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                  // Role Switcher Chips
                  Row(
                    children: [
                      _roleChip(
                        label: 'Patient',
                        role: Role.patient,
                        isSelected: auth.activeRole == Role.patient,
                        onTap: () => auth.switchToRole(Role.patient),
                      ),
                      const SizedBox(width: 6),
                      _roleChip(
                        label: 'Caregiver',
                        role: Role.caregiver,
                        isSelected: auth.activeRole == Role.caregiver,
                        onTap: () => auth.switchToRole(Role.caregiver),
                      ),
                      const SizedBox(width: 6),
                      _roleChip(
                        label: 'Doctor',
                        role: Role.doctor,
                        isSelected: auth.activeRole == Role.doctor,
                        onTap: () => auth.switchToRole(Role.doctor),
                      ),
                      const SizedBox(width: 6),
                      IconButton(
                        icon: Icon(
                          _isExpanded ? Icons.expand_more_rounded : Icons.tune_rounded,
                          color: Colors.white70,
                          size: 20,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => setState(() => _isExpanded = !_isExpanded),
                      ),
                    ],
                  ),
                ],
              ),
              // Expandable Event Trigger Actions
              if (_isExpanded) ...[
                const Divider(color: Color(0xFF334155), height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _actionPill(
                      label: '🚨 Trigger Missed Dose',
                      color: const Color(0xFFEF4444),
                      onTap: () {
                        widget.careStream.triggerMissedDoseEscalation();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Missed dose escalated -> Caregiver Alert pushed!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                    _actionPill(
                      label: '📞 Ring Care Call',
                      color: const Color(0xFF10B981),
                      onTap: () {
                        widget.careStream.triggerIncomingCall();
                        if (widget.db.wellnessChecks.isNotEmpty) {
                          voice.receiveIncomingCall(widget.db.wellnessChecks.first);
                        }
                        auth.switchToRole(Role.patient);
                      },
                    ),
                    _actionPill(
                      label: '↺ Reset Data',
                      color: const Color(0xFF94A3B8),
                      onTap: () {
                        widget.db.resetToInitial();
                        care.loadAll();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Initial 7-day demo data restored!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _roleChip({
    required String label,
    required Role role,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0284C7) : const Color(0xFF334155),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _actionPill({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.18),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.6), width: 1),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

