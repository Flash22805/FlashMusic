import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/audio_service.dart';

class LiquidWaveSphere extends StatefulWidget {
  final double size;
  final List<Color> colors;
  final VoidCallback? onTap;

  const LiquidWaveSphere({
    super.key,
    this.size = 280,
    required this.colors,
    this.onTap,
  });

  @override
  State<LiquidWaveSphere> createState() => _LiquidWaveSphereState();
}

class _LiquidWaveSphereState extends State<LiquidWaveSphere>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _pulseController;
  final AudioService _audioService = AudioService();

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _waveController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _audioService,
      builder: (context, _) {
        final isPlaying = _audioService.isPlaying;

        return GestureDetector(
          onTap: widget.onTap ?? () => _audioService.togglePlayPause(),
          child: AnimatedBuilder(
            animation: Listenable.merge([_waveController, _pulseController]),
            builder: (context, child) {
              final wavePhase = _waveController.value * 2 * pi;
              final pulse = isPlaying ? (_pulseController.value * 0.08 + 0.96) : 0.95;

              return SizedBox(
                width: widget.size,
                height: widget.size,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer fluid glow halo
                    Transform.scale(
                      scale: pulse * 1.15,
                      child: Container(
                        width: widget.size * 0.85,
                        height: widget.size * 0.85,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              widget.colors.first.withOpacity(isPlaying ? 0.6 : 0.3),
                              widget.colors.last.withOpacity(0.0),
                            ],
                            stops: const [0.4, 1.0],
                          ),
                        ),
                      ),
                    ),

                    // Custom Organic Liquid Wave Shape
                    Transform.scale(
                      scale: pulse,
                      child: CustomPaint(
                        size: Size(widget.size, widget.size),
                        painter: _LiquidBlobPainter(
                          phase: wavePhase,
                          colors: widget.colors,
                          isPlaying: isPlaying,
                        ),
                      ),
                    ),

                    // Frosted Glass Core with Play/Pause button
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                        child: Container(
                          width: widget.size * 0.38,
                          height: widget.size * 0.38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.15),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.35),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 18,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              isPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              size: 48,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _LiquidBlobPainter extends CustomPainter {
  final double phase;
  final List<Color> colors;
  final bool isPlaying;

  _LiquidBlobPainter({
    required this.phase,
    required this.colors,
    required this.isPlaying,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.width * 0.40;
    final path = Path();

    const int pointCount = 120;
    for (int i = 0; i <= pointCount; i++) {
      final angle = (i / pointCount) * 2 * pi;
      // Morphing organic radius using multiple harmonics
      final wave1 = sin(angle * 3 + phase) * (isPlaying ? 14 : 6);
      final wave2 = cos(angle * 5 - phase * 1.5) * (isPlaying ? 9 : 4);
      final wave3 = sin(angle * 2 + phase * 0.7) * (isPlaying ? 11 : 5);

      final r = baseRadius + wave1 + wave2 + wave3;
      final x = center.dx + r * cos(angle);
      final y = center.dy + r * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    // Fill with multi-stop dynamic gradient
    final rect = Rect.fromCircle(center: center, radius: baseRadius + 20);
    final paint = Paint()
      ..shader = SweepGradient(
        colors: colors.length >= 2
            ? [...colors, colors.first]
            : [Colors.purple, Colors.cyan, Colors.purple],
        transform: GradientRotation(phase * 0.5),
      ).createShader(rect)
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);

    // Liquid Highlight Stroke
    final strokePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.7),
          Colors.white.withOpacity(0.1),
        ],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant _LiquidBlobPainter oldDelegate) {
    return oldDelegate.phase != phase ||
        oldDelegate.colors != colors ||
        oldDelegate.isPlaying != isPlaying;
  }
}
