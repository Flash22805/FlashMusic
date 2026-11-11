import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/liquid_background.dart';
import '../widgets/mini_player.dart';
import 'home_screen.dart';
import 'wave_screen.dart';
import 'search_screen.dart';
import 'library_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  void _onTabSelect(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(onTabChange: _onTabSelect),
      WaveScreen(),
      const SearchScreen(),
      const LibraryScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: LiquidBackground(
        child: Stack(
          children: [
            // Screen content
            IndexedStack(
              index: _currentIndex,
              children: screens,
            ),

            // Bottom Floating Controls (MiniPlayer + Glass Dock)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Mini Player
                  MiniPlayer(),

                  // iOS Frosted Glass Dock
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(34),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                        child: Container(
                          height: 64,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.09),
                            borderRadius: BorderRadius.circular(34),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.22),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.35),
                                blurRadius: 24,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildNavItem(0, Icons.home_rounded, 'Главная'),
                              _buildNavItem(1, Icons.waves_rounded, 'Волна', isWave: true),
                              _buildNavItem(2, Icons.search_rounded, 'Поиск'),
                              _buildNavItem(3, Icons.library_music_rounded, 'Коллекция'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, {bool isWave = false}) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () => _onTabSelect(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: isSelected ? Colors.white.withOpacity(0.18) : Colors.transparent,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: isWave
                        ? AppColors.accentPink.withOpacity(0.35)
                        : Colors.white.withOpacity(0.12),
                    blurRadius: 14,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: isWave ? 26 : 24,
              color: isSelected
                  ? (isWave ? AppColors.primaryYandex : Colors.white)
                  : Colors.white60,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white54,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
