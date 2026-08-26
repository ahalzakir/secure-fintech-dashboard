import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xFF090A0F);
  static const Color surface = Color(0xFF12141C);
  static const Color surfaceLight = Color(0xFF1C1F2B);
  static const Color border = Color(0xFF2A2E3D);

  static const Color accentNeon = Color(0xFF00FF87);
  static const Color accentCyan = Color(0xFF00E5FF);
  static const Color accentGold = Color(0xFFFFD700);

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8F94A6);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: accentNeon,
      colorScheme: const ColorScheme.dark(
        primary: accentNeon,
        secondary: accentCyan,
        surface: surface,
        onPrimary: Colors.black,
        onSurface: textPrimary,
      ),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: border, width: 1),
        ),
      ),
    );
  }
}
