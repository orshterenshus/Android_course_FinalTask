import 'package:flutter/material.dart';

/// Centralized, kid-friendly visual theme for the whole application.
///
/// Keeping the theme in one place means every screen automatically shares the
/// same rounded shapes, playful colors and typography, which keeps the GUI
/// consistent and easy to tweak.
class AppTheme {
  AppTheme._(); // This class is not meant to be instantiated.

  /// Primary brand color — a warm, friendly purple.
  static const Color primary = Color(0xFF7C4DFF);

  /// Soft background used behind cards and lists.
  static const Color background = Color(0xFFF6F4FF);

  /// A rotating palette of cheerful colors assigned to the category cards so
  /// the home screen feels bright and playful.
  static const List<Color> cardColors = <Color>[
    Color(0xFFFF8A65), // Orange.
    Color(0xFF4DB6AC), // Teal.
    Color(0xFFBA68C8), // Purple.
    Color(0xFF64B5F6), // Blue.
    Color(0xFFFFB74D), // Amber.
    Color(0xFF81C784), // Green.
  ];

  /// Builds the global [ThemeData] for the app.
  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: background,
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}
