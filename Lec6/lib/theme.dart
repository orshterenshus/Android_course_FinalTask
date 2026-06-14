import 'package:flutter/material.dart';

/// Shared brand color for the launcher and chrome.
const Color kBrandColor = Color(0xFF2F8F4E); // friendly green

/// App-wide theme mode. The Dark Mode toggle in Settings flips this and the
/// root [MaterialApp] rebuilds, so the whole app switches themes live.
final ValueNotifier<ThemeMode> themeNotifier =
    ValueNotifier<ThemeMode>(ThemeMode.light);

ThemeData buildAppTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: kBrandColor,
    brightness: Brightness.light,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: const Color(0xFFF7F8FA),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
    ),
  );
}

ThemeData buildDarkTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: kBrandColor,
    brightness: Brightness.dark,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
    ),
  );
}
