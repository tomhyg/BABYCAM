// ============================================================================
// NOUVEAU SYSTÈME DE THÈMES - 4 palettes colorées + mode jour/nuit
// ============================================================================

// lib/ui/theme/app_color_schemes.dart
import 'package:flutter/material.dart';

enum ColorSchemeType {
  cosmic,    // Violet/Rose (actuel)
  ocean,     // Bleu/Turquoise
  forest,    // Vert/Orange
  sunset,    // Orange/Rouge
}

class AppColorSchemes {
  // ============================================================================
  // COSMIC (Violet/Rose) - Thème actuel amélioré
  // ============================================================================
  static const Map<String, Color> cosmic = {
    'primary': Color(0xFF8E77FF),
    'secondary': Color(0xFF7ED3BF),
    'accent': Color(0xFFFF6B9D),
    'background': Color(0xFF1a1a2e),
    'surface': Color(0xFF2d2d47),
    'error': Color(0xFFFF6B6B),
    'success': Color(0xFF51CF66),
    'warning': Color(0xFFFFD93D),
  };

  // ============================================================================
  // OCEAN (Bleu/Turquoise) - Apaisant et professionnel
  // ============================================================================
  static const Map<String, Color> ocean = {
    'primary': Color(0xFF4FC3F7),
    'secondary': Color(0xFF26C6DA),
    'accent': Color(0xFF7C4DFF),
    'background': Color(0xFF0D1B2A),
    'surface': Color(0xFF1B263B),
    'error': Color(0xFFE57373),
    'success': Color(0xFF66BB6A),
    'warning': Color(0xFFFFB74D),
  };

  // ============================================================================
  // FOREST (Vert/Orange) - Naturel et chaleureux
  // ============================================================================
  static const Map<String, Color> forest = {
    'primary': Color(0xFF66BB6A),
    'secondary': Color(0xFFFF8A65),
    'accent': Color(0xFFAB47BC),
    'background': Color(0xFF1B2A1F),
    'surface': Color(0xFF2D3E32),
    'error': Color(0xFFEF5350),
    'success': Color(0xFF4CAF50),
    'warning': Color(0xFFFF9800),
  };

  // ============================================================================
  // SUNSET (Orange/Rouge) - Dynamique et énergique
  // ============================================================================
  static const Map<String, Color> sunset = {
    'primary': Color(0xFFFF7043),
    'secondary': Color(0xFFFFC107),
    'accent': Color(0xFFE91E63),
    'background': Color(0xFF2A1810),
    'surface': Color(0xFF3D2A1F),
    'error': Color(0xFFF44336),
    'success': Color(0xFF8BC34A),
    'warning': Color(0xFFFF9800),
  };

  // ============================================================================
  // COULEURS COMMUNES (indépendantes du thème)
  // ============================================================================
  static const Color temperatureColor = Color(0xFFFF9800);
  static const Color humidityColor = Color(0xFF2196F3);
  static const Color airQualityColor = Color(0xFF4CAF50);
  static const Color lightLevelColor = Color(0xFFFFC107);
  
  // États monitoring
  static const Color monitoringListening = Color(0xFF2196F3);
  static const Color monitoringTalking = Color(0xFF4CAF50);
  static const Color monitoringIntercom = Color(0xFF9C27B0);
  
  // Couleurs veilleuse RGB (indépendantes du thème)
  static const Map<String, List<Color>> nightlightColors = {
    'warm': [Color(0xFFFF8A50), Color(0xFFFFC947)],
    'cool': [Color(0xFF4FC3F7), Color(0xFF29B6F6)],
    'purple': [Color(0xFFBA68C8), Color(0xFF9C27B0)],
    'green': [Color(0xFF66BB6A), Color(0xFF4CAF50)],
    'pink': [Color(0xFFFF8A92), Color(0xFFE91E63)],
    'blue': [Color(0xFF64B5F6), Color(0xFF1976D2)],
    'orange': [Color(0xFFFFB74D), Color(0xFFFF9800)],
    'white': [Color(0xFFFFFFFF), Color(0xFFE0E0E0)],
  };

  // ============================================================================
  // MÉTHODES UTILITAIRES
  // ============================================================================
  static Map<String, Color> getColorScheme(ColorSchemeType type) {
    switch (type) {
      case ColorSchemeType.cosmic:
        return cosmic;
      case ColorSchemeType.ocean:
        return ocean;
      case ColorSchemeType.forest:
        return forest;
      case ColorSchemeType.sunset:
        return sunset;
    }
  }

  static String getThemeName(ColorSchemeType type) {
    switch (type) {
      case ColorSchemeType.cosmic:
        return 'Cosmic';
      case ColorSchemeType.ocean:
        return 'Ocean';
      case ColorSchemeType.forest:
        return 'Forest';
      case ColorSchemeType.sunset:
        return 'Sunset';
    }
  }

  static String getThemeDescription(ColorSchemeType type) {
    switch (type) {
      case ColorSchemeType.cosmic:
        return 'Violet et rose mystique';
      case ColorSchemeType.ocean:
        return 'Bleu apaisant et profond';
      case ColorSchemeType.forest:
        return 'Vert naturel et chaleureux';
      case ColorSchemeType.sunset:
        return 'Orange dynamique et énergique';
    }
  }

  static IconData getThemeIcon(ColorSchemeType type) {
    switch (type) {
      case ColorSchemeType.cosmic:
        return Icons.auto_awesome;
      case ColorSchemeType.ocean:
        return Icons.waves;
      case ColorSchemeType.forest:
        return Icons.park;
      case ColorSchemeType.sunset:
        return Icons.wb_sunny;
    }
  }
}
