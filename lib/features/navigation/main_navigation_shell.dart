import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/navigation/app_routes.dart';
import '../../core/theme/app_theme.dart';
import '../explore/screens/explore_screen.dart';
import '../feed/screens/feed_screen.dart';
import '../profile/screens/profile_screen.dart';
import '../saved/screens/saved_screen.dart';

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  late int _selectedIndex;

  static const _titles = ['Feed', 'Explore', 'Saved', 'Profile'];
  static const _pages = [
    FeedScreen(),
    ExploreScreen(),
    SavedScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex.clamp(0, _pages.length - 1);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(_titles[_selectedIndex])),
    body: IndexedStack(index: _selectedIndex, children: _pages),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    floatingActionButton: Container(
      width: 58,
      height: 58,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: Color(0x66A855F7),
            blurRadius: 18,
            spreadRadius: 1,
            offset: Offset(0, 4),
          ),
          BoxShadow(
            color: Color(0x3306B6D4),
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: FloatingActionButton(
        tooltip: 'Create a spot',
        elevation: 0,
        highlightElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        onPressed: () => Navigator.pushNamed(context, AppRoutes.createSpot),
        child: const Icon(Icons.add_rounded, size: 30),
      ),
    ),
    bottomNavigationBar: ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.88),
            border: const Border(
              top: BorderSide(color: AppColors.softBorder, width: 1),
            ),
          ),
          child: BottomAppBar(
            color: Colors.transparent,
            elevation: 0,
            height: 72,
            shape: const CircularNotchedRectangle(),
            notchMargin: 8,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.home_outlined,
                  selectedIcon: Icons.home_rounded,
                  label: 'Feed',
                  selected: _selectedIndex == 0,
                  onTap: () => _selectTab(0),
                ),
                _NavItem(
                  icon: Icons.explore_outlined,
                  selectedIcon: Icons.explore_rounded,
                  label: 'Explore',
                  selected: _selectedIndex == 1,
                  onTap: () => _selectTab(1),
                ),
                const SizedBox(width: 52),
                _NavItem(
                  icon: Icons.bookmark_border_rounded,
                  selectedIcon: Icons.bookmark_rounded,
                  label: 'Saved',
                  selected: _selectedIndex == 2,
                  onTap: () => _selectTab(2),
                ),
                _NavItem(
                  icon: Icons.person_outline_rounded,
                  selectedIcon: Icons.person_rounded,
                  label: 'Profile',
                  selected: _selectedIndex == 3,
                  onTap: () => _selectTab(3),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  void _selectTab(int index) => setState(() => _selectedIndex = index);
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final activeColor = AppColors.electricPurple;
    final inactiveColor = AppColors.slateGray;
    final color = selected ? activeColor : inactiveColor;

    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        label: label,
        child: Material(
          color: Colors.transparent,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            splashColor: AppColors.electricPurple.withValues(alpha: 0.12),
            highlightColor: AppColors.electricPurple.withValues(alpha: 0.05),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: selected
                          ? AppColors.softLavender
                          : Colors.transparent,
                    ),
                    child: Icon(
                      selected ? selectedIcon : icon,
                      color: color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: color,
                      fontSize: 10,
                      height: 1,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
