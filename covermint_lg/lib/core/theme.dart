import 'package:flutter/material.dart';

class StitchColors {
  static const Color surface = Color(0xFFF8F9FF);
  static const Color surfaceLow = Color(0xFFEFF4FF);
  static const Color surfaceContainerLow = Color(0xFFEFF4FF);
  static const Color surfaceContainer = Color(0xFFE5EEFF);
  static const Color surfaceContainerHigh = Color(0xFFDCE9FF);
  static const Color surfaceContainerHighest = Color(0xFFD3E4FE);
  static const Color surfaceLowest = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF0B1C30);
  static const Color onSurfaceVariant = Color(0xFF43474D);
  static const Color outline = Color(0xFF74777E);
  static const Color outlineVariant = Color(0xFFC4C6CE);
  static const Color primary = Color(0xFF0A2540);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF0A2540);
  static const Color secondary = Color(0xFF006591);
  static const Color secondaryContainer = Color(0xFF39B8FD);
  static const Color secondaryFixed = Color(0xFFC9E6FF);
  static const Color secondaryFixedDim = Color(0xFF89CEFF);
  static const Color onSecondaryFixedVariant = Color(0xFF004C6E);
  static const Color tertiaryFixed = Color(0xFF7AF7E8);
  static const Color tertiaryFixedDim = Color(0xFF5BDACC);
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color success = Color(0xFF10B981);
  static const Color successBg = Color(0xFFECFDF5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color canvas = Color(0xFFF8FAFC);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate200 = Color(0xFFE2E8F0);
  static const Color slate800 = Color(0xFF1E293B);
  static const Color primaryFixed = Color(0xFFD2E4FF);
}

class CovermintTheme {
  static const Color brandPrimary = StitchColors.primary;
  static const Color brandAccent = StitchColors.secondary;
  static const Color brandDark = Color(0xFF07192C);
  static const Color brandLight = StitchColors.surfaceLow;
  static const Color pendingAmber = StitchColors.warning;
  static const Color approvedGreen = StitchColors.success;
  static const Color rejectedRed = StitchColors.error;

  static ThemeData get light {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: StitchColors.primary,
      onPrimary: StitchColors.onPrimary,
      primaryContainer: StitchColors.primaryContainer,
      onPrimaryContainer: Color(0xFF768DAD),
      secondary: StitchColors.secondary,
      onSecondary: Colors.white,
      secondaryContainer: StitchColors.secondaryContainer,
      onSecondaryContainer: Color(0xFF004666),
      error: StitchColors.error,
      onError: Colors.white,
      errorContainer: StitchColors.errorContainer,
      onErrorContainer: Color(0xFF93000A),
      surface: StitchColors.surface,
      onSurface: StitchColors.onSurface,
      surfaceContainerLowest: StitchColors.surfaceLowest,
      surfaceContainerLow: StitchColors.surfaceLow,
      surfaceContainer: StitchColors.surfaceContainer,
      surfaceContainerHigh: StitchColors.surfaceContainerHigh,
      surfaceContainerHighest: StitchColors.surfaceContainerHighest,
      onSurfaceVariant: StitchColors.onSurfaceVariant,
      outline: StitchColors.outline,
      outlineVariant: StitchColors.outlineVariant,
      scrim: Colors.black54,
      inverseSurface: Color(0xFF213145),
      onInverseSurface: Color(0xFFEAF1FF),
      inversePrimary: Color(0xFFB0C8EB),
      surfaceTint: Color(0xFF49607E),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: StitchColors.surface,
      fontFamily: 'Inter',
      appBarTheme: const AppBarTheme(
        backgroundColor: StitchColors.surface,
        foregroundColor: StitchColors.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          color: StitchColors.onSurface,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: StitchColors.surfaceLowest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: StitchColors.slate200, width: 1),
        ),
        shadowColor: const Color(0x0F0F172A),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: StitchColors.surfaceLow,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: StitchColors.slate200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: StitchColors.slate200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: StitchColors.secondary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: StitchColors.error, width: 1.5),
        ),
        labelStyle: const TextStyle(color: StitchColors.onSurfaceVariant, fontSize: 12, fontWeight: FontWeight.w500),
        hintStyle: const TextStyle(color: StitchColors.outline, fontSize: 14),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: StitchColors.primary,
          foregroundColor: StitchColors.onPrimary,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'Inter'),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: StitchColors.primary,
          side: const BorderSide(color: StitchColors.slate200),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: StitchColors.surfaceContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: StitchColors.surfaceLowest.withValues(alpha: 0.95),
        elevation: 0,
        indicatorColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(color: StitchColors.primary, fontSize: 11, fontWeight: FontWeight.w600, fontFamily: 'Inter');
          }
          return const TextStyle(color: StitchColors.onSurfaceVariant, fontSize: 11, fontWeight: FontWeight.w500, fontFamily: 'Inter');
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: StitchColors.primary, size: 22);
          }
          return const IconThemeData(color: StitchColors.onSurfaceVariant, size: 22);
        }),
      ),
    );
  }
}
