import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Shared colors and visual styles used throughout the Nukar app.
class NukarTheme {
  static const Color primaryGreen = Color(0xFF1F8C4E);
  static const Color deepGreen = Color(0xFF0E6F39);
  static const Color accentGreen = Color(0xFF25B768);
  static const Color accentOrange = Color(0xFFFF8A00);
  static const Color paleMint = Color(0xFFD8F6E9);
  static const Color textDark = Color(0xFF1F2B2E);
  static const Color textMuted = Color(0xFF6E7C7C);
  static const Color surface = Colors.white;

  static ThemeData appTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryGreen,
      primary: primaryGreen,
      secondary: accentOrange,
    ).copyWith(surface: surface);

    final base = ThemeData(useMaterial3: true, colorScheme: colorScheme);

    return base.copyWith(
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme),
      scaffoldBackgroundColor: surface,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentOrange,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF4F6F6),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: textMuted),
      ),
    );
  }

  static LinearGradient get heroGradient => const LinearGradient(
    colors: [accentGreen, primaryGreen],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static List<BoxShadow> softShadow([double opacity = 0.14]) => [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, opacity),
      blurRadius: 24,
      offset: const Offset(0, 16),
    ),
  ];
}
