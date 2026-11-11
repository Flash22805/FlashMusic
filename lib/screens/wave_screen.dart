import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/audio_service.dart';
import '../services/mock_data.dart';
import '../theme/app_colors.dart';
import '../widgets/animated_heart_button.dart';
import '../widgets/glass_container.dart';
import '../widgets/liquid_wave_sphere.dart';
import '../widgets/wave_visualizer.dart';

class WaveScreen extends StatelessWidget {
  WaveScreen({super.key});

  final AudioService _audioService = AudioService();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _audioService,
      builder: (context, _) {
        final currentTrack = _audioService.currentTrack;
        final currentMoodId = _audioService.activeMood;
        final isLiked = currentTrack != null && _audioService.isTrackLiked(currentTrack.id);

        final activeMoodData = MockData.waveMoods.firstWhere(
          (m) => m['id'] == currentMoodId,
          orElse: () => MockData.waveMoods.first,
        );

        final colors = (activeMoodData['gradient'] as List<Color>);

        return SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 12),

              // Top Title & Badge
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Моя волна',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                gradient: const LinearGradient(
                                  colors: [AppColors.primaryYandex, Color(0xFFFF5252)],
                                ),
                              ),
                              child: const Text(
                                'SMART FLOW',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Умный поток музыки, который подстраивается под вас',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white.withOpacity(0.08),
                            border: Border.all(color: Colors.white.withOpacity(0.18)),
                          ),
                          child: const Icon(Icons.tune_rounded, color: Colors.white, size: 22),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 1),

              // The Living Liquid Wave Sphere
              Center(
                child: LiquidWaveSphere(
                  size: 290,
                  colors: colors,
                  onTap: () => _audioService.togglePlayPause(),
                ),
              ),

              const SizedBox(height: 20),

              // Track Title & Artist Banner
              if (currentTrack != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: GlassContainer(
                    blur: 20,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    borderRadius: BorderRadius.circular(22),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            currentTrack.coverUrl,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentTrack.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                currentTrack.artist,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        AnimatedHeartButton(
                          size: 26,
                          isLiked: isLiked,
                          onTap: () => _audioService.toggleLike(currentTrack),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 16),

              // Audio Equalizer Spectrum
              WaveVisualizer(
                barCount: 22,
                height: 28,
                barWidth: 4,
                gradientColors: colors,
              ),

              const Spacer(flex: 1),

              // Flow Reaction Buttons (Dislike / Skip, Play / Pause, Next)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(
                      icon: Icons.thumb_down_alt_outlined,
                      label: 'Не моё',
                      color: Colors.white60,
                      onTap: () => _audioService.next(),
                    ),
                    _buildActionButton(
                      icon: _audioService.isPlaying
                          ? Icons.pause_circle_filled_rounded
                          : Icons.play_circle_fill_rounded,
                      label: _audioService.isPlaying ? 'Пауза' : 'Включить',
                      color: AppColors.primaryYandex,
                      size: 64,
                      iconSize: 42,
                      onTap: () => _audioService.togglePlayPause(),
                    ),
                    _buildActionButton(
                      icon: Icons.skip_next_rounded,
                      label: 'Дальше',
                      color: Colors.white,
                      onTap: () => _audioService.next(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Mood Selector Chips Horizontal Scroll
              SizedBox(
                height: 44,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: MockData.waveMoods.length,
                  itemBuilder: (context, idx) {
                    final mood = MockData.waveMoods[idx];
                    final isSelected = mood['id'] == currentMoodId;

                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GlassContainer(
                        blur: 16,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        borderRadius: BorderRadius.circular(22),
                        color: isSelected
                            ? (mood['gradient'] as List<Color>).first.withOpacity(0.35)
                            : Colors.white.withOpacity(0.06),
                        borderColor: isSelected
                            ? (mood['gradient'] as List<Color>).first.withOpacity(0.7)
                            : Colors.white.withOpacity(0.12),
                        onTap: () => _audioService.setMood(mood['id']),
                        child: Row(
                          children: [
                            Text(mood['icon'], style: const TextStyle(fontSize: 16)),
                            const SizedBox(width: 8),
                            Text(
                              mood['label'],
                              style: TextStyle(
                                color: isSelected ? Colors.white : AppColors.textSecondary,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 90),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    double size = 48,
    double iconSize = 26,
  }) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(size / 2),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: IconButton(
                icon: Icon(icon, color: color, size: iconSize),
                padding: EdgeInsets.zero,
                onPressed: onTap,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
