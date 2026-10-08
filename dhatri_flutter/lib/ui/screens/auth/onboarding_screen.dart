import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../models/models.dart';
import '../../../state/auth_state.dart';
import '../../../state/care_state.dart';
import '../../components/dhatri_buttons.dart';

/// Onboarding screen for new users who registered an account via Serverpod Email IDP
/// but have not yet completed their clinical Profile record.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();
  Role _selectedRole = Role.patient;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleCompleteOnboarding() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final auth = context.read<AuthState>();
    final care = context.read<CareState>();

    final name = _nameController.text.trim();
    final age = int.tryParse(_ageController.text.trim());
    final phone = _phoneController.text.trim();

    final success = await auth.registerProfile(
      name: name,
      role: _selectedRole,
      age: age,
      phone: phone.isNotEmpty ? phone : null,
    );

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        await care.loadAll();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✓ Profile created for $name! Welcome to Dhātrī.'),
            backgroundColor: AppColors.success,
          ),
        );
      } else {
        setState(() {
          _errorMessage = auth.authError ?? 'Failed to register profile. Please try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () {
              context.read<AuthState>().skipOnboardingWithDefault();
            },
            child: const Text('Skip for Demo'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Banner
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text('🌿', style: TextStyle(fontSize: 28)),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome to Dhātrī',
                              style: AppTypography.cardTitle.copyWith(fontSize: 18),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Please set up your profile to activate customized voice check-ins & care tracking.',
                              style: AppTypography.supporting,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Error Message if any
                if (_errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.errorBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: AppColors.error, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Full Name
                Text('Full Name', style: AppTypography.statusLabel),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'e.g. Ramesh Kumar',
                    prefixIcon: const Icon(Icons.person_outline_rounded),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter your name' : null,
                ),

                const SizedBox(height: 20),

                // Role Selection
                Text('Select Your Role', style: AppTypography.statusLabel),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _roleChoice(Role.patient, '👴 Patient', 'Receives care & calls'),
                    const SizedBox(width: 10),
                    _roleChoice(Role.caregiver, '👩‍💼 Caregiver', 'Monitors family'),
                    const SizedBox(width: 10),
                    _roleChoice(Role.doctor, '🩺 Doctor', 'Clinical overview'),
                  ],
                ),

                const SizedBox(height: 20),

                // Age (Mandatory if Patient for geriatric dosage algorithms)
                if (_selectedRole == Role.patient) ...[
                  Text('Age (Years)', style: AppTypography.statusLabel),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'e.g. 72',
                      prefixIcon: const Icon(Icons.cake_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    validator: (v) {
                      if (_selectedRole == Role.patient) {
                        if (v == null || v.trim().isEmpty) return 'Please enter age';
                        final a = int.tryParse(v.trim());
                        if (a == null || a < 1 || a > 120) return 'Please enter a valid age';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                ],

                // Phone Number
                Text('Phone Number (Optional for voice reminders)', style: AppTypography.statusLabel),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'e.g. +91 98765 43210',
                    prefixIcon: const Icon(Icons.phone_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),

                const SizedBox(height: 32),

                // Submit Button
                DhatriPrimaryButton(
                  label: 'Complete Setup & Enter Dhātrī',
                  icon: Icons.check_circle_outline_rounded,
                  onPressed: _isLoading ? null : _handleCompleteOnboarding,
                  isLoading: _isLoading,
                  height: 54,
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _roleChoice(Role role, String title, String subtitle) {
    final isSelected = _selectedRole == role;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedRole = role),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primarySurface : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.cardBorder,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTypography.supporting.copyWith(fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

