import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class DhatriAudioWaveform extends StatefulWidget {
  final bool isPulsing;
  final Color waveColor;

  const DhatriAudioWaveform({
    super.key,
    this.isPulsing = true,
    this.waveColor = AppColors.primary,
  });

  @override
  State<DhatriAudioWaveform> createState() => _DhatriAudioWaveformState();
}

class _DhatriAudioWaveformState extends State<DhatriAudioWaveform>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final anim = widget.isPulsing ? _controller.value : 0.2;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final multipliers = [0.4, 0.8, 1.0, 0.7, 0.5];
            final height = 16.0 + (36.0 * anim * multipliers[index]);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 6,
              height: height,
              decoration: BoxDecoration(
                color: widget.waveColor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10),
              ),
            );
          }),
        );
      },
    );
  }
}

