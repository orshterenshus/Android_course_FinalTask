import 'package:flutter/material.dart';

import 'screens/home_menu_screen.dart';
import 'theme.dart';

void main() {
  runApp(const AndroidCourse6App());
}

/// Root app for the Lecture 6 class exercises.
///
/// One app that hosts every exercise behind a simple launcher menu so each
/// one can be opened and demonstrated independently.
class AndroidCourse6App extends StatelessWidget {
  const AndroidCourse6App({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'Android Course – Lecture 6',
          debugShowCheckedModeBanner: false,
          theme: buildAppTheme(),
          darkTheme: buildDarkTheme(),
          themeMode: mode,
          home: const HomeMenuScreen(),
        );
      },
    );
  }
}
