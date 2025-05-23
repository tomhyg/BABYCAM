// lib/ui/theme/app_colors.dart
// Fichier unifié avec toutes les couleurs de l'application

import 'package:flutter/material.dart';

class AppColors {
  // === COULEURS PRINCIPALES DU LOGO ===
  static const Color primary = Color(0xFFB1B0DC);    // Lavande/violet clair
  static const Color primaryVariant = Color(0xFF9B99CE); // Lavande plus foncé
  static const Color secondary = Color(0xFF7ED3BF);  // Vert menthe
  static const Color secondaryVariant = Color(0xFF5DB9A4); // Vert menthe plus foncé
  static const Color accent = Color(0xFF2B5F8E);     // Bleu profond (iris)
  static const Color accentDarker = Color(0xFF1D4369);
  static const Color highlight = Color(0xFFFFF3D1);  // Halo doré/jaune pâle

  // === COULEURS POUR LES THÈMES ===
  // Thème clair
  static const Color lightBackground = Color(0xFFF0EFFE);  // Fond lavande très clair
  static const Color lightSurface = Colors.white;
  static const Color lightError = Color(0xFFFF8E99);      // Rouge doux
  static const Color lightOnPrimary = Colors.white;
  static const Color lightOnSecondary = Colors.black;
  static const Color lightOnBackground = Colors.black;
  static const Color lightOnSurface = Colors.black;
  static const Color lightOnError = Colors.white;
  
  // Thème sombre
  static const Color darkBackground = Color(0xFF2F2E45);   // Fond principal sombre
  static const Color darkSurface = Color(0xFF3D3C57);     // Surface sombre
  static const Color darkError = Color(0xFFFF8E99);       // Rouge doux
  static const Color darkOnPrimary = Colors.black;
  static const Color darkOnSecondary = Colors.black;
  static const Color darkOnBackground = Colors.white;
  static const Color darkOnSurface = Colors.white;
  static const Color darkOnError = Colors.black;

