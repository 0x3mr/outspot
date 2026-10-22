import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const electricPurple = Color(0xFFA855F7);
  static const electricCyan = Color(0xFF06B6D4);
  static const deepViolet = Color(0xFF7C3AED);
  static const skyBlue = Color(0xFF38BDF8);
  static const lavenderMist = Color(0xFFF5F0FF);
  static const surfaceWhite = Color(0xFFFFFFFF);
  static const softLavender = Color(0xFFEDE4FF);
  static const paleCyan = Color(0xFFE0F7FF);
  static const midnightInk = Color(0xFF172033);
  static const slateGray = Color(0xFF64748B);
  static const softBorder = Color(0xFFE7E5EF);

  static const primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [electricPurple, deepViolet, electricCyan],
  );

  static const subtleCardShadow = BoxShadow(
    color: Color(0x0C7C3AED),
    blurRadius: 16,
    offset: Offset(0, 4),
  );

  static const glowShadow = BoxShadow(
    color: Color(0x40A855F7),
    blurRadius: 18,
    spreadRadius: 1,
    offset: Offset(0, 4),
  );
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final scheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.electricPurple,
      onPrimary: Colors.white,
      primaryContainer: AppColors.softLavender,
      onPrimaryContainer: AppColors.deepViolet,
      secondary: AppColors.electricCyan,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.paleCyan,
      onSecondaryContainer: const Color(0xFF0E7490),
      tertiary: AppColors.skyBlue,
      onTertiary: Colors.white,
      error: const Color(0xFFDC2626),
      onError: Colors.white,
      surface: AppColors.lavenderMist,
      onSurface: AppColors.midnightInk,
      onSurfaceVariant: AppColors.slateGray,
      outline: AppColors.softBorder,
      outlineVariant: AppColors.softBorder,
      surfaceContainerLowest: AppColors.surfaceWhite,
      surfaceContainerLow: AppColors.surfaceWhite,
      surfaceContainer: AppColors.surfaceWhite,
      surfaceContainerHigh: AppColors.softLavender,
      surfaceContainerHighest: AppColors.paleCyan,
    );

    final base = ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.lavenderMist,
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.lavenderMist,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lavenderMist,
        foregroundColor: AppColors.midnightInk,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: base.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
          color: AppColors.midnightInk,
        ),
      ),
      textTheme: base.textTheme.copyWith(
        headlineMedium: base.textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
          color: AppColors.midnightInk,
        ),
        headlineSmall: base.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: -0.4,
          color: AppColors.midnightInk,
        ),
        titleLarge: base.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
          color: AppColors.midnightInk,
        ),
        titleMedium: base.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.midnightInk,
        ),
        bodyLarge: base.textTheme.bodyLarge?.copyWith(
          color: AppColors.slateGray,
          fontSize: 16,
          height: 1.45,
        ),
        bodyMedium: base.textTheme.bodyMedium?.copyWith(
          color: AppColors.midnightInk,
          fontSize: 14,
          height: 1.4,
        ),
        labelLarge: base.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: 0.1,
        ),
        labelMedium: base.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.slateGray,
        ),
        labelSmall: base.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.slateGray,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceWhite,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.softBorder),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceWhite,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.softBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.softBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.electricPurple,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFDC2626)),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: const StadiumBorder(),
        side: const BorderSide(color: AppColors.softBorder),
        backgroundColor: AppColors.surfaceWhite,
        selectedColor: AppColors.softLavender,
        labelStyle: const TextStyle(
          color: AppColors.midnightInk,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.electricPurple,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.deepViolet,
          backgroundColor: AppColors.surfaceWhite,
          side: const BorderSide(color: AppColors.softBorder),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.electricPurple,
        foregroundColor: Colors.white,
        shape: CircleBorder(),
      ),
    );
  }
}
