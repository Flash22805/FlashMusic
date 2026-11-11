import 'package:flutter/material.dart';
import '../services/audio_service.dart';

class WaveVisualizer extends StatelessWidget {
  final int barCount;
  final double height;
  final double barWidth;
  final List<Color>? gradientColors;
  final AudioService _audioService = AudioService();

  WaveVisualizer({
    super.key,
    this.barCount = 20,
    this.height = 40,
    this.barWidth = 3.5,
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _audioService,
      builder: (context, _) {
        final bars = _audioService.visualizerBars;
        final isPlaying = _audioService.isPlaying;

        final colors = gradientColors ??
            (_audioService.currentTrack?.gradientColors ??
                const [Color(0xFF00F0FF), Color(0xFFFF2A85)]);

        return SizedBox(
          height: height,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(barCount, (index) {
              final val = (index < bars.length) ? bars[index] : 0.15;
              final effectiveHeight = isPlaying ? (val * height).clamp(4.0, height) : 4.0;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 70),
                curve: Curves.easeOutQuad,
                margin: const EdgeInsets.symmetric(horizontal: 1.8),
                width: barWidth,
                height: effectiveHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      colors[0],
                      colors.length > 1 ? colors[1] : colors[0],
                    ],
                  ),
                  boxShadow: isPlaying
                      ? [
                          BoxShadow(
                            color: colors[0].withOpacity(0.4),
                            blurRadius: 6,
                            spreadRadius: 0.5,
                          ),
                        ]
                      : null,
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
