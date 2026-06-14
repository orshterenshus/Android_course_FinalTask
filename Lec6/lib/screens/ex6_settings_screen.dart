import 'package:flutter/material.dart';

import '../theme.dart';

/// Exercise 6 — settings screen with three toggle switches.
class Ex6SettingsScreen extends StatelessWidget {
  const Ex6SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const SafeArea(child: SettingsBody()),
    );
  }
}

/// Reusable settings content (also used as the Settings tab in Exercise 4).
class SettingsBody extends StatefulWidget {
  const SettingsBody({super.key});

  @override
  State<SettingsBody> createState() => _SettingsBodyState();
}

class _SettingsBodyState extends State<SettingsBody> {
  bool _notifications = true;
  bool _location = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 8),
        _ToggleTile(
          icon: Icons.notifications_outlined,
          title: 'Notifications',
          subtitle: 'Receive push notifications',
          value: _notifications,
          onChanged: (v) => setState(() => _notifications = v),
        ),
        // Dark Mode is wired to the real app theme via [themeNotifier].
        ValueListenableBuilder<ThemeMode>(
          valueListenable: themeNotifier,
          builder: (context, mode, _) => _ToggleTile(
            icon: Icons.dark_mode_outlined,
            title: 'Dark Mode',
            subtitle: 'Use a darker color theme',
            value: mode == ThemeMode.dark,
            onChanged: (v) => themeNotifier.value =
                v ? ThemeMode.dark : ThemeMode.light,
          ),
        ),
        _ToggleTile(
          icon: Icons.location_on_outlined,
          title: 'Location Services',
          subtitle: 'Allow access to your location',
          value: _location,
          onChanged: (v) => setState(() => _location = v),
        ),
      ],
    );
  }
}

class _ToggleTile extends StatelessWidget {
  const _ToggleTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: SwitchListTile(
        secondary: Icon(icon, color: primary),
        title: Text(title,
            style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
