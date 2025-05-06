import 'dart:async';
import 'package:http/http.dart' as http;
import '../models/camera_settings.dart';

class CameraService {
  final String baseUrl;
  
  CameraService({required this.baseUrl});
  
  // Cette méthode renvoie l'URL du flux MJPEG pour l'ESP32-CAM
  Future<String> getStreamUrl() async {
    try {
      // Pour l'ESP32-CAM avec le code d'exemple, l'URL du stream est:
      return "$baseUrl";
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  Future<void> updateSettings(CameraSettings settings) async {
    try {
      // Exemple pour le contrôle de la résolution
      if (settings.resolution == "SD") {
        await http.get(Uri.parse('$baseUrl/control?var=framesize&val=5')); // CIF
      } else if (settings.resolution == "HD") {
        await http.get(Uri.parse('$baseUrl/control?var=framesize&val=8')); // VGA
      } else if (settings.resolution == "FHD") {
        await http.get(Uri.parse('$baseUrl/control?var=framesize&val=10')); // UXGA
      }
      
      // Contrôle du contraste
      int contrastVal = ((settings.contrast - 50) / 50 * 2).round();
      await http.get(Uri.parse('$baseUrl/control?var=contrast&val=$contrastVal'));
      
      // Contrôle de la luminosité
      int brightnessVal = ((settings.brightness - 50) / 50 * 2).round();
      await http.get(Uri.parse('$baseUrl/control?var=brightness&val=$brightnessVal'));
      
      // Vision nocturne
      if (settings.nightVisionEnabled) {
        // Activer le mode gain automatique
        await http.get(Uri.parse('$baseUrl/control?var=gainceiling&val=2'));
        // Réduire l'exposition pour améliorer la sensibilité
        await http.get(Uri.parse('$baseUrl/control?var=aec&val=1'));
      } else {
        // Paramètres normaux pour la vision diurne
        await http.get(Uri.parse('$baseUrl/control?var=gainceiling&val=0'));
        await http.get(Uri.parse('$baseUrl/control?var=aec&val=1'));
      }
      
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  Future<void> toggleNightLight(bool enabled, int brightness) async {
    try {
      // Utilisez le contrôle de flash LED intégré dans l'ESP32-CAM
      if (enabled) {
        // Calcul pour convertir le pourcentage (0-100) en valeur (0-255)
        int ledVal = (brightness * 255 / 100).round();
        await http.get(Uri.parse('$baseUrl/control?var=led_intensity&val=$ledVal'));
      } else {
        // Éteindre la LED
        await http.get(Uri.parse('$baseUrl/control?var=led_intensity&val=0'));
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  Future<void> captureSnapshot() async {
    try {
      // L'ESP32-CAM permet de capturer une image unique à cette URL
      await http.get(Uri.parse('$baseUrl/capture'));
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}