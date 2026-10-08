import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'mock_engine/mock_database.dart';
import 'mock_engine/mock_care_stream.dart';
import 'mock_engine/mock_voice_engine.dart';
import 'repositories/dhatri_repository.dart';
import 'repositories/hybrid_dhatri_repository.dart';
import 'repositories/serverpod_dhatri_repository.dart';
import 'services/serverpod_client_service.dart';
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

  // 1. Initialize Serverpod client service & backend repository
  final clientService = ServerpodClientService();
  final serverpodRepo = ServerpodDhatriRepository(client: clientService.client);

  // 2. Instantiate Mock Singletons (fallback & simulation engine)
  final mockDb = MockDatabase();
  final mockCareStream = MockCareStream(mockDb);
  final mockVoiceEngine = MockVoiceEngine(mockDb, mockCareStream);
  final mockRepo = MockDhatriRepository(
    db: mockDb,
    careStream: mockCareStream,
    voiceEngine: mockVoiceEngine,
  );

  // 3. Connect Hybrid repository for automatic online/offline routing
  final hybridRepo = HybridDhatriRepository(
    clientService: clientService,
    serverpodRepo: serverpodRepo,
    mockRepo: mockRepo,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ServerpodClientService>.value(value: clientService),
        ChangeNotifierProvider<HybridDhatriRepository>.value(value: hybridRepo),
        Provider<ServerpodDhatriRepository>.value(value: serverpodRepo),
        Provider<MockDhatriRepository>.value(value: mockRepo),
        Provider<DhatriRepository>.value(value: hybridRepo),
        Provider<MockDatabase>.value(value: mockDb),
        Provider<MockCareStream>.value(value: mockCareStream),
        Provider<MockVoiceEngine>.value(value: mockVoiceEngine),
        ChangeNotifierProvider(create: (_) => AuthState(clientService: clientService)),
        ChangeNotifierProvider(create: (_) => CareState(repository: hybridRepo)),
        ChangeNotifierProvider(
          create: (_) => VoiceCallState(
            voiceEngine: mockVoiceEngine,
            careStream: mockCareStream,
            repository: hybridRepo,
            serverpodRepo: serverpodRepo,
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
    final hybridRepo = context.watch<HybridDhatriRepository>();
    final clientService = context.watch<ServerpodClientService>();

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
                  return DhatriConnectionBanner(
                    state: state,
                    isLiveServerpod: hybridRepo.isLiveBackend,
                    serverUrl: clientService.serverUrl,
                  );
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

