// lib/providers/theme_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ui/theme/app_colors.dart';  // ✅ Import corrigé
import '../ui/theme/app_theme_manager.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  String _colorScheme = 'baby';
  SharedPreferences? _prefs;

  ThemeMode get themeMode => _themeMode;
  String get colorScheme => _colorScheme;
  Map<String, Color> get colors => AppColors.getColorScheme(_colorScheme);  // ✅ Corrigé

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _themeMode = ThemeMode.values[_prefs?.getInt('theme_mode') ?? 0];
    _colorScheme = _prefs?.getString('color_scheme') ?? 'baby';
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _prefs?.setInt('theme_mode', mode.index);
    notifyListeners();
  }

  Future<void> setColorScheme(String scheme) async {
    _colorScheme = scheme;
    await _prefs?.setString('color_scheme', scheme);
    notifyListeners();
  }

  ThemeData getLightTheme() {
    return AppThemeManager.getLightTheme(_colorScheme);
  }

  ThemeData getDarkTheme() {
    return AppThemeManager.getDarkTheme(_colorScheme);
  }

  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  String get currentThemeName => AppColors.getThemeName(_colorScheme);  // ✅ Corrigé
  String get currentThemeDescription => AppColors.getThemeDescription(_colorScheme);  // ✅ Corrigé
  IconData get currentThemeIcon => AppColors.getThemeIcon(_colorScheme);  // ✅ Corrigé

  List<String> get availableColorSchemes {
    return AppThemeManager.getAvailableColorSchemes();
  }

  void toggleTheme() {
    switch (_themeMode) {
      case ThemeMode.system:
        setThemeMode(ThemeMode.light);
        break;
      case ThemeMode.light:
        setThemeMode(ThemeMode.dark);
        break;
      case ThemeMode.dark:
        setThemeMode(ThemeMode.system);
        break;
    }
  }
}