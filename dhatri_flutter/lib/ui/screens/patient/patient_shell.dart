import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_typography.dart';
import '../../../state/auth_state.dart';
import '../../../state/care_state.dart';
import '../../../state/voice_call_state.dart';
import '../../components/dhatri_role_switcher.dart';
import 'active_call_screen.dart';
import 'incoming_call_screen.dart';
import 'patient_health_screen.dart';
import 'patient_help_screen.dart';
import 'patient_home_screen.dart';
import 'patient_medicines_screen.dart';

class PatientShell extends StatefulWidget {
  const PatientShell({super.key});

  @override
  State<PatientShell> createState() => _PatientShellState();
}

class _PatientShellState extends State<PatientShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final voice = context.watch<VoiceCallState>();
    final auth = context.watch<AuthState>();
    final care = context.watch<CareState>();

    // Caregiver "Initiate call" lands here via care stream / pending poll —
    // not in the caregiver tab (two browsers must be signed in as different roles).
    final incoming = care.incomingCheck;
    if (incoming != null &&
        (voice.phase == CallUIPhase.ended ||
            (voice.phase == CallUIPhase.incoming &&
                voice.activeCheck?.id != incoming.id))) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.read<VoiceCallState>().receiveIncomingCall(incoming);
        context.read<CareState>().clearIncomingCheck();
      });
    }

    if (voice.phase == CallUIPhase.incoming) {
      return IncomingCallScreen(
        onAnswer: () => voice.acceptCall(),
        onDecline: () => voice.endCall(),
      );
    }

    if (voice.phase != CallUIPhase.ended &&
        voice.phase != CallUIPhase.incoming) {
      return ActiveCallScreen(onEndCall: () => voice.endCall());
    }

    final pages = [
      PatientHomeScreen(
        onOpenVoiceCall: () => voice.startDirectCall(auth.currentProfile.id),
      ),
      const PatientMedicinesScreen(),
      const PatientHealthScreen(),
      const PatientHelpScreen(),
    ];

    String tabTitle;
    switch (_currentIndex) {
      case 0:
        tabTitle = 'Dhātrī';
        break;
      case 1:
        tabTitle = 'Today\'s Medicines';
        break;
      case 2:
        tabTitle = 'Health History';
        break;
      case 3:
        tabTitle = 'Help & Contact';
        break;
      default:
        tabTitle = 'Dhātrī';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          tabTitle,
          style: AppTypography.sectionTitle.copyWith(fontSize: 20),
          overflow: TextOverflow.ellipsis,
        ),
        actions: const [DhatriRoleSwitcherButton()],
      ),
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.wb_sunny_outlined),
            selectedIcon: Icon(Icons.wb_sunny_rounded),
            label: 'Today',
          ),
          NavigationDestination(
            icon: Icon(Icons.medication_outlined),
            selectedIcon: Icon(Icons.medication_rounded),
            label: 'Medicines',
          ),
          NavigationDestination(
            icon: Icon(Icons.timeline_rounded),
            selectedIcon: Icon(Icons.timeline_rounded),
            label: 'Health',
          ),
          NavigationDestination(
            icon: Icon(Icons.contact_phone_outlined),
            selectedIcon: Icon(Icons.contact_phone_rounded),
            label: 'Help',
          ),
        ],
      ),
    );
  }
}
