import 'package:flutter/material.dart';

class ZelvoraTheme {
  ZelvoraTheme._();

  static const Color botanicalDark = Color(0xFF0D1811);
  static const Color surfaceGreen = Color(0xFF16251C);
  static const Color surfaceElevated = Color(0xFF1E3326);
  static const Color emeraldPrimary = Color(0xFF2E8B57);
  static const Color mintAccent = Color(0xFF48D1CC);
  static const Color amberBloom = Color(0xFFE5A93C);
  static const Color coralAlert = Color(0xFFE06D53);
  static const Color textHigh = Color(0xFFE8F2EA);
  static const Color textMuted = Color(0xFF8FA896);
  static const Color borderSubtle = Color(0xFF274332);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: botanicalDark,
      primaryColor: emeraldPrimary,
      colorScheme: const ColorScheme.dark(
        primary: emeraldPrimary,
        secondary: mintAccent,
        surface: surfaceGreen,
        error: coralAlert,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: textHigh,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceGreen,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textHigh,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
        iconTheme: IconThemeData(color: textHigh),
      ),
      cardTheme: CardThemeData(
        color: surfaceGreen,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderSubtle, width: 1),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceGreen,
        indicatorColor: emeraldPrimary.withAlpha(50),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: mintAccent,
            );
          }
          return const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textMuted,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: mintAccent);
          }
          return const IconThemeData(color: textMuted);
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceElevated,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderSubtle),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: mintAccent, width: 1.5),
        ),
        hintStyle: const TextStyle(color: textMuted, fontSize: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: emeraldPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
