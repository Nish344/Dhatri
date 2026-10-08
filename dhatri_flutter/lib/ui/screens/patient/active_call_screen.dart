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
            // Explicit State Banner (Guide §10)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              color: isThinking
                  ? const Color(0xFF6366F1).withOpacity(0.2)
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
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF818CF8)),
                    )
                  else
                    Icon(
                      isYourTurn
                          ? Icons.mic_rounded
                          : isDhatriSpeaking
                              ? Icons.volume_up_rounded
                              : Icons.phone_in_talk_rounded,
                      size: 20,
                      color: isYourTurn
                          ? const Color(0xFF34D399)
                          : isDhatriSpeaking
                              ? const Color(0xFF38BDF8)
                              : Colors.white70,
                    ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      voice.phaseLabel,
                      style: AppTypography.sectionTitle.copyWith(
                        color: isYourTurn ? const Color(0xFF34D399) : Colors.white,
                        fontSize: 18,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Animated Waveform
            SizedBox(
              height: 50,
              child: DhatriAudioWaveform(
                isPulsing: isDhatriSpeaking || isListening,
                waveColor: isDhatriSpeaking ? const Color(0xFF38BDF8) : const Color(0xFF34D399),
              ),
            ),

            const SizedBox(height: 12),

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
                        border: Border.all(color: const Color(0xFF334155), width: 1.5),
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

                    // Patient Response Bubble
                    if (voice.currentPatientSpeech.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                          decoration: BoxDecoration(
                            color: AppColors.callGreen.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.callGreen.withOpacity(0.5)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'आप (Ramesh)',
                                style: AppTypography.statusLabel.copyWith(
                                  color: const Color(0xFF34D399),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                voice.currentPatientSpeech,
                                style: AppTypography.hindiBody.copyWith(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],

                    // Patient Memory Recalled Context Card (Guide §23)
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
                  // Quick Answer Chips for Demo Testing
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
                        enabled: isYourTurn,
                        onTap: () => voice.submitPatientResponse(CopyHindi.patientAnsWeakness),
                      ),
                      _hindiChip(
                        text: CopyHindi.patientAnsGood,
                        enabled: isYourTurn,
                        onTap: () => voice.submitPatientResponse(CopyHindi.patientAnsGood),
                      ),
                      _hindiChip(
                        text: CopyHindi.patientAnsMedicineTaken,
                        enabled: isYourTurn,
                        onTap: () => voice.submitPatientResponse(CopyHindi.patientAnsMedicineTaken),
                      ),
                      _hindiChip(
                        text: CopyHindi.patientAnsDizzy,
                        enabled: isYourTurn,
                        onTap: () => voice.submitPatientResponse(CopyHindi.patientAnsDizzy),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Mic Button & End Call Button
                  Row(
                    children: [
                      Expanded(
                        child: DhatriPrimaryButton(
                          label: isListening ? 'Listening...' : 'Tap to Speak',
                          icon: isListening ? null : Icons.mic_rounded,
                          onPressed: isYourTurn
                              ? () => voice.submitPatientResponse(CopyHindi.patientSecondResponse)
                              : null,
                          backgroundColor: isYourTurn ? AppColors.callGreen : const Color(0xFF334155),
                          height: 54,
                        ),
                      ),
                      const SizedBox(width: 14),
                      SizedBox(
                        width: 60,
                        height: 58,
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
}

