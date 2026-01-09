// lib/ui/theme/app_theme_manager.dart

import 'package:flutter/material.dart';
import 'app_colors.dart';

enum ColorSchemeType {
  dark,      // Sombre - noir professionnel
  original,  // Original - couleurs de l'app d'origine
  cosmic,    // Cosmic - espace et galaxie
}

class AppThemeManager {
  static ThemeData createTheme({
    required ColorSchemeType colorScheme,
    bool isDarkMode = false,
  }) {
    switch (colorScheme) {
      case ColorSchemeType.dark:
        return _createDarkTheme();
      case ColorSchemeType.original:
        return _createOriginalTheme();
      case ColorSchemeType.cosmic:
        return _createCosmicTheme();
    }
  }

  // THÈME SOMBRE PROFESSIONNEL avec couleurs d'infographie
  static ThemeData _createDarkTheme() {
    const backgroundColor = Color(0xFF1A1A1A);
    const surfaceColor = Color(0xFF2A2A2A);
    const primaryColor = Color(0xFFB1B0DC); // Lavande pour les boutons
    const accentColor = Color(0xFF7ED3BF); // Vert menthe pour les accents
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: accentColor,
        background: backgroundColor,
        surface: surfaceColor,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onBackground: Colors.white,
        onSurface: Colors.white,
        onSurfaceVariant: Color(0xFFB0B0B0),
        outline: Color(0xFF404040),
        outlineVariant: Color(0xFF333333),
        tertiary: Color(0xFFFFB26B), // Orange pour la température
        error: Color(0xFFFF8E99),   // Rouge doux pour les erreurs
      ),
      
