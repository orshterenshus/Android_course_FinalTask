import 'package:flutter/material.dart';

import '../widgets/services_grid.dart';
import 'ex3_second_menu_screen.dart';

const Color _blue = Color(0xFF1E88E5);

/// Exercise 3 — service grid with a right-arrow button that opens a
/// second menu screen (which has its own back button).
class Ex3ServiceDashboardScreen extends StatelessWidget {
  const Ex3ServiceDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: const SafeArea(child: ServicesGrid()),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _blue,
        foregroundColor: Colors.white,
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const Ex3SecondMenuScreen()),
        ),
        child: const Icon(Icons.chevron_right, size: 30),
      ),
    );
  }
}
