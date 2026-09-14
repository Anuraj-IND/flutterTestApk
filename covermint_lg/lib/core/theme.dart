import 'package:flutter/material.dart';

class CovermintTheme {
  static const Color brandPrimary = Color(0xFF0B6B4F);
  static const Color brandAccent = Color(0xFFF2A413);
  static const Color brandDark = Color(0xFF064E3B);
  static const Color brandLight = Color(0xFFE8F5E9);
  static const Color pendingAmber = Color(0xFFF59E0B);
  static const Color approvedGreen = Color(0xFF10B981);
  static const Color rejectedRed = Color(0xFFEF4444);
  static const Color surfaceLight = Color(0xFFF8FAFC);
  static const Color cardShadow = Color(0x1A0B6B4F);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [brandPrimary, brandDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [brandAccent, Color(0xFFF59E0B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF0B6B4F), Color(0xFF047857), Color(0xFF065F46)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: brandPrimary,
      brightness: Brightness.light,
      primary: brandPrimary,
      secondary: brandAccent,
      surface: surfaceLight,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: surfaceLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: brandPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: rejectedRed),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: rejectedRed, width: 2),
        ),
        labelStyle: TextStyle(color: Colors.grey.shade600),
        hintStyle: TextStyle(color: Colors.grey.shade400),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: Colors.white,
        shadowColor: cardShadow,
        margin: const EdgeInsets.only(bottom: 12),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: brandPrimary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(color: brandPrimary),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: brandPrimary.withValues(alpha: 0.12),
        elevation: 8,
        shadowColor: Colors.black26,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: brandPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            );
          }
          return TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          );
        }),
      ),
    );
  }
}
