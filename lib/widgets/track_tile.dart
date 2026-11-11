import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/track.dart';
import '../services/audio_service.dart';
import '../theme/app_colors.dart';
import 'animated_heart_button.dart';
import 'wave_visualizer.dart';

class TrackTile extends StatelessWidget {
  final Track track;
  final List<Track>? queue;
  final int? index;
  final VoidCallback? onMoreTap;

  TrackTile({
    super.key,
    required this.track,
    this.queue,
    this.index,
    this.onMoreTap,
  });

  final AudioService _audioService = AudioService();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _audioService,
      builder: (context, _) {
        final isCurrentTrack = _audioService.currentTrack?.id == track.id;
        final isPlaying = isCurrentTrack && _audioService.isPlaying;
        final isLiked = _audioService.isTrackLiked(track.id);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: isCurrentTrack
                      ? track.gradientColors.first.withOpacity(0.18)
                      : Colors.white.withOpacity(0.05),
                  border: Border.all(
                    color: isCurrentTrack
                        ? track.gradientColors.first.withOpacity(0.4)
                        : Colors.white.withOpacity(0.08),
                    width: 1.0,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      _audioService.playTrack(track, newQueue: queue);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Row(
                        children: [
                          // Index or Play indicator
                          if (index != null)
                            SizedBox(
                              width: 24,
                              child: isCurrentTrack
                                  ? WaveVisualizer(
                                      barCount: 3,
                                      height: 16,
                                      barWidth: 2.5,
                                      gradientColors: track.gradientColors,
                                    )
                                  : Text(
                                      '${index! + 1}',
                                      style: TextStyle(
                                        color: AppColors.textMuted,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          if (index != null) const SizedBox(width: 8),

                          // Cover Art with Hero
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Stack(
                              children: [
                                Image.network(
                                  track.coverUrl,
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 48,
                                    height: 48,
                                    color: Colors.grey.shade900,
                                    child: const Icon(Icons.music_note, color: Colors.white54),
                                  ),
                                ),
                                if (isPlaying)
                                  Container(
                                    width: 48,
                                    height: 48,
                                    color: Colors.black38,
                                    child: const Center(
                                      child: Icon(
                                        Icons.volume_up_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 14),

                          // Title and Artist
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  track.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: isCurrentTrack
                                        ? AppColors.primaryYandex
                                        : AppColors.textPrimary,
                                    fontSize: 15,
                                    fontWeight: isCurrentTrack
                                        ? FontWeight.bold
                                        : FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  track.artist,
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

                          // Heart Favorite Button
                          AnimatedHeartButton(
                            size: 22,
                            isLiked: isLiked,
                            onTap: () => _audioService.toggleLike(track),
                          ),
                          const SizedBox(width: 6),

                          // More button
                          IconButton(
                            icon: const Icon(Icons.more_vert_rounded, color: Colors.white54, size: 20),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: onMoreTap ?? () {
                              _showTrackOptions(context, track);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showTrackOptions(BuildContext context, Track track) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
              decoration: BoxDecoration(
                color: const Color(0xFF161829).withOpacity(0.92),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                border: Border.all(color: Colors.white.withOpacity(0.15)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white30,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(track.coverUrl, width: 50, height: 50, fit: BoxFit.cover),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(track.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(track.artist, style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white12, height: 32),
                  ListTile(
                    leading: const Icon(Icons.playlist_add_rounded, color: Colors.white),
                    title: const Text('Добавить в плейлист'),
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Добавлено в плейлист')),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.share_rounded, color: Colors.white),
                    title: const Text('Поделиться треком'),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    leading: const Icon(Icons.radio_rounded, color: Colors.white),
                    title: const Text('Включить радио по треку'),
                    onTap: () {
                      Navigator.pop(context);
                      _audioService.playTrack(track);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
