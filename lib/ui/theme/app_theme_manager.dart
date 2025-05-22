// ============================================================================
// GESTIONNAIRE DE THÈMES DYNAMIQUE
// ============================================================================

// lib/ui/theme/app_theme_manager.dart
import 'package:flutter/material.dart';
import 'app_color_schemes.dart';
import 'app_text_styles.dart';

class AppThemeManager {
  static ThemeData createTheme({
    required ColorSchemeType colorScheme,
    required bool isDarkMode,
  }) {
    final colors = AppColorSchemes.getColorScheme(colorScheme);
    
    return ThemeData(
      useMaterial3: true,
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      
      colorScheme: _createColorScheme(colors, isDarkMode),
      
      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
        titleTextStyle: AppTextStyles.headline3.copyWith(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),

      // Cartes
      cardTheme: CardTheme(
        color: isDarkMode ? colors['surface'] : Colors.white,
        elevation: isDarkMode ? 0 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isDarkMode 
                ? Colors.white.withOpacity(0.1)
                : Colors.black.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),

      // Boutons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors['primary'],
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Navigation
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDarkMode ? colors['surface'] : Colors.white,
        selectedItemColor: colors['primary'],
        unselectedItemColor: isDarkMode 
            ? Colors.white.withOpacity(0.6)
            : Colors.black.withOpacity(0.6),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Sliders
      sliderTheme: SliderThemeData(
        activeTrackColor: colors['primary'],
        inactiveTrackColor: isDarkMode 
            ? Colors.white.withOpacity(0.2)
            : Colors.black.withOpacity(0.2),
        thumbColor: colors['primary'],
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDarkMode ? colors['surface'] : Colors.grey[800],
        contentTextStyle: const TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Scaffold
      scaffoldBackgroundColor: isDarkMode 
          ? colors['background']
          : const Color(0xFFF5F5F5),
    );
  }

  static ColorScheme _createColorScheme(Map<String, Color> colors, bool isDarkMode) {
    if (isDarkMode) {
      return ColorScheme.dark(
        primary: colors['primary']!,
        secondary: colors['secondary']!,
        surface: colors['surface']!,
        background: colors['background']!,
        error: colors['error']!,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onBackground: Colors.white,
        onError: Colors.white,
      );
    } else {
      return ColorScheme.light(
        primary: colors['primary']!,
        secondary: colors['secondary']!,
        surface: Colors.white,
        background: const Color(0xFFF5F5F5),
        error: colors['error']!,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.black,
        onBackground: Colors.black,
        onError: Colors.white,
      );
    }
  }
}
