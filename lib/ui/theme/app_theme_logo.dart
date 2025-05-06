// lib/ui/theme/app_theme_logo.dart

import 'package:flutter/material.dart';
import 'app_colors_logo.dart';
import 'app_text_styles.dart';

class AppThemeLogo {
  // Création d'un schéma de couleur personnalisé basé sur une couleur primaire
  static ColorScheme _createScheme({required Brightness brightness}) {
    final isDark = brightness == Brightness.dark;
    
    return ColorScheme(
      brightness: brightness,
      // Couleurs primaires
      primary: AppColorsLogo.primary,
      onPrimary: isDark ? Colors.black : Colors.white,
      primaryContainer: isDark ? AppColorsLogo.primary.withOpacity(0.2) : AppColorsLogo.primary.withOpacity(0.8),
      onPrimaryContainer: isDark ? AppColorsLogo.primary.withOpacity(0.8) : Colors.white,
      
      // Couleurs secondaires
      secondary: AppColorsLogo.secondary,
      onSecondary: isDark ? Colors.black : Colors.white,
      secondaryContainer: isDark ? AppColorsLogo.secondary.withOpacity(0.2) : AppColorsLogo.secondary.withOpacity(0.8),
      onSecondaryContainer: isDark ? AppColorsLogo.secondary.withOpacity(0.8) : Colors.white,
      
      // Couleurs tertiaires
      tertiary: AppColorsLogo.accent,
      onTertiary: Colors.white,
      tertiaryContainer: isDark ? AppColorsLogo.accent.withOpacity(0.2) : AppColorsLogo.accent.withOpacity(0.8),
      onTertiaryContainer: Colors.white,
      
      // Couleurs d'erreur
      error: isDark ? AppColorsLogo.error : AppColorsLogo.error,
      onError: Colors.white,
      errorContainer: isDark ? AppColorsLogo.error.withOpacity(0.2) : AppColorsLogo.error.withOpacity(0.8),
      onErrorContainer: Colors.white,
      
      // Couleurs de fond
      background: isDark ? AppColorsLogo.backgroundDark : AppColorsLogo.backgroundLight,
      onBackground: isDark ? Colors.white : Colors.black,
      surface: isDark ? AppColorsLogo.surfaceDark : AppColorsLogo.surfaceLight,
      onSurface: isDark ? Colors.white : Colors.black,
      
      // Couleurs supplémentaires
      surfaceVariant: isDark ? AppColorsLogo.surfaceVariantDark : AppColorsLogo.surfaceVariantLight,
      onSurfaceVariant: isDark ? Colors.white.withOpacity(0.8) : Colors.black.withOpacity(0.8),
      outline: isDark ? Colors.white.withOpacity(0.4) : Colors.black.withOpacity(0.4),
      outlineVariant: isDark ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.2),
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: isDark ? AppColorsLogo.surfaceLight : AppColorsLogo.surfaceDark,
      onInverseSurface: isDark ? Colors.black : Colors.white,
      inversePrimary: isDark ? AppColorsLogo.primary.withOpacity(0.8) : AppColorsLogo.primary.withOpacity(0.2),
      surfaceTint: AppColorsLogo.primary,
    );
  }

  static ThemeData get lightTheme {
    final colorScheme = _createScheme(brightness: Brightness.light);
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.light,
      
      // Personnalisation de l'AppBar
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        centerTitle: false,
        titleSpacing: 16,
        titleTextStyle: AppTextStyles.headline3.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
        iconTheme: IconThemeData(
          color: colorScheme.onSurface,
        ),
      ),
      
      // Style des cartes
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: colorScheme.outlineVariant,
            width: 1,
          ),
        ),
        color: colorScheme.surface,
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      ),
      
      // Style des boutons élevés
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: colorScheme.onPrimary,
          backgroundColor: colorScheme.primary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          minimumSize: const Size(0, 48),
          textStyle: AppTextStyles.button,
        ),
      ),
      
      // Style des boutons texte
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),
      
      // Style des boutons contour
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.outline, width: 1),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          minimumSize: const Size(0, 48),
          textStyle: AppTextStyles.button,
        ),
      ),
      
      // Style des boutons icônes (flottants)
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColorsLogo.secondary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      // Style des champs texte
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceVariant.withOpacity(0.5),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: 2,
          ),
        ),
        hintStyle: TextStyle(
          color: colorScheme.onSurfaceVariant.withOpacity(0.7),
          fontSize: 16,
        ),
      ),
      
      // Style des commutateurs (switch)
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.white;
          }
          return colorScheme.onSurfaceVariant;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColorsLogo.secondary;
          }
          return colorScheme.surfaceVariant;
        }),
      ),
      
      // Style des sliders
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColorsLogo.secondary,
        inactiveTrackColor: colorScheme.surfaceVariant,
        thumbColor: AppColorsLogo.secondary,
        overlayColor: AppColorsLogo.secondary.withOpacity(0.2),
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 10,
        ),
        overlayShape: const RoundSliderOverlayShape(
          overlayRadius: 24,
        ),
      ),
      
      // Style des dialogues
      dialogTheme: DialogTheme(
        backgroundColor: colorScheme.surface,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      
      // Style des Chipsets
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceVariant,
        labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
        selectedColor: AppColorsLogo.primary,
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      
      // Polices de caractères
      textTheme: TextTheme(
        displayLarge: AppTextStyles.headline1,
        displayMedium: AppTextStyles.headline2,
        displaySmall: AppTextStyles.headline3,
        headlineMedium: AppTextStyles.subtitle1,
        headlineSmall: AppTextStyles.subtitle2,
        bodyLarge: AppTextStyles.bodyText1,
        bodyMedium: AppTextStyles.bodyText2,
        labelLarge: AppTextStyles.button,
        bodySmall: AppTextStyles.caption,
        labelSmall: AppTextStyles.overline,
      ),
      
      // Définition des animations
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      
      // Configuration supplémentaire pour Material 3
      splashColor: AppColorsLogo.primary.withOpacity(0.1),
      highlightColor: AppColorsLogo.primary.withOpacity(0.05),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: 16,
      ),
      iconTheme: IconThemeData(
        color: colorScheme.onSurface,
        size: 24,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColorsLogo.secondary,
        circularTrackColor: colorScheme.surfaceVariant,
        linearTrackColor: colorScheme.surfaceVariant,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: colorScheme.surface,
        selectedItemColor: AppColorsLogo.accent,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        elevation: 8,
      ),
    );
  }

  static ThemeData get darkTheme {
    final colorScheme = _createScheme(brightness: Brightness.dark);
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.dark,
      
      // Personnalisation de l'AppBar
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        centerTitle: false,
        titleSpacing: 16,
        titleTextStyle: AppTextStyles.headline3.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
        iconTheme: IconThemeData(
          color: colorScheme.onSurface,
        ),
      ),
      
      // Style des cartes
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: colorScheme.outlineVariant,
            width: 1,
          ),
        ),
        color: colorScheme.surfaceVariant,
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      ),
      
      // Style des boutons élevés
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: AppColorsLogo.secondary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          minimumSize: const Size(0, 48),
          textStyle: AppTextStyles.button,
        ),
      ),
      
      // Style des boutons texte
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColorsLogo.secondary,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),
      
      // Style des boutons contour
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColorsLogo.secondary,
          side: BorderSide(color: colorScheme.outline, width: 1),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          minimumSize: const Size(0, 48),
          textStyle: AppTextStyles.button,
        ),
      ),
      
      // Style des boutons icônes (flottants)
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColorsLogo.secondary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      // Style des champs texte
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColorsLogo.secondary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: 2,
          ),
        ),
        hintStyle: TextStyle(
          color: colorScheme.onSurfaceVariant.withOpacity(0.7),
          fontSize: 16,
        ),
      ),
      
      // Style des commutateurs (switch)
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.white;
          }
          return colorScheme.onSurfaceVariant;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColorsLogo.secondary;
          }
          return colorScheme.surfaceVariant;
        }),
      ),
      
      // Style des sliders
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColorsLogo.secondary,
        inactiveTrackColor: colorScheme.surfaceVariant,
        thumbColor: AppColorsLogo.secondary,
        overlayColor: AppColorsLogo.secondary.withOpacity(0.2),
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 10,
        ),
        overlayShape: const RoundSliderOverlayShape(
          overlayRadius: 24,
        ),
      ),
      
      // Style des dialogues
      dialogTheme: DialogTheme(
        backgroundColor: colorScheme.surface,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      
      // Style des Chipsets
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceVariant,
        labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
        selectedColor: AppColorsLogo.secondary,
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      
      // Polices de caractères
      textTheme: TextTheme(
        displayLarge: AppTextStyles.headline1,
        displayMedium: AppTextStyles.headline2,
        displaySmall: AppTextStyles.headline3,
        headlineMedium: AppTextStyles.subtitle1,
        headlineSmall: AppTextStyles.subtitle2,
        bodyLarge: AppTextStyles.bodyText1,
        bodyMedium: AppTextStyles.bodyText2,
        labelLarge: AppTextStyles.button,
        bodySmall: AppTextStyles.caption,
        labelSmall: AppTextStyles.overline,
      ),
      
      // Définition des animations
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      
      // Configuration supplémentaire pour Material 3
      splashColor: AppColorsLogo.secondary.withOpacity(0.1),
      highlightColor: AppColorsLogo.secondary.withOpacity(0.05),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: 16,
      ),
      iconTheme: IconThemeData(
        color: colorScheme.onSurface,
        size: 24,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColorsLogo.secondary,
        circularTrackColor: colorScheme.surfaceVariant,
        linearTrackColor: colorScheme.surfaceVariant,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: colorScheme.surface,
        selectedItemColor: AppColorsLogo.secondary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        elevation: 8,
      ),
    );
  }
}