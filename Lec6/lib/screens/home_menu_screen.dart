import 'package:flutter/material.dart';

import '../theme.dart';
import 'ex1_phone_entry_screen.dart';
import 'ex2_download_screen.dart';
import 'ex3_service_dashboard_screen.dart';
import 'ex4_bottom_nav_screen.dart';
import 'ex5_profile_screen.dart';
import 'ex6_settings_screen.dart';
import 'ex6b_resume_screen.dart';

/// Launcher that lists every class exercise and opens each one.
class HomeMenuScreen extends StatelessWidget {
  const HomeMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <_ExerciseItem>[
      _ExerciseItem(
        number: '1',
        title: 'Phone Login',
        subtitle: 'Two screens: enter phone → verify OTP',
        icon: Icons.phone_android,
        color: const Color(0xFF2F8F4E),
        builder: (_) => const Ex1PhoneEntryScreen(),
      ),
      _ExerciseItem(
        number: '2',
        title: 'Download Apps',
        subtitle: 'GET → progress spinner → OPEN (dummy)',
        icon: Icons.download_rounded,
        color: const Color(0xFF1E88E5),
        builder: (_) => const Ex2DownloadScreen(),
      ),
      _ExerciseItem(
        number: '3',
        title: 'Service Dashboard',
        subtitle: 'Grid + right button opens a second menu',
        icon: Icons.grid_view_rounded,
        color: const Color(0xFFEF6C00),
        builder: (_) => const Ex3ServiceDashboardScreen(),
      ),
      _ExerciseItem(
        number: '4',
        title: 'Bottom Navigation',
        subtitle: 'Home · Settings · Profile tabs',
        icon: Icons.dashboard_rounded,
        color: const Color(0xFF6A1B9A),
        builder: (_) => const Ex4BottomNavScreen(),
      ),
      _ExerciseItem(
        number: '5',
        title: 'Profile',
        subtitle: 'Photo, contact details & social links',
        icon: Icons.person_rounded,
        color: const Color(0xFF00897B),
        builder: (_) => const Ex5ProfileScreen(),
      ),
      _ExerciseItem(
        number: '6',
        title: 'Settings',
        subtitle: 'Three toggle switches',
        icon: Icons.settings_rounded,
        color: const Color(0xFF455A64),
        builder: (_) => const Ex6SettingsScreen(),
      ),
      _ExerciseItem(
        number: '6b',
        title: 'Resume / Items',
        subtitle: 'Item list with upload buttons',
        icon: Icons.description_rounded,
        color: const Color(0xFFD81B60),
        builder: (_) => const Ex6bResumeScreen(),
      ),
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            backgroundColor: kBrandColor,
            foregroundColor: Colors.white,
            title: const Text('Lecture 6 – Class Exercises'),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList.separated(
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, i) => _ExerciseCard(item: items[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExerciseItem {
  const _ExerciseItem({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.builder,
  });

  final String number;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final WidgetBuilder builder;
}

class _ExerciseCard extends StatelessWidget {
  const _ExerciseCard({required this.item});

  final _ExerciseItem item;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: item.builder),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(item.icon, color: item.color, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: item.color,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Ex ${item.number}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
