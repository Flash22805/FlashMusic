import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/track.dart';
import '../services/audio_service.dart';
import '../theme/app_colors.dart';
import 'animated_heart_button.dart';
import 'wave_visualizer.dart';

class FullPlayerSheet extends StatefulWidget {
  const FullPlayerSheet({super.key});

  @override
  State<FullPlayerSheet> createState() => _FullPlayerSheetState();
}

class _FullPlayerSheetState extends State<FullPlayerSheet>
    with SingleTickerProviderStateMixin {
  final AudioService _audioService = AudioService();
  bool _showLyrics = false;
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    );

    if (_audioService.isPlaying) {
      _rotationController.repeat();
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _audioService,
      builder: (context, _) {
        final track = _audioService.currentTrack;
        if (track == null) return const SizedBox.shrink();

        final isPlaying = _audioService.isPlaying;
        if (isPlaying && !_rotationController.isAnimating) {
          _rotationController.repeat();
        } else if (!isPlaying && _rotationController.isAnimating) {
          _rotationController.stop();
        }

        final position = _audioService.position;
        final duration = _audioService.duration;
        final isLiked = _audioService.isTrackLiked(track.id);

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              // Liquid Gradient Background Layer
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        track.gradientColors.first.withOpacity(0.55),
                        track.gradientColors.last.withOpacity(0.35),
                        AppColors.background,
                      ],
                    ),
                  ),
                ),
              ),

              // Frosted Glass Blur Backdrop
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                  child: Container(
                    color: Colors.black.withOpacity(0.45),
                  ),
                ),
              ),

              // Main Player Content
              SafeArea(
                child: Column(
                  children: [
                    // Top Drag Indicator & Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Column(
                        children: [
                          Container(
                            width: 38,
                            height: 4.5,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.35),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 32),
                                onPressed: () => Navigator.pop(context),
                              ),
                              Column(
                                children: [
                                  Text(
                                    'ИГРАЕТ ИЗ ВОЛНЫ',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    track.mood,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: Icon(
                                  _showLyrics ? Icons.album_rounded : Icons.lyrics_rounded,
                                  color: Colors.white,
                                  size: 26,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _showLyrics = !_showLyrics;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const Spacer(flex: 1),

                    // Center Content: Album Art OR Synced Lyrics
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 350),
                      crossFadeState: _showLyrics ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                      firstChild: _buildAlbumArtView(track, isPlaying),
                      secondChild: _buildLyricsView(track, position),
                    ),

                    const Spacer(flex: 1),

                    // Visualizer & Track Info Row
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  track.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  track.artist,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AnimatedHeartButton(
                            size: 30,
                            isLiked: isLiked,
                            onTap: () => _audioService.toggleLike(track),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Live Sound Wave Spectrum
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: WaveVisualizer(
                        barCount: 24,
                        height: 32,
                        barWidth: 4.5,
                        gradientColors: track.gradientColors,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Progress Scrubber Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 4,
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                              activeTrackColor: Colors.white,
                              inactiveTrackColor: Colors.white.withOpacity(0.18),
                              thumbColor: Colors.white,
                              overlayColor: Colors.white.withOpacity(0.2),
                            ),
                            child: Slider(
                              value: duration.inMilliseconds > 0
                                  ? position.inMilliseconds.clamp(0, duration.inMilliseconds).toDouble()
                                  : 0.0,
                              max: duration.inMilliseconds > 0
                                  ? duration.inMilliseconds.toDouble()
                                  : 1.0,
                              onChanged: (val) {
                                _audioService.seek(Duration(milliseconds: val.toInt()));
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDuration(position),
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  _formatDuration(duration),
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Main Glass Control Panel
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Shuffle
                          IconButton(
                            icon: Icon(
                              Icons.shuffle_rounded,
                              color: _audioService.isShuffle ? AppColors.primarySpotify : Colors.white60,
                              size: 26,
                            ),
                            onPressed: () => _audioService.toggleShuffle(),
                          ),

                          // Previous
                          IconButton(
                            icon: const Icon(
                              Icons.skip_previous_rounded,
                              color: Colors.white,
                              size: 38,
                            ),
                            onPressed: () => _audioService.previous(),
                          ),

                          // Play / Pause Giant Glass Pill
                          ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                              child: Container(
                                width: 76,
                                height: 76,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      Colors.white,
                                      Colors.white.withOpacity(0.9),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: track.gradientColors.first.withOpacity(0.6),
                                      blurRadius: 28,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  icon: _audioService.isLoading
                                      ? const SizedBox(
                                          width: 28,
                                          height: 28,
                                          child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.black),
                                        )
                                      : Icon(
                                          isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                          color: Colors.black,
                                          size: 42,
                                        ),
                                  onPressed: () => _audioService.togglePlayPause(),
                                ),
                              ),
                            ),
                          ),

                          // Next
                          IconButton(
                            icon: const Icon(
                              Icons.skip_next_rounded,
                              color: Colors.white,
                              size: 38,
                            ),
                            onPressed: () => _audioService.next(),
                          ),

                          // Repeat
                          IconButton(
                            icon: Icon(
                              _audioService.repeatMode == MusicRepeatMode.one
                                  ? Icons.repeat_one_rounded
                                  : Icons.repeat_rounded,
                              color: _audioService.repeatMode != MusicRepeatMode.off
                                  ? AppColors.primarySpotify
                                  : Colors.white60,
                              size: 26,
                            ),
                            onPressed: () => _audioService.toggleRepeat(),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(flex: 1),

                    // Bottom Queue & Devices Dock
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.devices_rounded, color: Colors.white60, size: 22),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Подключено устройство: Android Phone')),
                              );
                            },
                          ),
                          Text(
                            'FlashMusic Hi-Res Lossless',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.queue_music_rounded, color: Colors.white60, size: 24),
                            onPressed: () => _showQueueModal(context),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAlbumArtView(Track track, bool isPlaying) {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        width: isPlaying ? 290 : 250,
        height: isPlaying ? 290 : 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: track.gradientColors.first.withOpacity(isPlaying ? 0.45 : 0.2),
              blurRadius: isPlaying ? 40 : 20,
              spreadRadius: isPlaying ? 6 : 0,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                track.coverUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey.shade900,
                  child: const Icon(Icons.music_note, size: 80, color: Colors.white54),
                ),
              ),
              // Frosted Glass Highlight Border
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.35),
                    width: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLyricsView(Track track, Duration currentPos) {
    return SizedBox(
      height: 310,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: track.lyrics.length,
        itemBuilder: (context, i) {
          final line = track.lyrics[i];
          final isCurrent = currentPos >= line.timestamp &&
              (i == track.lyrics.length - 1 || currentPos < track.lyrics[i + 1].timestamp);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              style: TextStyle(
                fontSize: isCurrent ? 24 : 17,
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                color: isCurrent ? Colors.white : Colors.white38,
                shadows: isCurrent
                    ? [
                        BoxShadow(
                          color: track.gradientColors.first.withOpacity(0.8),
                          blurRadius: 18,
                        ),
                      ]
                    : null,
              ),
              child: Text(line.text),
            ),
          );
        },
      ),
    );
  }

  void _showQueueModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(
              height: 480,
              decoration: BoxDecoration(
                color: const Color(0xFF131524).withOpacity(0.94),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                border: Border.all(color: Colors.white.withOpacity(0.15)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white30,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Очередь воспроизведения',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _audioService.queue.length,
                      itemBuilder: (context, idx) {
                        final qTrack = _audioService.queue[idx];
                        final isCur = _audioService.currentTrack?.id == qTrack.id;
                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(qTrack.coverUrl, width: 44, height: 44, fit: BoxFit.cover),
                          ),
                          title: Text(
                            qTrack.title,
                            style: TextStyle(
                              color: isCur ? AppColors.primaryYandex : Colors.white,
                              fontWeight: isCur ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          subtitle: Text(qTrack.artist, style: TextStyle(color: AppColors.textSecondary)),
                          trailing: isCur
                              ? const Icon(Icons.equalizer_rounded, color: AppColors.primaryYandex)
                              : null,
                          onTap: () {
                            _audioService.playTrack(qTrack);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
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
