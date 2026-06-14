import 'package:flutter/material.dart';

import '../widgets/services_grid.dart';
import 'ex3_second_menu_screen.dart';
import 'ex5_profile_screen.dart';
import 'ex6_settings_screen.dart';

const Color _blue = Color(0xFF1E88E5);

/// Exercise 4 — duplicates the dashboard and adds a BottomNavigationBar with
/// three tabs (Home, Settings, Profile), each showing different content.
class Ex4BottomNavScreen extends StatefulWidget {
  const Ex4BottomNavScreen({super.key});

  @override
  State<Ex4BottomNavScreen> createState() => _Ex4BottomNavScreenState();
}

class _Ex4BottomNavScreenState extends State<Ex4BottomNavScreen> {
  int _index = 0;

  static const _titles = ['Home', 'Settings', 'Profile'];

  @override
  Widget build(BuildContext context) {
    final pages = const [
      ServicesGrid(),
      SettingsBody(),
      ProfileBody(),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(_titles[_index])),
      body: SafeArea(child: pages[_index]),
      // The right-arrow menu from Exercise 3 stays available on the Home tab.
      floatingActionButton: _index == 0
          ? FloatingActionButton(
              backgroundColor: _blue,
              foregroundColor: Colors.white,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (_) => const Ex3SecondMenuScreen()),
              ),
              child: const Icon(Icons.chevron_right, size: 30),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: 'Settings'),
          NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile'),
        ],
      ),
    );
  }
}
