// lib/providers/settings_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';
import '../ui/theme/app_theme_manager.dart';

class SettingsProvider with ChangeNotifier {
  SharedPreferences? _prefs;
  String _cameraIp = AppConfig.defaultApiIp;
  String _apiPort = AppConfig.defaultApiPort.toString();
  String _cameraPort = '80';
  bool _darkMode = false;
  bool _notificationsEnabled = true;
  String _language = 'fr';
  bool _onboardingCompleted = false;
  String? _wifiSsid;
  String? _wifiPassword;
  ColorSchemeType _colorScheme = ColorSchemeType.original; // Par défaut Original

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    
    _onboardingCompleted = _prefs?.getBool(AppConfig.prefOnboardingCompleted) ?? false;
    _cameraIp = _prefs?.getString(AppConfig.prefCameraIp) ?? AppConfig.defaultApiIp;
    _apiPort = _prefs?.getString(AppConfig.prefPort) ?? AppConfig.defaultApiPort.toString();
    _cameraPort = _prefs?.getString(AppConfig.prefCameraPort) ?? '80';
    _darkMode = _prefs?.getBool(AppConfig.prefDarkMode) ?? false;
    _notificationsEnabled = _prefs?.getBool(AppConfig.prefNotificationsEnabled) ?? true;
    _language = _prefs?.getString(AppConfig.prefLanguage) ?? 'fr';
    _wifiSsid = _prefs?.getString(AppConfig.prefWifiSsid);
    _wifiPassword = _prefs?.getString(AppConfig.prefWifiPassword);
    
    // Charger le thème de couleur
    String colorSchemeString = _prefs?.getString('color_scheme') ?? 'original';
    _colorScheme = AppThemeManager.getColorSchemeFromString(colorSchemeString);
    
    notifyListeners();
  }

  // Getters
  bool get onboardingCompleted => _onboardingCompleted;
  String get cameraIp => _cameraIp;
  String get apiPort => _apiPort;
  String get cameraPort => _cameraPort;
  bool get darkMode => _darkMode;
  bool get notificationsEnabled => _notificationsEnabled;
  String get language => _language;
  ColorSchemeType get colorScheme => _colorScheme;
  String? get wifiSsid => _wifiSsid;
  String? get wifiPassword => _wifiPassword;

  // Méthodes pour les thèmes
  String get currentThemeName => AppThemeManager.getThemeName(_colorScheme);
  String get currentThemeDescription => AppThemeManager.getThemeDescription(_colorScheme);
  IconData get currentThemeIcon => AppThemeManager.getThemeIcon(_colorScheme);
  List<Color> get currentColors => AppThemeManager.getThemeColors(_colorScheme);

  // Setters
  Future<void> setOnboardingCompleted(bool value) async {
    _onboardingCompleted = value;
    await _prefs?.setBool(AppConfig.prefOnboardingCompleted, value);
    notifyListeners();
  }

  set cameraIp(String value) {
    _cameraIp = value;
    _prefs?.setString(AppConfig.prefCameraIp, value);
    notifyListeners();
  }

  set apiPort(String value) {
    _apiPort = value;
    _prefs?.setString(AppConfig.prefPort, value);
    notifyListeners();
  }

  set cameraPort(String value) {
    _cameraPort = value;
    _prefs?.setString(AppConfig.prefCameraPort, value);
    notifyListeners();
  }

  set darkMode(bool value) {
    _darkMode = value;
    _prefs?.setBool(AppConfig.prefDarkMode, value);
    notifyListeners();
  }

  set notificationsEnabled(bool value) {
    _notificationsEnabled = value;
    _prefs?.setBool(AppConfig.prefNotificationsEnabled, value);
    notifyListeners();
  }

  set language(String value) {
    _language = value;
    _prefs?.setString(AppConfig.prefLanguage, value);
    notifyListeners();
  }

  Future<void> setColorScheme(ColorSchemeType value) async {
    _colorScheme = value;
    String stringValue = AppThemeManager.getStringFromColorScheme(value);
    await _prefs?.setString('color_scheme', stringValue);
    notifyListeners();
  }

  // Version string pour compatibilité
  Future<void> setColorSchemeFromString(String value) async {
    ColorSchemeType scheme = AppThemeManager.getColorSchemeFromString(value);
    await setColorScheme(scheme);
  }

  Future<void> saveWifiCredentials(String ssid, String password) async {
    _wifiSsid = ssid;
    _wifiPassword = password;
    await _prefs?.setString(AppConfig.prefWifiSsid, ssid);
    await _prefs?.setString(AppConfig.prefWifiPassword, password);
    notifyListeners();
  }

  // URLs
  String get fullCameraStreamUrl => 'http://$_cameraIp:8080/stream';
  String get baseUrl => 'http://$_cameraIp:8080';
  String get fullApiUrl => baseUrl;

  // Méthode pour obtenir le thème complet
  ThemeData getThemeData() {
    return AppThemeManager.createTheme(
      colorScheme: _colorScheme,
      isDarkMode: _darkMode,
    );
  }
}