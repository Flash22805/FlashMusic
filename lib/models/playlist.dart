import 'package:flutter/material.dart';
import 'track.dart';

class Playlist {
  final String id;
  final String title;
  final String subtitle;
  final String coverUrl;
  final List<Color> gradient;
  final List<Track> tracks;
  final String category; // 'chart', 'daily', 'genre', 'personal'

  Playlist({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.coverUrl,
    required this.gradient,
    required this.tracks,
    this.category = 'daily',
  });
}
