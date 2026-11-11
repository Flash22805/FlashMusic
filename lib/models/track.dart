import 'package:flutter/material.dart';

class LyricLine {
  final Duration timestamp;
  final String text;

  const LyricLine({required this.timestamp, required this.text});
}

class Track {
  final String id;
  final String title;
  final String artist;
  final String album;
  final String coverUrl;
  final String audioUrl;
  final Duration duration;
  final String genre;
  final String mood;
  final List<Color> gradientColors;
  final List<LyricLine> lyrics;
  bool isLiked;

  Track({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.coverUrl,
    required this.audioUrl,
    required this.duration,
    required this.genre,
    required this.mood,
    required this.gradientColors,
    required this.lyrics,
    this.isLiked = false,
  });

  Track copyWith({
    String? id,
    String? title,
    String? artist,
    String? album,
    String? coverUrl,
    String? audioUrl,
    Duration? duration,
    String? genre,
    String? mood,
    List<Color>? gradientColors,
    List<LyricLine>? lyrics,
    bool? isLiked,
  }) {
    return Track(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      coverUrl: coverUrl ?? this.coverUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      duration: duration ?? this.duration,
      genre: genre ?? this.genre,
      mood: mood ?? this.mood,
      gradientColors: gradientColors ?? this.gradientColors,
      lyrics: lyrics ?? this.lyrics,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}
