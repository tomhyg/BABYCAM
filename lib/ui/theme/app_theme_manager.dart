// lib/ui/theme/app_theme_manager.dart

import 'package:flutter/material.dart';
import 'app_colors.dart';  // ✅ Import corrigé

class AppThemeManager {
  static ThemeData getLightTheme(String colorScheme) {
    final colors = AppColors.getColorScheme(colorScheme);  // ✅ Corrigé
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: colors['primary']!,
        secondary: colors['secondary']!,
        surface: colors['surface']!,
        background: colors['background']!,
        error: colors['error']!,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: Colors.black,
        onBackground: Colors.black,
        onError: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors['primary'],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors['primary'],
          foregroundColor: Colors.white,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors['secondary'],
      ),
    );
  }

  static ThemeData getDarkTheme(String colorScheme) {
    final colors = AppColors.getColorScheme('dark');  // ✅ Corrigé
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: colors['primary']!,
        secondary: colors['secondary']!,
        surface: colors['surface']!,
        background: colors['background']!,
        error: colors['error']!,
        onPrimary: Colors.black,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onBackground: Colors.white,
        onError: Colors.black,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors['surface'],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors['primary'],
          foregroundColor: Colors.black,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors['secondary'],
      ),
    );
  }

  static List<String> getAvailableColorSchemes() {
    return ['default', 'baby', 'dark', 'warm', 'cool'];
  }

  static String getDefaultColorScheme() {
    return 'baby';
  }
}