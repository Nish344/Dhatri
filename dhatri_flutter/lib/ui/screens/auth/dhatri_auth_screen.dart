import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dhatri_client/dhatri_client.dart' show UuidValue;
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../services/serverpod_client_service.dart';
import '../../../state/auth_state.dart';
import '../../../state/care_state.dart';
import '../../components/dhatri_buttons.dart';

class DhatriAuthScreen extends StatefulWidget {
  const DhatriAuthScreen({super.key});

  @override
  State<DhatriAuthScreen> createState() => _DhatriAuthScreenState();
}

class _DhatriAuthScreenState extends State<DhatriAuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Sign In controllers
  final TextEditingController _signInEmailController = TextEditingController();
  final TextEditingController _signInPasswordController =
      TextEditingController();

  // Sign Up controllers
  final TextEditingController _signUpEmailController = TextEditingController();
  final TextEditingController _signUpPasswordController =
      TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _signInEmailController.dispose();
    _signInPasswordController.dispose();
    _signUpEmailController.dispose();
    _signUpPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    final email = _signInEmailController.text.trim();
    final password = _signInPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email and password')),
      );
      return;
    }

    setState(() => _isLoading = true);
    final auth = context.read<AuthState>();
    final care = context.read<CareState>();

    final ok = await auth.signInWithEmail(email, password);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Sign in failed: ${auth.authError ?? 'Invalid credentials'}',
          ),
          backgroundColor: AppColors.error,
        ),
      );
    } else if (mounted) {
      await care.loadAll();
    }
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _handleStartSignUp() async {
    final email = _signUpEmailController.text.trim();
    final password = _signUpPasswordController.text.trim();
    final confirm = _confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    if (password != confirm) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }

    if (password.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must be at least 8 characters long'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    final clientService = context.read<ServerpodClientService>();

    final accountRequestId = await clientService.startRegistration(email);
    if (mounted) setState(() => _isLoading = false);

    if (accountRequestId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Registration failed: ${clientService.lastError ?? 'Unknown error'}',
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }

    if (mounted) {
      _showVerificationDialog(accountRequestId, email, password);
    }
  }

  void _showVerificationDialog(
    UuidValue accountRequestId,
    String email,
    String password,
  ) {
    final codeController = TextEditingController();
    bool isVerifying = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text('Enter Verification Code'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'A verification code was sent for $email.',
                  style: AppTypography.supporting,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '💡 In local development, Serverpod logs the verification code to the "serverpod start" terminal.',
                    style: AppTypography.supporting.copyWith(
                      fontSize: 11,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: codeController,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Verification Code',
                    hintText: 'e.g. 12345678',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: isVerifying ? null : () => Navigator.pop(dialogCtx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: isVerifying
                    ? null
                    : () async {
                        final code = codeController.text.trim();
                        if (code.isEmpty) return;

                        setDialogState(() => isVerifying = true);
                        final clientService = context
                            .read<ServerpodClientService>();
                        final auth = context.read<AuthState>();

                        final token = await clientService
                            .verifyRegistrationCode(accountRequestId, code);
                        if (token == null) {
                          setDialogState(() => isVerifying = false);
                          if (dialogCtx.mounted) {
                            ScaffoldMessenger.of(dialogCtx).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Invalid code: ${clientService.lastError ?? 'Try again'}',
                                ),
                                backgroundColor: AppColors.error,
                              ),
                            );
                          }
                          return;
                        }

                        final finished = await clientService.finishRegistration(
                          token,
                          password,
                        );
                        if (!finished) {
                          setDialogState(() => isVerifying = false);
                          if (dialogCtx.mounted) {
                            ScaffoldMessenger.of(dialogCtx).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Registration failed: ${clientService.lastError ?? 'Try again'}',
                                ),
                                backgroundColor: AppColors.error,
                              ),
                            );
                          }
                          return;
                        }

                        if (dialogCtx.mounted) {
                          Navigator.pop(dialogCtx);
                        }

                        await auth.loadCurrentProfile();
                      },
                child: isVerifying
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Verify & Finish'),
              ),
            ],
          );
        },
      ),
    );
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
                'Intelligent Eldercare & Medication Adherence',
                textAlign: TextAlign.center,
                style: AppTypography.supporting.copyWith(fontSize: 14),
              ),

              const SizedBox(height: 20),

              // Serverpod Connection Pill
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: clientService.isOnline
                      ? AppColors.success.withOpacity(0.12)
                      : AppColors.warning.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
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
                    Tab(text: 'Sign In'),
                    Tab(text: 'Create Account'),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Tab Views
              SizedBox(
                height: 440,
                child: TabBarView(
                  controller: _tabController,
                  children: [_buildSignInTab(), _buildSignUpTab()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignInTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sign in to your account with email and password:',
              style: AppTypography.supporting,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _signInEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email Address',
                hintText: 'e.g. user@example.com',
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _signInPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 24),
            DhatriPrimaryButton(
              label: 'Sign In',
              icon: Icons.login_rounded,
              onPressed: _isLoading ? null : _handleSignIn,
              isLoading: _isLoading,
              height: 52,
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () => _tabController.animateTo(1),
                child: const Text('Don\'t have an account? Create one now'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create a new Serverpod account:',
              style: AppTypography.supporting,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _signUpEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email Address',
                hintText: 'e.g. yourname@example.com',
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _signUpPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password (min 8 chars)',
                prefixIcon: const Icon(Icons.lock_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                prefixIcon: const Icon(Icons.lock_reset_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 24),
            DhatriPrimaryButton(
              label: 'Create Account',
              icon: Icons.person_add_rounded,
              onPressed: _isLoading ? null : _handleStartSignUp,
              isLoading: _isLoading,
              height: 52,
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () => _tabController.animateTo(0),
                child: const Text('Already have an account? Sign in'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
