import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/models.dart';
import '../../state/auth_state.dart';
import '../../state/care_state.dart';

/// Top AppBar pill button that shows current active role and opens role switcher sheet.
class DhatriRoleSwitcherButton extends StatelessWidget {
  final bool compact;

  const DhatriRoleSwitcherButton({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();

    String emoji;
    String roleLabel;
    switch (auth.activeRole) {
      case Role.patient:
        emoji = '👴';
        roleLabel = 'Patient';
        break;
      case Role.caregiver:
        emoji = '👩‍💼';
        roleLabel = 'Caregiver';
        break;
      case Role.doctor:
        emoji = '🩺';
        roleLabel = 'Doctor';
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Center(
        child: InkWell(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (ctx) => const DhatriRoleSwitcherSheet(),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 8 : 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primary.withOpacity(0.35)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 16)),
                if (!compact) ...[
                  const SizedBox(width: 6),
                  Text(
                    roleLabel,
                    style: AppTypography.supporting.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ],
                const Icon(
                  Icons.arrow_drop_down,
                  size: 18,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Modal Bottom Sheet allowing instantaneous role switching or signing out on a single device.
class DhatriRoleSwitcherSheet extends StatelessWidget {
  const DhatriRoleSwitcherSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    final care = context.watch<CareState>();

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.cardBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),

          Text(
            'Account & Role Settings',
            style: AppTypography.sectionTitle.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 4),
          Text(
            'Signed in as ${auth.currentProfile.name}',
            style: AppTypography.supporting,
          ),
          const SizedBox(height: 16),

          // Current User Profile Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primary,
                      radius: 22,
                      child: Text(
                        auth.currentProfile.name.isNotEmpty
                            ? auth.currentProfile.name[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            auth.currentProfile.name,
                            style: AppTypography.cardTitle.copyWith(fontSize: 16),
                          ),
                          Text(
                            '${auth.activeRole.name[0].toUpperCase()}${auth.activeRole.name.substring(1)}${auth.currentProfile.age != null ? ' · ${auth.currentProfile.age} yrs' : ''}',
                            style: AppTypography.supporting.copyWith(
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (auth.currentProfile.linkCode != null && auth.currentProfile.linkCode!.isNotEmpty) ...[
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Patient Link Code',
                            style: AppTypography.supporting.copyWith(fontSize: 12),
                          ),
                          Text(
                            auth.currentProfile.linkCode!,
                            style: AppTypography.cardTitle.copyWith(
                              fontSize: 20,
                              letterSpacing: 3,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ],
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.copy, size: 16),
                        label: const Text('Copy'),
                        onPressed: () {
                          // Copy link code to clipboard
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Link code ${auth.currentProfile.linkCode} copied!')),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'Switch View Mode',
            style: AppTypography.cardTitle.copyWith(fontSize: 15),
          ),
          const SizedBox(height: 10),

          // Role 1: Patient
          _roleOptionCard(
            context: context,
            role: Role.patient,
            emoji: '👴',
            name: 'Patient Portal',
            roleDescription: 'Accessible UI, Hindi voice check-ins, medication tracker',
            isSelected: auth.activeRole == Role.patient,
            onSelect: () async {
              Navigator.pop(context);
              auth.setActiveRole(Role.patient);
              await care.loadAll();
            },
          ),
          const SizedBox(height: 10),

          // Role 2: Caregiver
          _roleOptionCard(
            context: context,
            role: Role.caregiver,
            emoji: '👩‍💼',
            name: 'Caregiver Portal',
            roleDescription: 'Remote health alerts, prescription upload, patient monitoring',
            isSelected: auth.activeRole == Role.caregiver,
            onSelect: () async {
              Navigator.pop(context);
              auth.setActiveRole(Role.caregiver);
              await care.loadAll();
            },
          ),
          const SizedBox(height: 10),

          // Role 3: Doctor
          _roleOptionCard(
            context: context,
            role: Role.doctor,
            emoji: '🩺',
            name: 'Doctor Portal',
            roleDescription: 'Clinical review, longitudinal adherence and symptom timeline',
            isSelected: auth.activeRole == Role.doctor,
            onSelect: () async {
              Navigator.pop(context);
              auth.setActiveRole(Role.doctor);
              await care.loadAll();
            },
          ),
          const SizedBox(height: 20),

          // Sign Out / Switch User Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.logout_rounded, size: 20),
              label: const Text('Log Out'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.errorBorder),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () {
                auth.signOut();
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _roleOptionCard({
    required BuildContext context,
    required Role role,
    required String emoji,
    required String name,
    required String roleDescription,
    required bool isSelected,
    required VoidCallback onSelect,
  }) {
    return InkWell(
      onTap: onSelect,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primarySurface : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.cardBorder,
            width: isSelected ? 2 : 1.2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryLight : const Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: Text(emoji, style: const TextStyle(fontSize: 24)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTypography.cardTitle.copyWith(
                      fontSize: 17,
                      color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    roleDescription,
                    style: AppTypography.supporting.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 24),
              ),
          ],
        ),
      ),
    );
  }
}

