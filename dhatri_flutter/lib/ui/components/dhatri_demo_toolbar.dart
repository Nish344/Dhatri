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
import '../../services/serverpod_client_service.dart';
import '../../repositories/hybrid_dhatri_repository.dart';

/// Interactive Floating Demo Toolbar designed for rapid role switching,
/// live Serverpod backend connection status, and deterministic scenario triggers.
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

  void _showServerSettings(BuildContext context) {
    final clientService = context.read<ServerpodClientService>();
    final hybridRepo = context.read<HybridDhatriRepository>();
    final urlController = TextEditingController(text: clientService.serverUrl);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            final isOnline = clientService.isOnline;
            final isChecking = clientService.isChecking;

            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 28,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Serverpod Backend Settings',
                        style: AppTypography.cardTitle.copyWith(color: Colors.white),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isOnline ? AppColors.successBg : AppColors.warningBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isOnline ? '● Online' : '○ Offline',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isOnline ? AppColors.success : AppColors.warning,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Server Endpoint URL:',
                    style: AppTypography.supporting.copyWith(color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: urlController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF0F172A),
                      hintText: 'http://localhost:8080/',
                      hintStyle: const TextStyle(color: Colors.white38),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFF334155)),
                      ),
                      suffixIcon: IconButton(
                        icon: isChecking
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.refresh_rounded, color: Colors.white70),
                        onPressed: () async {
                          await clientService.updateServerUrl(urlController.text.trim());
                          setSheetState(() {});
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Tip: Use http://localhost:8080/ on Linux/Web, http://10.0.2.2:8080/ on Android emulator, or your computer\'s Wi-Fi IP on physical phones.',
                    style: AppTypography.supporting.copyWith(fontSize: 11, color: Colors.white54),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            setSheetState(() {});
                            final ok = await clientService.seedDemoData();
                            if (ctx.mounted) {
                              ScaffoldMessenger.of(ctx).showSnackBar(
                                SnackBar(
                                  content: Text(ok
                                      ? '✓ Seeded 7-day Ramesh Kumar history on Serverpod!'
                                      : 'Failed to seed Serverpod: ${clientService.lastError ?? "server unreachable"}'),
                                  backgroundColor: ok ? AppColors.success : AppColors.error,
                                ),
                              );
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Color(0xFF38BDF8)),
                          ),
                          child: const Text('🌱 Seed Serverpod DB'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            setSheetState(() {});
                            final ok = await clientService.resetDemoData();
                            if (ctx.mounted) {
                              ScaffoldMessenger.of(ctx).showSnackBar(
                                SnackBar(
                                  content: Text(ok
                                      ? '✓ Reset Serverpod demo dataset!'
                                      : 'Failed to reset: ${clientService.lastError ?? "server unreachable"}'),
                                  backgroundColor: ok ? AppColors.success : AppColors.error,
                                ),
                              );
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Color(0xFF94A3B8)),
                          ),
                          child: const Text('↺ Reset Serverpod'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: const Text('Force Local Mock Mode', style: TextStyle(color: Colors.white, fontSize: 14)),
                    subtitle: const Text('Bypass Serverpod calls and use local simulated data', style: TextStyle(color: Colors.white54, fontSize: 12)),
                    value: hybridRepo.forceMock,
                    onChanged: (val) {
                      hybridRepo.toggleForceMock(val);
                      setSheetState(() {});
                    },
                    activeColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    final care = context.read<CareState>();
    final voice = context.read<VoiceCallState>();
    final clientService = context.watch<ServerpodClientService>();
    final hybridRepo = context.watch<HybridDhatriRepository>();

    final isLive = hybridRepo.isLiveBackend;

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
              Row(
                children: [
                  InkWell(
                    onTap: () => _showServerSettings(context),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isLive ? const Color(0xFF065F46) : const Color(0xFF78350F),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Text(isLive ? '🟢' : '🟡', style: const TextStyle(fontSize: 10)),
                          const SizedBox(width: 4),
                          Text(
                            isLive ? 'LIVE BE' : 'MOCK',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
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
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
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
              // Expandable Event Trigger Actions
              if (_isExpanded) ...[
                const Divider(color: Color(0xFF334155), height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _actionPill(
                      label: '⚙ Server Settings',
                      color: const Color(0xFF38BDF8),
                      onTap: () => _showServerSettings(context),
                    ),
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
