import 'package:flutter/material.dart';
import '../models/track.dart';
import '../models/playlist.dart';

class MockData {
  static final List<Track> allTracks = [
    Track(
      id: '1',
      title: 'Neon Horizon',
      artist: 'Cyber Pulse & Ksenia',
      album: 'Future Dreams 2026',
      coverUrl: 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=800&q=80',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      duration: const Duration(minutes: 6, seconds: 12),
      genre: 'Synthwave',
      mood: 'Энергия',
      gradientColors: const [Color(0xFFFF2A85), Color(0xFF8A2BE2), Color(0xFF00F0FF)],
      lyrics: const [
        LyricLine(timestamp: Duration(seconds: 0), text: 'Вспышки неоновых огней города...'),
        LyricLine(timestamp: Duration(seconds: 6), text: 'Скорость в крови, ночной бульвар'),
        LyricLine(timestamp: Duration(seconds: 14), text: 'Мы летим сквозь стеклянный туман'),
        LyricLine(timestamp: Duration(seconds: 22), text: 'Только ритм и биение сердца'),
        LyricLine(timestamp: Duration(seconds: 30), text: 'FlashMusic звучит в темноте'),
        LyricLine(timestamp: Duration(seconds: 40), text: 'Жидкий свет отражается в стекле'),
        LyricLine(timestamp: Duration(seconds: 52), text: 'Бесконечная волна звука...'),
      ],
    ),
    Track(
      id: '2',
      title: 'Midnight Velvet',
      artist: 'Aura Bloom',
      album: 'Midnight Tokyo',
      coverUrl: 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=800&q=80',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
      duration: const Duration(minutes: 7, seconds: 5),
      genre: 'Deep House',
      mood: 'Ночной драйв',
      gradientColors: const [Color(0xFF3A0CA3), Color(0xFF4361EE), Color(0xFF4CC9F0)],
      lyrics: const [
        LyricLine(timestamp: Duration(seconds: 0), text: 'Капли дождя на лобовом стекле'),
        LyricLine(timestamp: Duration(seconds: 10), text: 'Глубокий бас раскачивает ночь'),
        LyricLine(timestamp: Duration(seconds: 20), text: 'Тысячи мыслей уходят прочь'),
        LyricLine(timestamp: Duration(seconds: 32), text: 'Остается лишь чистая мелодия'),
        LyricLine(timestamp: Duration(seconds: 46), text: 'Плывем по течению Моей Волны'),
      ],
    ),
    Track(
      id: '3',
      title: 'Cosmic Flow',
      artist: 'Solaris',
      album: 'Orbit 9',
      coverUrl: 'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad?w=800&q=80',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
      duration: const Duration(minutes: 5, seconds: 44),
      genre: 'Ambient / Lo-Fi',
      mood: 'Спокойствие',
      gradientColors: const [Color(0xFF00C6FF), Color(0xFF0072FF), Color(0xFF00F5D4)],
      lyrics: const [
        LyricLine(timestamp: Duration(seconds: 0), text: 'Легкий бриз над открытым океаном'),
        LyricLine(timestamp: Duration(seconds: 12), text: 'Звезды складываются в созвездия'),
        LyricLine(timestamp: Duration(seconds: 24), text: 'Дыши глубже, оставь суету'),
        LyricLine(timestamp: Duration(seconds: 36), text: 'Музыка заполняет пространство'),
      ],
    ),
    Track(
      id: '4',
      title: 'Aurora Borealis',
      artist: 'Nordic Echo',
      album: 'Glacier Songs',
      coverUrl: 'https://images.unsplash.com/photo-1531306728370-e2ebd9d7bb99?w=800&q=80',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3',
      duration: const Duration(minutes: 6, seconds: 30),
      genre: 'Chillstep',
      mood: 'Вдохновение',
      gradientColors: const [Color(0xFF8E2DE2), Color(0xFF4A00E0), Color(0xFFFF2A85)],
      lyrics: const [
        LyricLine(timestamp: Duration(seconds: 0), text: 'Северное сияние танцует в небе'),
        LyricLine(timestamp: Duration(seconds: 15), text: 'Переливы изумрудного и пурпурного'),
        LyricLine(timestamp: Duration(seconds: 30), text: 'Свет струится сквозь лед и стекло'),
        LyricLine(timestamp: Duration(seconds: 45), text: 'Вдохновение в каждом такте'),
      ],
    ),
    Track(
      id: '5',
      title: 'Summer Sunlight',
      artist: 'Max Mirage & Rita',
      album: 'Golden Days',
      coverUrl: 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=800&q=80',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-10.mp3',
      duration: const Duration(minutes: 8, seconds: 15),
      genre: 'Pop / Dance',
      mood: 'Радость',
      gradientColors: const [Color(0xFFFFDD00), Color(0xFFFF416C), Color(0xFFFF4B2B)],
      lyrics: const [
        LyricLine(timestamp: Duration(seconds: 0), text: 'Солнечные лучи пробиваются сквозь жалюзи'),
        LyricLine(timestamp: Duration(seconds: 10), text: 'Улыбнись новому дню'),
        LyricLine(timestamp: Duration(seconds: 22), text: 'Саундтрек твоего лета здесь'),
        LyricLine(timestamp: Duration(seconds: 35), text: 'Танцуй, пока звучит музыка!'),
      ],
    ),
  ];

