import 'package:flutter/material.dart';

/// Colors lifted directly from the website's tailwind.config.js so the app
/// feels like the same brand, not a reskin.
class AppColors {
  AppColors._();

  static const ink950 = Color(0xFF0B0A08);
  static const ink900 = Color(0xFF14120E);
  static const ink800 = Color(0xFF1E1B16);
  static const ink700 = Color(0xFF2A251D);

  static const ember50 = Color(0xFFFFF6ED);
  static const ember100 = Color(0xFFFFEAD4);
  static const ember200 = Color(0xFFFFD1A8);
  static const ember300 = Color(0xFFFFB070);
  static const ember400 = Color(0xFFFF8A3D);
  static const ember500 = Color(0xFFFB6A17);
  static const ember600 = Color(0xFFEC4F0D);
  static const ember700 = Color(0xFFC3390D);
  static const ember800 = Color(0xFF9B2D13);
  static const ember900 = Color(0xFF7D2712);

  static const saffron = Color(0xFFFFC93C);
  static const cream = Color(0xFFFFFAF2);

  // Status colors (mirrors STATUS_STYLES on the website)
  static const statusPreparing = saffron;
  static const statusReady = ember500;
  static const statusOutForDelivery = Color(0xFF0EA5E9);
  static const statusDelivered = Color(0xFF10B981);
  static const statusCancel = Color(0xFFEF4444);
}

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.ember500,
        primary: AppColors.ember500,
        onPrimary: Colors.white,
        surface: AppColors.cream,
      ),
      scaffoldBackgroundColor: AppColors.cream,
      fontFamily: 'Roboto',
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.cream,
        foregroundColor: AppColors.ink950,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.ink950,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.ember500,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.ink950,
          side: const BorderSide(color: Color(0x1A0B0A08), width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0x1A0B0A08)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0x1A0B0A08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.ember500, width: 1.5),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        margin: EdgeInsets.zero,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.ember600,
        unselectedItemColor: Color(0x990B0A08),
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
    );
  }
}
