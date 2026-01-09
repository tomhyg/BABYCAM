// lib/config/app_config.dart (mise à jour)

class AppConfig {
  static const String appName = 'BABYCAM AI';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';
  
  // API
  static const int defaultApiPort = 8080; // L'ESP32-CAM utilise le port 80 par défaut
  static const String defaultApiIp = '172.21.3.150'; // Changez pour l'IP de votre ESP32-CAM
  
  // Préférences
  static const String prefOnboardingCompleted = 'onboarding_completed';
  static const String prefCameraIp = 'camera_ip';
  static const String prefPort = 'port';
  static const String prefCameraPort = 'camera_port';
  static const String prefDarkMode = 'dark_mode';
  static const String prefNotificationsEnabled = 'notifications_enabled';
  static const String prefLanguage = 'language';
  static const String prefWifiSsid = 'wifi_ssid';
  static const String prefWifiPassword = 'wifi_password';
  
  // Capteurs
  static const double minTemp = 10.0;
  static const double maxTemp = 40.0;
  static const double minHumidity = 0.0;
  static const double maxHumidity = 100.0;
  static const double minAirQuality = 0.0;
  static const double maxAirQuality = 100.0;
  static const double minLightLevel = 0.0;
  static const double maxLightLevel = 10000.0;
  
  // Seuils d'alerte
  static const double tempLowAlert = 16.0;
  static const double tempHighAlert = 28.0;
  static const double humidityLowAlert = 30.0;
  static const double humidityHighAlert = 70.0;
  static const double airQualityAlert = 50.0;
}