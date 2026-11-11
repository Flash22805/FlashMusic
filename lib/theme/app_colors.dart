import 'package:flutter/material.dart';

class AppColors {
  // Deep space background
  static const Color background = Color(0xFF0A0B12);
  static const Color backgroundSecondary = Color(0xFF10121F);

  // Brand Accents (Yandex Music Yellow + Spotify Neon Green + iOS Vivid gradients)
  static const Color primaryYandex = Color(0xFFFFDD00);
  static const Color primarySpotify = Color(0xFF1DB954);
  static const Color accentCyan = Color(0xFF00F0FF);
  static const Color accentPink = Color(0xFFFF2A85);
  static const Color accentPurple = Color(0xFF8A2BE2);
  static const Color accentOrange = Color(0xFFFF7A00);

  // Glassmorphism overlays
  static Color glassBackground = Colors.white.withOpacity(0.08);
  static Color glassBackgroundActive = Colors.white.withOpacity(0.15);
  static Color glassBorder = Colors.white.withOpacity(0.16);
  static Color glassBorderSubtle = Colors.white.withOpacity(0.08);
  static Color glassBorderActive = Colors.white.withOpacity(0.35);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9EA6BD);
  static const Color textMuted = Color(0xFF5D647B);

  // Wave Mood Gradients
  static const List<Color> waveEnergize = [
    Color(0xFFFF0844),
    Color(0xFFFFB199),
    Color(0xFFFF7A00),
  ];

  static const List<Color> waveCalm = [
    Color(0xFF00C6FF),
    Color(0xFF0072FF),
    Color(0xFF00F5D4),
  ];

  static const List<Color> waveInspiration = [
    Color(0xFF8E2DE2),
    Color(0xFF4A00E0),
    Color(0xFFFF2A85),
  ];

  static const List<Color> waveNight = [
    Color(0xFF1F1C2C),
    Color(0xFF928DAB),
    Color(0xFF4361EE),
  ];

  static const List<Color> waveJoy = [
    Color(0xFFFFDD00),
    Color(0xFFFF416C),
    Color(0xFFFF4B2B),
  ];
}
