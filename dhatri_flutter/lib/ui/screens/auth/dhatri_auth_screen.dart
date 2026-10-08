import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../models/models.dart';
import '../../../services/serverpod_client_service.dart';
import '../../../state/auth_state.dart';
import '../../../state/care_state.dart';
import '../../components/dhatri_buttons.dart';
import 'onboarding_screen.dart';

class DhatriAuthScreen extends StatefulWidget {
  const DhatriAuthScreen({super.key});

  @override
  State<DhatriAuthScreen> createState() => _DhatriAuthScreenState();
}

class _DhatriAuthScreenState extends State<DhatriAuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Role _selectedEmailRole = Role.patient;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRoleLogin(Role role) async {
    setState(() => _isLoading = true);
    final auth = context.read<AuthState>();
    final care = context.read<CareState>();

    await auth.signInWithRole(role);
    await care.loadAll();
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _handleEmailLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    setState(() => _isLoading = true);
    final auth = context.read<AuthState>();
    final care = context.read<CareState>();

    final ok = await auth.signInWithEmail(email, password, _selectedEmailRole);
    if (!ok && mounted && auth.authError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed: ${auth.authError}'),
          backgroundColor: AppColors.error,
        ),
      );
    } else {
      await care.loadAll();
    }
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final clientService = context.watch<ServerpodClientService>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),

              // Dhātrī Branding Header
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text('🌿', style: TextStyle(fontSize: 40)),
              ),
              const SizedBox(height: 16),
              Text(
                'Dhātrī',
                style: AppTypography.displayLarge.copyWith(
                  fontSize: 32,
                  color: AppColors.primaryDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Intelligent AI Healthcare & Caregiver Companion',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 14),

              // Serverpod Status Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: clientService.isOnline
                      ? AppColors.successBg
                      : AppColors.warningBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: clientService.isOnline
                        ? AppColors.successBorder
                        : AppColors.warningBorder,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      clientService.isOnline
                          ? Icons.cloud_done_rounded
                          : Icons.cloud_queue_rounded,
                      size: 15,
                      color: clientService.isOnline
                          ? AppColors.success
                          : AppColors.warning,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      clientService.isOnline
                          ? 'Serverpod Backend Connected'
                          : 'Serverpod Reconnecting (${clientService.serverUrl})',
                      style: AppTypography.supporting.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: clientService.isOnline
                            ? AppColors.success
                            : AppColors.warning,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Navigation Tabs
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.textSecondary,
                  labelStyle: AppTypography.sectionTitle.copyWith(fontSize: 14),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: 'Role Access'),
                    Tab(text: 'Email Sign In'),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Tab Views
              SizedBox(
                height: 520,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildRoleAccessTab(),
                    _buildEmailSignInTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleAccessTab() {
    return Column(
      children: [
        Text(
          'Select a role to test or use on this device:',
          style: AppTypography.supporting.copyWith(fontSize: 14),
        ),
        const SizedBox(height: 16),

        // 1. Patient Portal
        _roleCard(
          emoji: '👴',
          title: 'Patient Portal',
          subtitle: 'Ramesh Kumar (72 yrs)',
          badge: 'Accessible UI · Voice Check-ins',
          description: 'Large typography, upcoming dose card, voice calls in Hindi',
          color: AppColors.primary,
          onTap: () => _handleRoleLogin(Role.patient),
        ),
        const SizedBox(height: 12),

        // 2. Caregiver Portal
        _roleCard(
          emoji: '👩‍💼',
          title: 'Caregiver Portal',
          subtitle: 'Ananya Kumar (Daughter)',
          badge: 'Triage Alerts · Rx Scanner',
          description: 'Family monitoring, prescription photo OCR, remote call trigger',
          color: const Color(0xFF0D9488), // Teal
          onTap: () => _handleRoleLogin(Role.caregiver),
        ),
        const SizedBox(height: 12),

        // 3. Doctor Portal
        _roleCard(
          emoji: '🩺',
          title: 'Doctor Portal',
          subtitle: 'Dr. Priya Sharma (Geriatrician)',
          badge: 'Clinical Review · Timeline',
          description: 'Longitudinal timeline, adherence rates, symptom frequencies',
          color: const Color(0xFF4F46E5), // Indigo
          onTap: () => _handleRoleLogin(Role.doctor),
        ),
      ],
    );
  }

  Widget _roleCard({
    required String emoji,
    required String title,
    required String subtitle,
    required String badge,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: _isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(emoji, style: const TextStyle(fontSize: 26)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: AppTypography.cardTitle.copyWith(
                            fontSize: 17,
                            color: color,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(Icons.arrow_forward_rounded, size: 18, color: color),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: AppTypography.supporting.copyWith(fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailSignInTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sign in with your registered Serverpod account:',
              style: AppTypography.supporting,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email Address',
                hintText: 'e.g. ananya@dhatri.care',
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
            const SizedBox(height: 16),
            Text('Account Role:', style: AppTypography.statusLabel),
            const SizedBox(height: 8),
            Row(
              children: [
                _roleRadioOption(Role.patient, '👴 Patient'),
                const SizedBox(width: 8),
                _roleRadioOption(Role.caregiver, '👩‍💼 Caregiver'),
                const SizedBox(width: 8),
                _roleRadioOption(Role.doctor, '🩺 Doctor'),
              ],
            ),
            const SizedBox(height: 24),
            DhatriPrimaryButton(
              label: 'Sign In with Serverpod',
              icon: Icons.login_rounded,
              onPressed: _isLoading ? null : _handleEmailLogin,
              isLoading: _isLoading,
              height: 52,
            ),
            const SizedBox(height: 14),
            Center(
              child: Text(
                'Uses Serverpod 4.0 JWT authentication',
                style: AppTypography.supporting.copyWith(fontSize: 12),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: TextButton.icon(
                icon: const Icon(Icons.person_add_outlined, size: 18),
                label: const Text('New user? Register your profile directly'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roleRadioOption(Role role, String label) {
    final isSelected = _selectedEmailRole == role;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedEmailRole = role),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primarySurface : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.cardBorder,
              width: isSelected ? 1.8 : 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

