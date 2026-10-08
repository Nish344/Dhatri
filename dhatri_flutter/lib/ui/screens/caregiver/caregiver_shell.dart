import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../state/care_state.dart';
import 'caregiver_home_screen.dart';
import 'prescription_upload_screen.dart';
import 'alert_detail_screen.dart';
import '../patient/patient_health_screen.dart';

class CaregiverShell extends StatefulWidget {
  const CaregiverShell({super.key});

  @override
  State<CaregiverShell> createState() => _CaregiverShellState();
}

class _CaregiverShellState extends State<CaregiverShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final care = context.watch<CareState>();

    final pages = [
      const CaregiverHomeScreen(),
      const PatientHealthScreen(showAppBar: true), // Reused for caregiver timeline monitoring
      const PrescriptionUploadScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded),
            label: 'Triage Home',
          ),
          const NavigationDestination(
            icon: Icon(Icons.timeline_rounded),
            selectedIcon: Icon(Icons.timeline_rounded),
            label: 'Timeline',
          ),
          const NavigationDestination(
            icon: Icon(Icons.document_scanner_outlined),
            selectedIcon: Icon(Icons.document_scanner_rounded),
            label: 'Upload Rx',
          ),
        ],
      ),
    );
  }
}

