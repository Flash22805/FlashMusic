import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/track.dart';
import 'mock_data.dart';

enum MusicRepeatMode { off, all, one }

class AudioService extends ChangeNotifier {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;

  final AudioPlayer _player = AudioPlayer();
  final Random _random = Random();

  List<Track> _queue = [];
  int _currentIndex = 0;
  Track? _currentTrack;
  bool _isPlaying = false;
  bool _isLoading = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isShuffle = false;
  MusicRepeatMode _repeatMode = MusicRepeatMode.all;
  final Set<String> _likedTrackIds = {'1', '2'};
  String _activeMood = 'my_wave';
  double _volume = 1.0;

  // Real-time animated visualizer levels (24 bars)
  List<double> _visualizerBars = List.filled(24, 0.15);
  Timer? _visualizerTimer;

  // Stream subscriptions
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _completeSubscription;

  AudioService._internal() {
    _initAudio();
  }

  // Getters
  List<Track> get queue => _queue;
  int get currentIndex => _currentIndex;
  Track? get currentTrack => _currentTrack;
  bool get isPlaying => _isPlaying;
  bool get isLoading => _isLoading;
  Duration get position => _position;
  Duration get duration => _duration;
  bool get isShuffle => _isShuffle;
  MusicRepeatMode get repeatMode => _repeatMode;
  Set<String> get likedTrackIds => _likedTrackIds;
  String get activeMood => _activeMood;
  double get volume => _volume;
  List<double> get visualizerBars => _visualizerBars;

  void _initAudio() {
    _queue = List.from(MockData.allTracks);
    if (_queue.isNotEmpty) {
      _currentTrack = _queue[0];
      _duration = _currentTrack!.duration;
    }

    _playerStateSubscription = _player.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
      if (_isPlaying) {
        _isLoading = false;
        _startVisualizer();
      } else {
        _stopVisualizer();
      }
      notifyListeners();
    });

    _positionSubscription = _player.onPositionChanged.listen((pos) {
      _position = pos;
      notifyListeners();
    });

    _durationSubscription = _player.onDurationChanged.listen((dur) {
      if (dur > Duration.zero) {
        _duration = dur;
        notifyListeners();
      }
    });

    _completeSubscription = _player.onPlayerComplete.listen((_) {
      if (_repeatMode == MusicRepeatMode.one) {
        seek(Duration.zero);
        resume();
      } else {
        next();
      }
    });
  }

  void _startVisualizer() {
    _visualizerTimer?.cancel();
    _visualizerTimer = Timer.periodic(const Duration(milliseconds: 60), (_) {
      if (!_isPlaying) return;
      final newBars = List<double>.generate(24, (i) {
        // Organic simulated equalizer wave
        final wave = sin(DateTime.now().millisecondsSinceEpoch / 250.0 + i * 0.4);
        final base = (wave + 1) * 0.35;
        final jitter = _random.nextDouble() * 0.3;
        return (base + jitter).clamp(0.12, 1.0);
      });
      _visualizerBars = newBars;
      notifyListeners();
    });
  }

  void _stopVisualizer() {
    _visualizerTimer?.cancel();
    _visualizerBars = List.filled(24, 0.1);
    notifyListeners();
  }

  Future<void> playTrack(Track track, {List<Track>? newQueue}) async {
    if (newQueue != null) {
      _queue = List.from(newQueue);
    } else if (!_queue.any((t) => t.id == track.id)) {
      _queue.add(track);
    }
    _currentIndex = _queue.indexWhere((t) => t.id == track.id);
    if (_currentIndex == -1) _currentIndex = 0;

    _currentTrack = track;
    _position = Duration.zero;
    _duration = track.duration;
    _isLoading = true;
    notifyListeners();

    try {
      await _player.stop();
      await _player.play(UrlSource(track.audioUrl));
    } catch (e) {
      debugPrint('Error playing audio: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resume() async {
    if (_currentTrack == null && _queue.isNotEmpty) {
      await playTrack(_queue.first);
      return;
    }
    await _player.resume();
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> togglePlayPause() async {
    if (_isPlaying) {
      await pause();
    } else {
      await resume();
    }
  }

  Future<void> seek(Duration newPosition) async {
    _position = newPosition;
    notifyListeners();
    await _player.seek(newPosition);
  }

  Future<void> next() async {
    if (_queue.isEmpty) return;
    if (_isShuffle) {
      _currentIndex = _random.nextInt(_queue.length);
    } else {
      _currentIndex = (_currentIndex + 1) % _queue.length;
    }
    await playTrack(_queue[_currentIndex]);
  }

  Future<void> previous() async {
    if (_queue.isEmpty) return;
    if (_position.inSeconds > 3) {
      await seek(Duration.zero);
      return;
    }
    _currentIndex = (_currentIndex - 1 + _queue.length) % _queue.length;
    await playTrack(_queue[_currentIndex]);
  }

  void toggleShuffle() {
    _isShuffle = !_isShuffle;
    notifyListeners();
  }

  void toggleRepeat() {
    if (_repeatMode == MusicRepeatMode.off) {
      _repeatMode = MusicRepeatMode.all;
    } else if (_repeatMode == MusicRepeatMode.all) {
      _repeatMode = MusicRepeatMode.one;
    } else {
      _repeatMode = MusicRepeatMode.off;
    }
    notifyListeners();
  }

  void toggleLike(Track track) {
    if (_likedTrackIds.contains(track.id)) {
      _likedTrackIds.remove(track.id);
      track.isLiked = false;
    } else {
      _likedTrackIds.add(track.id);
      track.isLiked = true;
    }
    notifyListeners();
  }

  bool isTrackLiked(String trackId) {
    return _likedTrackIds.contains(trackId);
  }

  void setMood(String moodId) {
    _activeMood = moodId;
    // Filter queue or adapt tracks based on mood
    final matchingTracks = MockData.allTracks.where((t) {
      if (moodId == 'energy') return t.mood == 'Энергия' || t.genre.contains('Dance');
      if (moodId == 'calm') return t.mood == 'Спокойствие' || t.genre.contains('Ambient');
      if (moodId == 'night') return t.mood == 'Ночной драйв';
      if (moodId == 'inspiration') return t.mood == 'Вдохновение';
      if (moodId == 'joy') return t.mood == 'Радость';
      return true;
    }).toList();

    if (matchingTracks.isNotEmpty) {
      _queue = matchingTracks;
      if (!_isPlaying || _currentTrack == null || !_queue.contains(_currentTrack)) {
        playTrack(_queue.first);
      }
    }
    notifyListeners();
  }

  void setVolume(double val) {
    _volume = val.clamp(0.0, 1.0);
    _player.setVolume(_volume);
    notifyListeners();
  }

  @override
  void dispose() {
    _playerStateSubscription?.cancel();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _completeSubscription?.cancel();
    _visualizerTimer?.cancel();
    _player.dispose();
    super.dispose();
  }
}
