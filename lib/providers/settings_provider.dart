// lib/providers/settings_provider.dart (mise à jour)

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';

class SettingsProvider with ChangeNotifier {
  SharedPreferences? _prefs;
  String _cameraIp = AppConfig.defaultApiIp;
  String _apiPort = AppConfig.defaultApiPort.toString();
  String _cameraPort = '80'; // Port par défaut de l'ESP32-CAM
  bool _darkMode = false;
  bool _notificationsEnabled = true;
  String _language = 'fr';
  bool _onboardingCompleted = false;
  String? _wifiSsid;
  String? _wifiPassword;

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
    
    notifyListeners();
  }

  bool get onboardingCompleted => _onboardingCompleted;
  
  Future<void> setOnboardingCompleted(bool value) async {
    _onboardingCompleted = value;
    await _prefs?.setBool(AppConfig.prefOnboardingCompleted, value);
    notifyListeners();
  }

  String get cameraIp => _cameraIp;
  set cameraIp(String value) {
    _cameraIp = value;
    _prefs?.setString(AppConfig.prefCameraIp, value);
    notifyListeners();
  }

  String get apiPort => _apiPort;
  set apiPort(String value) {
    _apiPort = value;
    _prefs?.setString(AppConfig.prefPort, value);
    notifyListeners();
  }

  String get cameraPort => _cameraPort;
  set cameraPort(String value) {
    _cameraPort = value;
    _prefs?.setString(AppConfig.prefCameraPort, value);
    notifyListeners();
  }

  bool get darkMode => _darkMode;
  set darkMode(bool value) {
    _darkMode = value;
    _prefs?.setBool(AppConfig.prefDarkMode, value);
    notifyListeners();
  }

  bool get notificationsEnabled => _notificationsEnabled;
  set notificationsEnabled(bool value) {
    _notificationsEnabled = value;
    _prefs?.setBool(AppConfig.prefNotificationsEnabled, value);
    notifyListeners();
  }

  String get language => _language;
  set language(String value) {
    _language = value;
    _prefs?.setString(AppConfig.prefLanguage, value);
    notifyListeners();
  }

  String? get wifiSsid => _wifiSsid;
  String? get wifiPassword => _wifiPassword;
  
  Future<void> saveWifiCredentials(String ssid, String password) async {
    _wifiSsid = ssid;
    _wifiPassword = password;
    await _prefs?.setString(AppConfig.prefWifiSsid, ssid);
    await _prefs?.setString(AppConfig.prefWifiPassword, password);
    notifyListeners();
  }

  // URL pour le flux vidéo MJPEG de l'ESP32-CAM
  String get fullCameraStreamUrl => 'http://$_cameraIp:$_cameraPort/stream';
  
  // URL de base de l'API
  String get baseUrl => 'http://$_cameraIp:$_apiPort';
  
  // URL complète de l'API (alias de baseUrl pour compatibilité)
  String get fullApiUrl => baseUrl;
}