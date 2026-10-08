import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../state/voice_call_state.dart';
import 'patient_home_screen.dart';
import 'patient_medicines_screen.dart';
import 'patient_health_screen.dart';
import 'patient_help_screen.dart';
import 'incoming_call_screen.dart';
import 'active_call_screen.dart';
import '../../components/dhatri_role_switcher.dart';

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

    // 1. Phone-style Incoming Call full-screen overlay
    if (voice.phase == CallUIPhase.incoming) {
      return IncomingCallScreen(
        onAnswer: () => voice.acceptCall(),
        onDecline: () => voice.endCall(),
      );
    }

    // 2. Active Voice Call interface
    if (voice.phase != CallUIPhase.ended && voice.phase != CallUIPhase.incoming) {
      return ActiveCallScreen(
        onEndCall: () => voice.endCall(),
      );
    }

    // 3. Normal Patient Navigation Shell
    final pages = [
      PatientHomeScreen(
        onOpenVoiceCall: () => voice.startDirectCall(1),
      ),
      const PatientMedicinesScreen(),
      const PatientHealthScreen(),
      const PatientHelpScreen(),
    ];

    return Scaffold(
      appBar: _currentIndex == 0
          ? AppBar(
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text('🌿', style: TextStyle(fontSize: 20)),
                  ),
                  const SizedBox(width: 10),
                  const Text('Dhātrī'),
                ],
              ),
              actions: [
                const DhatriRoleSwitcherButton(),
                IconButton(
                  icon: const Icon(Icons.help_outline_rounded),
                  tooltip: 'Help',
                  onPressed: () => setState(() => _currentIndex = 3),
                ),
              ],
            )
          : null,
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
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

