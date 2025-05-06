// lib/ui/theme/app_colors_logo.dart

import 'package:flutter/material.dart';

class AppColorsLogo {
  // Couleurs principales extraites du logo
  static const Color primary = Color(0xFFB1B0DC);    // Lavande/violet clair
  static const Color secondary = Color(0xFF7ED3BF);  // Vert menthe
  static const Color accent = Color(0xFF2B5F8E);     // Bleu profond (iris)
  static const Color background = Color(0xFFF0EFFE); // Fond lavande très clair
  static const Color highlight = Color(0xFFFFF3D1);  // Halo doré/jaune pâle
  
  // Variantes des couleurs principales
  static const Color primaryDarker = Color(0xFF9B99CE);
  static const Color secondaryDarker = Color(0xFF5DB9A4);
  static const Color accentDarker = Color(0xFF1D4369);
  
  // Couleurs sémantiques pour les capteurs et données
  static const Color temperatureColor = Color(0xFFFFB26B); // Orange doux
  static const Color humidityColor = Color(0xFF81C8FF);    // Bleu ciel
  static const Color airQualityColor = Color(0xFF7ED3BF);  // Vert menthe (même que secondary)
  static const Color lightLevelColor = Color(0xFFFFF3D1);  // Jaune pâle (même que highlight)
  static const Color pressureColor = Color(0xFFB1B0DC);    // Lavande (même que primary)
  static const Color sleepColor = Color(0xFF9B99CE);       // Lavande plus foncé
  
  // États et alertes
  static const Color success = Color(0xFF7ED3BF);  // Vert menthe
  static const Color warning = Color(0xFFFFB26B);  // Orange doux
  static const Color error = Color(0xFFFF8E99);    // Rouge doux
  static const Color info = Color(0xFF81C8FF);     // Bleu ciel
  
  // Arrière-plans et surfaces
  static const Color backgroundLight = Color(0xFFF0EFFE);  // Fond principal clair
  static const Color backgroundDark = Color(0xFF2F2E45);   // Fond principal sombre
  static const Color surfaceLight = Colors.white;          // Surface claire
  static const Color surfaceDark = Color(0xFF3D3C57);      // Surface sombre
  static const Color surfaceVariantLight = Color(0xFFE8E6FF); // Variante surface claire
  static const Color surfaceVariantDark = Color(0xFF4A4967);  // Variante surface sombre
  
  // Couleurs de niveau d'état (du bon au mauvais)
  static const List<Color> statusColors = [
    Color(0xFF7ED3BF), // Excellent - vert menthe
    Color(0xFF81C8FF), // Très bon - bleu ciel
    Color(0xFFFFF3D1), // Bon - jaune pâle
    Color(0xFFFFB26B), // Moyen - orange doux
    Color(0xFFFF8E99), // Mauvais - rouge doux
  ];
  
  // Dégradés
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
  
  // Dégradé spécial du logo (fond avec halo)
  static const List<Color> logoGradient = [
    Color(0xFFF0EFFE),  // Lavande très clair
    Color(0xFFFFF3D1),  // Halo doré/jaune pâle
    Color(0xFFF0EFFE),  // Lavande très clair
  ];
  
  // Méthode utilitaire pour obtenir une couleur selon la qualité
  static Color getQualityColor(double value, {bool reversed = false}) {
    // Valeur normalisée entre 0 et 1
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
  
  // Utiliser des couleurs avec opacité
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }
}