  static List<Playlist> getPlaylists() {
    return [
      Playlist(
        id: 'chart_top',
        title: 'Чарт Топ-50',
        subtitle: 'Главные треки прямо сейчас',
        coverUrl: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=800&q=80',
        gradient: const [Color(0xFFFFDD00), Color(0xFFFF5252)],
        tracks: allTracks,
        category: 'chart',
      ),
      Playlist(
        id: 'daily_mix_1',
        title: 'Daily Mix 1',
        subtitle: 'Cyber Pulse, Aura Bloom и другие',
        coverUrl: 'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=800&q=80',
        gradient: const [Color(0xFF00F0FF), Color(0xFF7000FF)],
        tracks: [allTracks[0], allTracks[1], allTracks[3]],
        category: 'daily',
      ),
      Playlist(
        id: 'daily_mix_2',
        title: 'Daily Mix 2: Relax',
        subtitle: 'Solaris, Nordic Echo',
        coverUrl: 'https://images.unsplash.com/photo-1459749411175-04bf5292ceea?w=800&q=80',
        gradient: const [Color(0xFF00F5D4), Color(0xFF0072FF)],
        tracks: [allTracks[2], allTracks[3]],
        category: 'daily',
      ),
      Playlist(
        id: 'energy_wave',
        title: 'Энергичный Заряд',
        subtitle: 'Для спорта и движения',
        coverUrl: 'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?w=800&q=80',
        gradient: const [Color(0xFFFF0844), Color(0xFFFFB199)],
        tracks: [allTracks[0], allTracks[4]],
        category: 'genre',
      ),
    ];
  }

  static const List<Map<String, dynamic>> waveMoods = [
    {
      'id': 'my_wave',
      'label': 'Моя волна',
      'icon': '✨',
      'gradient': [Color(0xFFFF2A85), Color(0xFF8A2BE2), Color(0xFF00F0FF)],
    },
    {
      'id': 'energy',
      'label': 'Бодрое',
      'icon': '⚡',
      'gradient': [Color(0xFFFF0844), Color(0xFFFF7A00)],
    },
    {
      'id': 'calm',
      'label': 'Спокойное',
      'icon': '🌊',
      'gradient': [Color(0xFF00C6FF), Color(0xFF0072FF)],
    },
    {
      'id': 'inspiration',
      'label': 'Вдохновение',
      'icon': '🔮',
      'gradient': [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
    },
    {
      'id': 'night',
      'label': 'Ночной драйв',
      'icon': '🌙',
      'gradient': [Color(0xFF3A0CA3), Color(0xFF4361EE)],
    },
    {
      'id': 'joy',
      'label': 'Радостное',
      'icon': '☀️',
      'gradient': [Color(0xFFFFDD00), Color(0xFFFF416C)],
    },
  ];

  static const List<Map<String, dynamic>> searchGenres = [
    {
      'name': 'Электроника',
      'gradient': [Color(0xFF00F0FF), Color(0xFF0072FF)],
      'icon': Icons.flash_on_rounded,
    },
    {
      'name': 'Хип-хоп & Рэп',
      'gradient': [Color(0xFFFF5E3A), Color(0xFFFF2A68)],
      'icon': Icons.mic_rounded,
    },
    {
      'name': 'Синтвейв 80-х',
      'gradient': [Color(0xFFFF2A85), Color(0xFF8A2BE2)],
      'icon': Icons.album_rounded,
    },
    {
      'name': 'Lo-Fi Chill',
      'gradient': [Color(0xFF00F5D4), Color(0xFF009688)],
      'icon': Icons.spa_rounded,
    },
    {
      'name': 'Топ Рок',
      'gradient': [Color(0xFF7B2CBF), Color(0xFFE024C3)],
      'icon': Icons.music_note_rounded,
    },
    {
      'name': 'Поп Музыка',
      'gradient': [Color(0xFFFFDD00), Color(0xFFFF6F00)],
      'icon': Icons.star_rounded,
    },
  ];
}
