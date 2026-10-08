import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/copy_hindi.dart';
import '../../../state/voice_call_state.dart';
import '../../components/dhatri_audio_waveform.dart';
import '../../components/dhatri_memory_card.dart';
import '../../components/dhatri_buttons.dart';

class ActiveCallScreen extends StatelessWidget {
  final VoidCallback onEndCall;

  const ActiveCallScreen({
    super.key,
    required this.onEndCall,
  });

  @override
  Widget build(BuildContext context) {
    final voice = context.watch<VoiceCallState>();
    final isDhatriSpeaking = voice.phase == CallUIPhase.dhatriSpeaking;
    final isYourTurn = voice.phase == CallUIPhase.yourTurn;
    final isListening = voice.phase == CallUIPhase.listening;
    final isThinking = voice.phase == CallUIPhase.thinking;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Dark slate telephony backdrop
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: onEndCall,
        ),
        title: Text(
          'Dhatri Care Call',
          style: AppTypography.pageTitle.copyWith(color: Colors.white, fontSize: 20),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.record_voice_over_rounded, size: 16, color: Color(0xFF38BDF8)),
                const SizedBox(width: 6),
                Text(
                  'Hindi · hi-IN',
                  style: AppTypography.supporting.copyWith(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Explicit State Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              color: isThinking
                  ? const Color(0xFF6366F1).withOpacity(0.25)
                  : isListening
                      ? const Color(0xFF10B981).withOpacity(0.25)
                      : isYourTurn
                          ? AppColors.callGreen.withOpacity(0.2)
                          : isDhatriSpeaking
                              ? AppColors.primary.withOpacity(0.3)
                              : Colors.white.withOpacity(0.06),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isThinking)
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF818CF8)),
                    )
                  else
                    Icon(
                      isListening
                          ? Icons.mic_rounded
                          : isYourTurn
                              ? Icons.mic_none_rounded
                              : isDhatriSpeaking
                                  ? Icons.volume_up_rounded
                                  : Icons.phone_in_talk_rounded,
                      size: 20,
                      color: isListening
                          ? const Color(0xFF34D399)
                          : isYourTurn
                              ? const Color(0xFF34D399)
                              : isDhatriSpeaking
                                  ? const Color(0xFF38BDF8)
                                  : Colors.white70,
                    ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      isListening ? 'आपकी आवाज़ सुन रही हूँ... (Listening...)' : voice.phaseLabel,
                      style: AppTypography.sectionTitle.copyWith(
                        color: (isListening || isYourTurn) ? const Color(0xFF34D399) : Colors.white,
                        fontSize: 18,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Animated Waveform
            SizedBox(
              height: 48,
              child: DhatriAudioWaveform(
                isPulsing: isDhatriSpeaking || isListening,
                waveColor: isDhatriSpeaking ? const Color(0xFF38BDF8) : const Color(0xFF34D399),
              ),
            ),

            const SizedBox(height: 8),

            // Scrollable Dialogue & Memory Display
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Dhatri Speech Bubble
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDhatriSpeaking ? const Color(0xFF38BDF8) : const Color(0xFF334155),
                          width: isDhatriSpeaking ? 2.0 : 1.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text('🌿', style: TextStyle(fontSize: 18)),
                              const SizedBox(width: 8),
                              Text(
                                'धात्री (Dhatri)',
                                style: AppTypography.statusLabel.copyWith(
                                  color: const Color(0xFF38BDF8),
                                ),
                              ),
                              const Spacer(),
                              if (isDhatriSpeaking)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF38BDF8).withOpacity(0.18),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.volume_up_rounded, size: 14, color: Color(0xFF38BDF8)),
                                      SizedBox(width: 4),
                                      Text(
                                        'बोल रही हैं...',
                                        style: TextStyle(color: Color(0xFF38BDF8), fontSize: 11),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            voice.currentDhatriText,
                            style: AppTypography.hindiBody.copyWith(
                              color: Colors.white,
                              fontSize: 22,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Patient Live Speech Bubble
                    if (isListening || voice.currentPatientSpeech.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                          decoration: BoxDecoration(
                            color: AppColors.callGreen.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isListening ? const Color(0xFF34D399) : AppColors.callGreen.withOpacity(0.5),
                              width: isListening ? 2 : 1.2,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (isListening) ...[
                                    const SizedBox(
                                      width: 12,
                                      height: 12,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF34D399)),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'माइक चालू है (Live Mic)...',
                                      style: AppTypography.statusLabel.copyWith(
                                        color: const Color(0xFF34D399),
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                  Text(
                                    'आप (You)',
                                    style: AppTypography.statusLabel.copyWith(
                                      color: const Color(0xFF34D399),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                voice.currentPatientSpeech.isNotEmpty
                                    ? voice.currentPatientSpeech
                                    : 'बोलिए, धात्री सुन रही हैं... (Speak now...)',
                                style: AppTypography.hindiBody.copyWith(
                                  color: voice.currentPatientSpeech.isNotEmpty ? Colors.white : Colors.white60,
                                  fontSize: 20,
                                  fontStyle: voice.currentPatientSpeech.isEmpty ? FontStyle.italic : FontStyle.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],

                    // Microphone Permission / Error Notice
                    if (voice.voiceErrorMessage != null) ...[
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.amber.withOpacity(0.5)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline_rounded, color: Colors.amber, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                voice.voiceErrorMessage!,
                                style: const TextStyle(color: Colors.amber, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Patient Memory Recalled Context Card
                    if (voice.rememberedContext.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      DhatriMemoryCard(
                        memories: voice.rememberedContext,
                        title: 'What Dhatri remembered',
                      ),
                    ],

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Bottom Interaction Tray: Quick Answer Chips + Mic + End Call
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              decoration: const BoxDecoration(
                color: Color(0xFF1E293B),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Quick Answer Chips (One-tap alternatives in Hindi)
                  Text(
                    'त्वरित उत्तर (Quick Responses):',
                    style: AppTypography.supporting.copyWith(color: const Color(0xFF94A3B8), fontSize: 13),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _hindiChip(
                        text: CopyHindi.patientAnsWeakness,
                        enabled: isYourTurn || isListening,
                        onTap: () => voice.submitPatientResponse(CopyHindi.patientAnsWeakness),
                      ),
                      _hindiChip(
                        text: CopyHindi.patientAnsGood,
                        enabled: isYourTurn || isListening,
                        onTap: () => voice.submitPatientResponse(CopyHindi.patientAnsGood),
                      ),
                      _hindiChip(
                        text: CopyHindi.patientAnsMedicineTaken,
                        enabled: isYourTurn || isListening,
                        onTap: () => voice.submitPatientResponse(CopyHindi.patientAnsMedicineTaken),
                      ),
                      _hindiChip(
                        text: CopyHindi.patientAnsDizzy,
                        enabled: isYourTurn || isListening,
                        onTap: () => voice.submitPatientResponse(CopyHindi.patientAnsDizzy),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Real Microphone Audio Action Button + Fallback Keyboard + End Call
                  Row(
                    children: [
                      // Primary Button: Directly activates mic or stops and submits live speech!
                      Expanded(
                        child: isListening
                            ? DhatriPrimaryButton(
                                label: 'बोलना समाप्त करें (Stop & Send)',
                                icon: Icons.stop_circle_rounded,
                                onPressed: () => voice.stopListeningAndSubmit(),
                                backgroundColor: const Color(0xFFEF4444), // Prominent stop/send button
                                height: 56,
                              )
                            : isDhatriSpeaking
                                ? DhatriPrimaryButton(
                                    label: 'धात्री बोल रही हैं... (Speaking)',
                                    icon: Icons.volume_up_rounded,
                                    onPressed: null,
                                    backgroundColor: const Color(0xFF334155),
                                    height: 56,
                                  )
                                : isThinking
                                    ? DhatriPrimaryButton(
                                        label: 'सोच रही हूँ... (Thinking)',
                                        icon: Icons.hourglass_top_rounded,
                                        onPressed: null,
                                        backgroundColor: const Color(0xFF334155),
                                        height: 56,
                                      )
                                    : DhatriPrimaryButton(
                                        label: 'बोलने के लिए दबाएं (Tap to Speak)',
                                        icon: Icons.mic_rounded,
                                        onPressed: isYourTurn ? () => voice.startListening() : null,
                                        backgroundColor: isYourTurn ? AppColors.callGreen : const Color(0xFF334155),
                                        height: 56,
                                      ),
                      ),

                      const SizedBox(width: 10),

                      // Optional Keyboard icon for manual typing accessibility if needed
                      IconButton(
                        tooltip: 'Type text manually',
                        icon: const Icon(Icons.keyboard_alt_outlined, color: Colors.white70, size: 24),
                        onPressed: isYourTurn ? () => _showManualTextInputDialog(context, voice) : null,
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFF334155),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          padding: const EdgeInsets.all(12),
                        ),
                      ),

                      const SizedBox(width: 10),

                      // End Call Button
                      SizedBox(
                        width: 56,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: onEndCall,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.emergencyRed,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Icon(Icons.call_end_rounded, color: Colors.white, size: 28),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _hindiChip({
    required String text,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: enabled ? const Color(0xFF334155) : const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: enabled ? const Color(0xFF38BDF8).withOpacity(0.5) : const Color(0xFF475569),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: enabled ? Colors.white : Colors.white38,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  /// Accessibility fallback modal dialog only opened if user explicitly taps the keyboard icon
  void _showManualTextInputDialog(BuildContext context, VoiceCallState voice) {
    final controller = TextEditingController(text: voice.currentPatientSpeech);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'संदेश टाइप करें (Type Response)',
                style: AppTypography.sectionTitle.copyWith(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: controller,
                autofocus: true,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                decoration: InputDecoration(
                  hintText: 'उदा. आज बहुत कमजोरी महसूस हो रही है...',
                  hintStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: const Color(0xFF0F172A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFF334155)),
                  ),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 20),
              DhatriPrimaryButton(
                label: 'Send to Dhatri (भेजें)',
                icon: Icons.send_rounded,
                backgroundColor: AppColors.callGreen,
                onPressed: () {
                  final text = controller.text.trim();
                  if (text.isNotEmpty) {
                    Navigator.pop(ctx);
                    voice.submitPatientResponse(text);
                  }
                },
                height: 52,
              ),
            ],
          ),
        );
      },
    );
  }
}
