import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'mock_engine/mock_database.dart';
import 'mock_engine/mock_care_stream.dart';
import 'mock_engine/mock_voice_engine.dart';
import 'repositories/dhatri_repository.dart';
import 'state/auth_state.dart';
import 'state/care_state.dart';
import 'state/voice_call_state.dart';
import 'models/models.dart';

import 'ui/components/dhatri_connection_banner.dart';
import 'ui/components/dhatri_demo_toolbar.dart';
import 'ui/screens/patient/patient_shell.dart';
import 'ui/screens/caregiver/caregiver_shell.dart';
import 'ui/screens/doctor/doctor_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Instantiate Mock Singletons
  final mockDb = MockDatabase();
  final mockCareStream = MockCareStream(mockDb);
  final mockVoiceEngine = MockVoiceEngine(mockDb, mockCareStream);
  final repository = MockDhatriRepository(
    db: mockDb,
    careStream: mockCareStream,
    voiceEngine: mockVoiceEngine,
  );

  runApp(
    MultiProvider(
      providers: [
        Provider<MockDatabase>.value(value: mockDb),
        Provider<MockCareStream>.value(value: mockCareStream),
        Provider<DhatriRepository>.value(value: repository),
        ChangeNotifierProvider(create: (_) => AuthState()),
        ChangeNotifierProvider(create: (_) => CareState(repository: repository)),
        ChangeNotifierProvider(
          create: (_) => VoiceCallState(
            voiceEngine: mockVoiceEngine,
            careStream: mockCareStream,
          ),
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
    final careStream = context.read<MockCareStream>();
    final mockDb = context.read<MockDatabase>();

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
      body: Stack(
        children: [
          Column(
            children: [
              ValueListenableBuilder<CareConnectionState>(
                valueListenable: careStream.connectionState,
                builder: (context, state, _) {
                  return DhatriConnectionBanner(state: state);
                },
              ),
              Expanded(child: currentRoleView),
            ],
          ),
          // Interactive Demo Toolbar for filming and presenting
          DhatriDemoToolbar(
            careStream: careStream,
            db: mockDb,
          ),
        ],
      ),
    );
  }
}

