// ============================================================================
// PROVIDER DE THÈME AMÉLIORÉ
// ============================================================================

// lib/providers/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ui/theme/app_color_schemes.dart';
import '../ui/theme/app_theme_manager.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = true; // Sombre par défaut
  ColorSchemeType _colorScheme = ColorSchemeType.cosmic;
  
  bool get isDarkMode => _isDarkMode;
  ColorSchemeType get colorScheme => _colorScheme;
  
  ThemeData get currentTheme => AppThemeManager.createTheme(
    colorScheme: _colorScheme,
    isDarkMode: _isDarkMode,
  );

  // Couleurs actuelles pour les widgets
  Map<String, Color> get colors => AppColorSchemes.getColorScheme(_colorScheme);

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('dark_mode') ?? true;
    
    final colorSchemeIndex = prefs.getInt('color_scheme') ?? 0;
    _colorScheme = ColorSchemeType.values[colorSchemeIndex];
    
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', _isDarkMode);
    notifyListeners();
  }

  Future<void> setColorScheme(ColorSchemeType scheme) async {
    _colorScheme = scheme;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('color_scheme', scheme.index);
    notifyListeners();
  }

  Future<void> setTheme({bool? isDarkMode, ColorSchemeType? colorScheme}) async {
    if (isDarkMode != null) _isDarkMode = isDarkMode;
    if (colorScheme != null) _colorScheme = colorScheme;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', _isDarkMode);
    await prefs.setInt('color_scheme', _colorScheme.index);
    
    notifyListeners();
  }
}
