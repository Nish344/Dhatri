import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'repositories/dhatri_repository.dart';
import 'repositories/serverpod_dhatri_repository.dart';
import 'services/serverpod_client_service.dart';
import 'state/auth_state.dart';
import 'state/care_state.dart';
import 'state/voice_call_state.dart';
import 'models/models.dart';

import 'ui/components/dhatri_connection_banner.dart';
import 'ui/screens/auth/dhatri_auth_screen.dart';
import 'ui/screens/patient/patient_shell.dart';
import 'ui/screens/caregiver/caregiver_shell.dart';
import 'ui/screens/doctor/doctor_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Serverpod client service & repository
  final clientService = ServerpodClientService();
  final repository = ServerpodDhatriRepository(client: clientService.client);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ServerpodClientService>.value(value: clientService),
        Provider<ServerpodDhatriRepository>.value(value: repository),
        Provider<DhatriRepository>.value(value: repository),
        ChangeNotifierProvider(create: (_) => AuthState(clientService: clientService)),
        ChangeNotifierProvider(create: (_) => CareState(repository: repository)),
        ChangeNotifierProvider(
          create: (_) => VoiceCallState(repository: repository),
        ),
      ],
      child: const DhatriApp(),
    ),
  );
}

class DhatriApp extends StatelessWidget {
  const DhatriApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dhātrī — Care Companion',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const DhatriRootShell(),
    );
  }
}

class DhatriRootShell extends StatelessWidget {
  const DhatriRootShell({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    final clientService = context.watch<ServerpodClientService>();

    if (!auth.isSignedIn) {
      return const DhatriAuthScreen();
    }

    Widget currentRoleView;
    switch (auth.activeRole) {
      case Role.patient:
        currentRoleView = const PatientShell();
        break;
      case Role.caregiver:
        currentRoleView = const CaregiverShell();
        break;
      case Role.doctor:
        currentRoleView = const DoctorShell();
        break;
    }

    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            DhatriConnectionBanner(
              isOnline: clientService.isOnline,
              serverUrl: clientService.serverUrl,
            ),
            Expanded(child: currentRoleView),
          ],
        ),
      ),
    );
  }
}