      scaffoldBackgroundColor: backgroundColor,
      
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      
      cardTheme: CardTheme(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF333333), width: 1),
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),

      // Extensions personnalisées pour les couleurs d'infographie
      extensions: [
        _DarkThemeColors(),
      ],
    );
  }

  // THÈME ORIGINAL (ancien Bébé) - couleurs de l'app d'origine
  static ThemeData _createOriginalTheme() {
    const primaryColor = Color(0xFFB1B0DC);    // Lavande principal
    const secondaryColor = Color(0xFF7ED3BF);  // Vert menthe
    const backgroundColor = Color(0xFFF0EFFE); // Fond lavande très clair
    const surfaceColor = Colors.white;
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        background: backgroundColor,
        surface: surfaceColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: Color(0xFF2D2D2D),
        onSurface: Color(0xFF2D2D2D),
        tertiary: Color(0xFF2B5F8E), // Bleu profond
        error: Color(0xFFFF8E99),   // Rouge doux
      ),
      
      scaffoldBackgroundColor: backgroundColor,
      
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      
      cardTheme: CardTheme(
        color: surfaceColor,
        elevation: 0,
        shadowColor: primaryColor.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: primaryColor.withOpacity(0.1), width: 1),
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),

      extensions: [
        _OriginalThemeColors(),
      ],
    );
  }

  // THÈME COSMIC (Espace et galaxie)
  static ThemeData _createCosmicTheme() {
    const primaryColor = Color(0xFF8E77FF);    // Violet cosmique
    const secondaryColor = Color(0xFFFF7777);  // Rose cosmique
    const backgroundColor = Color(0xFF1a1a2e); // Bleu espace profond
    const surfaceColor = Color(0xFF2d2d47);    // Bleu espace surface
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        background: backgroundColor,
        surface: surfaceColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: Colors.white,
        onSurface: Colors.white,
        tertiary: Color(0xFF00D4FF), // Cyan cosmique
        error: Color(0xFFFF6B6B),   // Rouge cosmique
      ),
      
      scaffoldBackgroundColor: backgroundColor,
      
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      
      cardTheme: CardTheme(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: primaryColor.withOpacity(0.3), width: 1),
        ),
      ),

      extensions: [
        _CosmicThemeColors(),
      ],
    );
  }

  // Conversion des strings vers les enums
  static ColorSchemeType getColorSchemeFromString(String scheme) {
    switch (scheme) {
      case 'dark':
        return ColorSchemeType.dark;
      case 'original':
      case 'baby': // pour compatibilité
        return ColorSchemeType.original;
      case 'cosmic':
        return ColorSchemeType.cosmic;
      default:
        return ColorSchemeType.original; // Par défaut Original au lieu de dark
    }
  }

  static String getStringFromColorScheme(ColorSchemeType scheme) {
    switch (scheme) {
      case ColorSchemeType.dark:
        return 'dark';
      case ColorSchemeType.original:
        return 'original';
      case ColorSchemeType.cosmic:
        return 'cosmic';
    }
  }

  // Infos sur les thèmes
  static String getThemeName(ColorSchemeType scheme) {
    switch (scheme) {
      case ColorSchemeType.dark:
        return 'Sombre';
      case ColorSchemeType.original:
        return 'Original';
      case ColorSchemeType.cosmic:
        return 'Cosmic';
    }
  }

  static String getThemeDescription(ColorSchemeType scheme) {
    switch (scheme) {
      case ColorSchemeType.dark:
        return 'Interface sombre avec graphiques colorés';
      case ColorSchemeType.original:
        return 'Thème original de l\'application';
      case ColorSchemeType.cosmic:
        return 'Espace et galaxie';
    }
  }

  static IconData getThemeIcon(ColorSchemeType scheme) {
    switch (scheme) {
      case ColorSchemeType.dark:
        return Icons.dark_mode;
      case ColorSchemeType.original:
        return Icons.baby_changing_station;
      case ColorSchemeType.cosmic:
        return Icons.auto_awesome;
    }
  }

  static List<Color> getThemeColors(ColorSchemeType scheme) {
    switch (scheme) {
      case ColorSchemeType.dark:
        return [const Color(0xFFB1B0DC), const Color(0xFF2A2A2A)];
      case ColorSchemeType.original:
        return [const Color(0xFFB1B0DC), const Color(0xFF7ED3BF)];
      case ColorSchemeType.cosmic:
        return [const Color(0xFF8E77FF), const Color(0xFFFF7777)];
    }
  }

  // Méthodes pour récupérer les couleurs spécifiques aux capteurs selon le thème
  static Color getTemperatureColor(ColorSchemeType scheme) {
    switch (scheme) {
      case ColorSchemeType.dark:
        return const Color(0xFFFFB26B); // Orange doux pour le thème sombre
      case ColorSchemeType.original:
        return AppColors.temperatureColor;
      case ColorSchemeType.cosmic:
        return const Color(0xFFFF6B6B); // Rouge cosmique
    }
  }

  static Color getHumidityColor(ColorSchemeType scheme) {
    switch (scheme) {
      case ColorSchemeType.dark:
        return const Color(0xFF81C8FF); // Bleu ciel pour le thème sombre
      case ColorSchemeType.original:
        return AppColors.humidityColor;
      case ColorSchemeType.cosmic:
        return const Color(0xFF00D4FF); // Cyan cosmique
    }
  }

  static Color getAirQualityColor(ColorSchemeType scheme) {
    switch (scheme) {
      case ColorSchemeType.dark:
        return const Color(0xFF7ED3BF); // Vert menthe pour le thème sombre
      case ColorSchemeType.original:
        return AppColors.airQualityColor;
      case ColorSchemeType.cosmic:
        return const Color(0xFF77FF77); // Vert cosmique
    }
  }

  static Color getLightLevelColor(ColorSchemeType scheme) {
    switch (scheme) {
      case ColorSchemeType.dark:
        return const Color(0xFFFFF3D1); // Jaune pâle pour le thème sombre
      case ColorSchemeType.original:
        return AppColors.lightLevelColor;
      case ColorSchemeType.cosmic:
        return const Color(0xFFFFD700); // Or cosmique
    }
  }
}

// Extensions pour les couleurs personnalisées par thème
class _DarkThemeColors extends ThemeExtension<_DarkThemeColors> {
  const _DarkThemeColors();

  @override
  _DarkThemeColors copyWith() => const _DarkThemeColors();

  @override
  _DarkThemeColors lerp(ThemeExtension<_DarkThemeColors>? other, double t) {
    return const _DarkThemeColors();
  }
}

class _OriginalThemeColors extends ThemeExtension<_OriginalThemeColors> {
  const _OriginalThemeColors();

  @override
  _OriginalThemeColors copyWith() => const _OriginalThemeColors();

  @override
  _OriginalThemeColors lerp(ThemeExtension<_OriginalThemeColors>? other, double t) {
    return const _OriginalThemeColors();
  }
}

class _CosmicThemeColors extends ThemeExtension<_CosmicThemeColors> {
  const _CosmicThemeColors();

  @override
  _CosmicThemeColors copyWith() => const _CosmicThemeColors();

  @override
  _CosmicThemeColors lerp(ThemeExtension<_CosmicThemeColors>? other, double t) {
    return const _CosmicThemeColors();
  }
}