  // Variantes de surfaces
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF3D3C57);
  static const Color surfaceVariantLight = Color(0xFFE8E6FF);
  static const Color surfaceVariantDark = Color(0xFF4A4967);

  // === COULEURS SPÉCIFIQUES À L'APPLICATION ===
  static const Color babyBlue = Color(0xFF91D2FA);
  static const Color babyPink = Color(0xFFF4B8D1);
  static const Color babyGreen = Color(0xFFA1E5C4);
  static const Color babyYellow = Color(0xFFF9E181);

  // === COULEURS DES CAPTEURS ===
  static const Color temperatureColor = Color(0xFFFFB26B); // Orange doux
  static const Color humidityColor = Color(0xFF81C8FF);    // Bleu ciel
  static const Color airQualityColor = Color(0xFF7ED3BF);  // Vert menthe
  static const Color pressureColor = Color(0xFFB1B0DC);    // Lavande
  static const Color lightLevelColor = Color(0xFFFFF3D1);  // Jaune pâle
  static const Color sleepColor = Color(0xFF9B99CE);       // Lavande plus foncé

  // === ÉTATS ET ALERTES ===
  static const Color success = Color(0xFF7ED3BF);  // Vert menthe
  static const Color warning = Color(0xFFFFB26B);  // Orange doux
  static const Color error = Color(0xFFFF8E99);    // Rouge doux
  static const Color info = Color(0xFF81C8FF);     // Bleu ciel

  // === COULEURS DE MONITORING ===
  static const Color monitoringListening = Color(0xFF4CAF50);  // Vert - écoute active
  static const Color monitoringTalking = Color(0xFF2196F3);    // Bleu - parole
  static const Color monitoringIntercom = Color(0xFFFF9800);   // Orange - intercom

  // === COULEURS DE NIVEAU D'ÉTAT ===
  static const List<Color> statusColors = [
    Color(0xFF7ED3BF), // Excellent - vert menthe
    Color(0xFF81C8FF), // Très bon - bleu ciel
    Color(0xFFFFF3D1), // Bon - jaune pâle
    Color(0xFFFFB26B), // Moyen - orange doux
    Color(0xFFFF8E99), // Mauvais - rouge doux
  ];

  // === DÉGRADÉS ===
  static const List<Color> primaryGradient = [
    Color(0xFFB1B0DC),
    Color(0xFF9B99CE),
  ];
  
  static const List<Color> secondaryGradient = [
    Color(0xFF7ED3BF),
    Color(0xFF5DB9A4),
  ];
  
  static const List<Color> accentGradient = [
    Color(0xFF2B5F8E),
    Color(0xFF1D4369),
  ];
  
  // Dégradé spécial du logo
  static const List<Color> logoGradient = [
    Color(0xFFF0EFFE),  // Lavande très clair
    Color(0xFFFFF3D1),  // Halo doré/jaune pâle
    Color(0xFFF0EFFE),  // Lavande très clair
  ];

  // === COULEURS DE VEILLEUSE ===
  static const Map<String, List<Color>> nightlightColors = {
    'warm': [
      Color(0xFFFFE5B4), // Blanc chaud clair
      Color(0xFFFFD700), // Or doux
    ],
    'cool': [
      Color(0xFFB4E5FF), // Bleu très clair
      Color(0xFF87CEEB), // Bleu ciel
    ],
    'purple': [
      Color(0xFFE6E6FA), // Lavande
      Color(0xFFDDA0DD), // Prune clair
    ],
    'green': [
      Color(0xFFE0FFE0), // Vert très clair
      Color(0xFF98FB98), // Vert pâle
    ],
    'pink': [
      Color(0xFFFFE4E6), // Rose très clair
      Color(0xFFFFB6C1), // Rose pâle
    ],
    'blue': [
      Color(0xFFE0F6FF), // Bleu glacier
      Color(0xFFADD8E6), // Bleu clair
    ],
    'orange': [
      Color(0xFFFFE4B5), // Pêche clair
      Color(0xFFFFA07A), // Saumon clair
    ],
    'white': [
      Color(0xFFFFFFF0), // Blanc ivoire
      Color(0xFFF5F5F5), // Blanc cassé
    ],
  };

  // === MÉTHODES UTILITAIRES ===
  
  /// Obtient une couleur selon la qualité (0.0 à 1.0)
  static Color getQualityColor(double value, {bool reversed = false}) {
    double normalizedValue = value.clamp(0.0, 1.0);
    
    if (reversed) {
      normalizedValue = 1 - normalizedValue;
    }
    
    if (normalizedValue >= 0.8) {
      return statusColors[0]; // Excellent
    } else if (normalizedValue >= 0.6) {
      return statusColors[1]; // Très bon
    } else if (normalizedValue >= 0.4) {
      return statusColors[2]; // Bon
    } else if (normalizedValue >= 0.2) {
      return statusColors[3]; // Moyen
    } else {
      return statusColors[4]; // Mauvais
    }
  }
  
  /// Applique une opacité à une couleur
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  /// Obtient le gradient pour une couleur de veilleuse
  static LinearGradient getNightlightGradient(String colorKey) {
    final colors = nightlightColors[colorKey] ?? [Colors.white, Colors.grey];
    return LinearGradient(
      colors: colors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  /// Vérifie si une couleur de veilleuse est disponible
  static bool isNightlightColorAvailable(String colorKey) {
    return nightlightColors.containsKey(colorKey);
  }

  /// Obtient toutes les clés de couleurs de veilleuse disponibles
  static List<String> get availableNightlightColorKeys => nightlightColors.keys.toList();

  /// Obtient les couleurs d'une veilleuse ou les couleurs par défaut
  static List<Color> getNightlightColorsOrDefault(String colorKey) {
    return nightlightColors[colorKey] ?? nightlightColors['warm']!;
  }

  // === MÉTHODES POUR LA COMPATIBILITÉ AVEC L'ANCIEN SYSTÈME ===
  
  /// Obtient un schéma de couleurs par nom
  static Map<String, Color> getColorScheme(String schemeName) {
    switch (schemeName) {
      case 'default':
      case 'baby':
        return {
          'primary': primary,
          'secondary': secondary,
          'accent': accent,
          'background': lightBackground,
          'surface': lightSurface,
          'error': error,
          'success': success,
          'warning': warning,
          'info': info,
        };
      case 'dark':
        return {
          'primary': primary,
          'secondary': secondary,
          'accent': accent,
          'background': darkBackground,
          'surface': darkSurface,
          'error': error,
          'success': success,
          'warning': warning,
          'info': info,
        };
      case 'warm':
        return {
          'primary': Color(0xFFFF8A65),
          'secondary': Color(0xFFFFCC02),
          'accent': Color(0xFFFF6F00),
          'background': Color(0xFFFFF8E1),
          'surface': Colors.white,
          'error': error,
          'success': success,
          'warning': warning,
          'info': info,
        };
      case 'cool':
        return {
          'primary': Color(0xFF64B5F6),
          'secondary': Color(0xFF81C784),
          'accent': Color(0xFF42A5F5),
          'background': Color(0xFFE3F2FD),
          'surface': Colors.white,
          'error': error,
          'success': success,
          'warning': warning,
          'info': info,
        };
      default:
        return getColorScheme('default');
    }
  }

  /// Obtient l'icône d'un thème
  static IconData getThemeIcon(String themeName) {
    switch (themeName) {
      case 'default':
      case 'baby':
        return Icons.baby_changing_station;
      case 'dark':
        return Icons.dark_mode;
      case 'warm':
        return Icons.wb_sunny;
      case 'cool':
        return Icons.ac_unit;
      default:
        return Icons.palette;
    }
  }

  /// Obtient le nom d'affichage d'un thème
  static String getThemeName(String themeName) {
    switch (themeName) {
      case 'default':
      case 'baby':
        return 'Thème Bébé';
      case 'dark':
        return 'Thème Sombre';
      case 'warm':
        return 'Thème Chaleureux';
      case 'cool':
        return 'Thème Frais';
      default:
        return 'Thème Personnalisé';
    }
  }

  /// Obtient la description d'un thème
  static String getThemeDescription(String themeName) {
    switch (themeName) {
      case 'default':
      case 'baby':
        return 'Couleurs douces et apaisantes pour bébé';
      case 'dark':
        return 'Interface sombre pour économiser la batterie';
      case 'warm':
        return 'Tons chauds et réconfortants';
      case 'cool':
        return 'Couleurs fraîches et relaxantes';
      default:
        return 'Thème adapté à vos préférences';
    }
  }
}