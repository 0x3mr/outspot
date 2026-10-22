import 'package:flutter/material.dart';

import '../../core/navigation/app_routes.dart';
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
    floatingActionButton: FloatingActionButton(
      tooltip: 'Create a spot',
      onPressed: () => Navigator.pushNamed(context, AppRoutes.createSpot),
      child: const Icon(Icons.add),
    ),
    bottomNavigationBar: BottomAppBar(
      height: 72,
      shape: const CircularNotchedRectangle(),
      notchMargin: 7,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.home_outlined,
            selectedIcon: Icons.home,
            label: 'Feed',
            selected: _selectedIndex == 0,
            onTap: () => _selectTab(0),
          ),
          _NavItem(
            icon: Icons.explore_outlined,
            selectedIcon: Icons.explore,
            label: 'Explore',
            selected: _selectedIndex == 1,
            onTap: () => _selectTab(1),
          ),
          const SizedBox(width: 52),
          _NavItem(
            icon: Icons.bookmark_border,
            selectedIcon: Icons.bookmark,
            label: 'Saved',
            selected: _selectedIndex == 2,
            onTap: () => _selectTab(2),
          ),
          _NavItem(
            icon: Icons.person_outline,
            selectedIcon: Icons.person,
            label: 'Profile',
            selected: _selectedIndex == 3,
            onTap: () => _selectTab(3),
          ),
        ],
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
    final color = selected
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onSurfaceVariant;
    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        label: label,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(selected ? selectedIcon : icon, color: color, size: 20),
              const SizedBox(height: 1),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
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
    );
  }
}
