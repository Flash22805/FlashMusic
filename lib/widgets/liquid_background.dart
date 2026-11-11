import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/audio_service.dart';
import '../theme/app_colors.dart';

class LiquidBackground extends StatefulWidget {
  final Widget child;
  final List<Color>? customColors;

  const LiquidBackground({
    super.key,
    required this.child,
    this.customColors,
  });

  @override
  State<LiquidBackground> createState() => _LiquidBackgroundState();
}

class _LiquidBackgroundState extends State<LiquidBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final AudioService _audioService = AudioService();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _audioService,
      builder: (context, _) {
        final currentTrack = _audioService.currentTrack;
        final isPlaying = _audioService.isPlaying;

        final colors = widget.customColors ??
            (currentTrack != null
                ? currentTrack.gradientColors
                : [
                    AppColors.accentPink,
                    AppColors.accentPurple,
                    AppColors.accentCyan,
                  ]);

        return Stack(
          children: [
            // Deep background base
            Container(color: AppColors.background),

            // Animated Liquid Blobs
            AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                final t = _controller.value * 2 * pi;
                final pulse = isPlaying ? (sin(t * 3) * 0.15 + 1.0) : 1.0;

                return Stack(
                  children: [
                    // Blob 1: Top-Right
                    Positioned(
                      top: -60 + sin(t) * 40,
                      right: -50 + cos(t * 0.8) * 40,
                      child: _buildBlob(
                        size: 320 * pulse,
                        color: colors.isNotEmpty
                            ? colors[0].withOpacity(0.45)
                            : Colors.purple.withOpacity(0.4),
                      ),
                    ),

                    // Blob 2: Center-Left
                    Positioned(
                      top: 240 + cos(t * 1.2) * 50,
                      left: -80 + sin(t * 0.7) * 40,
                      child: _buildBlob(
                        size: 300 * pulse,
                        color: colors.length > 1
                            ? colors[1].withOpacity(0.4)
                            : Colors.cyan.withOpacity(0.35),
                      ),
                    ),

                    // Blob 3: Bottom-Center
                    Positioned(
                      bottom: -80 + sin(t * 0.9) * 40,
                      right: 20 + cos(t * 1.1) * 60,
                      child: _buildBlob(
                        size: 340 * pulse,
                        color: colors.length > 2
                            ? colors[2].withOpacity(0.35)
                            : Colors.pinkAccent.withOpacity(0.35),
                      ),
                    ),
                  ],
                );
              },
            ),

            // Liquid Frosted Blur Sheet
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 75, sigmaY: 75),
                child: Container(
                  color: Colors.black.withOpacity(0.35),
                ),
              ),
            ),

            // Foreground child content
            widget.child,
          ],
        );
      },
    );
  }

  Widget _buildBlob({required double size, required Color color}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color,
            color.withOpacity(0.0),
          ],
          stops: const [0.2, 1.0],
        ),
      ),
    );
  }
}
