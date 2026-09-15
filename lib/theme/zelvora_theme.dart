import 'package:flutter/material.dart';

class ZelvoraTheme {
  static const background = Color(0xFFF5FAF6);
  static const surface = Color(0xFFFFFFFF);
  static const card = Color(0xFFE8F5EC);
  static const emerald = Color(0xFF059669);
  static const mint = Color(0xFF34D399);
  static const forest = Color(0xFF064E3B);
  static const textPrimary = Color(0xFF064E3B);
  static const textSecondary = Color(0xFF4B5563);

  static ThemeData get themeData {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: background,
      primaryColor: emerald,
      cardColor: card,
      fontFamily: 'AppFont',
      colorScheme: const ColorScheme.light(
        primary: emerald,
        secondary: mint,
        surface: surface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
