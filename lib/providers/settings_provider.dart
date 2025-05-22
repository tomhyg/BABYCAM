import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';
import '../ui/theme/app_color_schemes.dart';

class SettingsProvider with ChangeNotifier {
  SharedPreferences? _prefs;
  
  // Paramètres existants
  String _cameraIp = AppConfig.defaultApiIp;
  String _apiPort = AppConfig.defaultApiPort.toString();
  String _cameraPort = '80';
  bool _notificationsEnabled = true;
  String _language = 'fr';
  bool _onboardingCompleted = false;
  String? _wifiSsid;
  String? _wifiPassword;
  
  // NOUVEAUX: Paramètres de thème
  bool _darkMode = true; // Sombre par défaut
  ColorSchemeType _colorScheme = ColorSchemeType.cosmic;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    
    // Paramètres existants
    _onboardingCompleted = _prefs?.getBool(AppConfig.prefOnboardingCompleted) ?? false;
    _cameraIp = _prefs?.getString(AppConfig.prefCameraIp) ?? AppConfig.defaultApiIp;
    _apiPort = _prefs?.getString(AppConfig.prefPort) ?? AppConfig.defaultApiPort.toString();
    _cameraPort = _prefs?.getString(AppConfig.prefCameraPort) ?? '80';
    _notificationsEnabled = _prefs?.getBool(AppConfig.prefNotificationsEnabled) ?? true;
    _language = _prefs?.getString(AppConfig.prefLanguage) ?? 'fr';
    _wifiSsid = _prefs?.getString(AppConfig.prefWifiSsid);
    _wifiPassword = _prefs?.getString(AppConfig.prefWifiPassword);
    
    // NOUVEAUX: Paramètres de thème
    _darkMode = _prefs?.getBool('dark_mode_v2') ?? true;
    final colorSchemeIndex = _prefs?.getInt('color_scheme_v2') ?? 0;
    _colorScheme = ColorSchemeType.values[colorSchemeIndex.clamp(0, ColorSchemeType.values.length - 1)];
    
    notifyListeners();
  }

  // Getters existants
  bool get onboardingCompleted => _onboardingCompleted;
  String get cameraIp => _cameraIp;
  String get apiPort => _apiPort;
  String get cameraPort => _cameraPort;
  bool get notificationsEnabled => _notificationsEnabled;
  String get language => _language;
  String? get wifiSsid => _wifiSsid;
  String? get wifiPassword => _wifiPassword;
  
  // NOUVEAUX: Getters de thème
  bool get darkMode => _darkMode;
  ColorSchemeType get colorScheme => _colorScheme;
  Map<String, Color> get currentColors => AppColorSchemes.getColorScheme(_colorScheme);

  // URLs existantes
  String get fullCameraStreamUrl => 'http://$_cameraIp:8080/stream';
  String get baseUrl => 'http://$_cameraIp:8080';
  String get fullApiUrl => baseUrl;

  // Setters existants
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

  Future<void> saveWifiCredentials(String ssid, String password) async {
    _wifiSsid = ssid;
    _wifiPassword = password;
    await _prefs?.setString(AppConfig.prefWifiSsid, ssid);
    await _prefs?.setString(AppConfig.prefWifiPassword, password);
    notifyListeners();
  }

  // NOUVEAUX: Setters de thème
  Future<void> setDarkMode(bool value) async {
    _darkMode = value;
    await _prefs?.setBool('dark_mode_v2', value);
    notifyListeners();
  }

  Future<void> setColorScheme(ColorSchemeType scheme) async {
    _colorScheme = scheme;
    await _prefs?.setInt('color_scheme_v2', scheme.index);
    notifyListeners();
  }

  Future<void> setTheme({bool? isDarkMode, ColorSchemeType? colorScheme}) async {
    if (isDarkMode != null) _darkMode = isDarkMode;
    if (colorScheme != null) _colorScheme = colorScheme;
    
    await _prefs?.setBool('dark_mode_v2', _darkMode);
    await _prefs?.setInt('color_scheme_v2', _colorScheme.index);
    
    notifyListeners();
  }

  // Méthode utilitaire pour obtenir le thème actuel
  String get currentThemeName => AppColorSchemes.getThemeName(_colorScheme);
  String get currentThemeDescription => AppColorSchemes.getThemeDescription(_colorScheme);
}
