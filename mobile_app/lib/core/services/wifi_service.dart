import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wifi_iot/wifi_iot.dart';
import 'package:permission_handler/permission_handler.dart';

class WiFiService {
  final String baseUrl;

  WiFiService({required this.baseUrl});

  Future<bool> connectToCamera(String ssid, String password) async {
    // Vérifier les permissions
    var status = await Permission.location.status;
    if (!status.isGranted) {
      status = await Permission.location.request();
      if (!status.isGranted) {
        throw Exception('La permission de localisation est requise pour se connecter au WiFi');
      }
    }

    try {
      // Se connecter au point d'accès WiFi de la caméra
      return await WiFiForIoTPlugin.connect(
        ssid,
        password: password,
        security: NetworkSecurity.WPA,
      );
    } catch (e) {
      throw Exception('Échec de la connexion au WiFi de la caméra : $e');
    }
  }

  Future<List<String>> scanForCameras() async {
    try {
      var status = await Permission.location.status;
      if (!status.isGranted) {
        status = await Permission.location.request();
        if (!status.isGranted) {
          throw Exception('La permission de localisation est requise pour scanner les réseaux WiFi');
        }
      }

      final networks = await WiFiForIoTPlugin.loadWifiList();
      if (networks.isEmpty) {
        return [];
      }

      return networks
          .where((network) => (network.ssid ?? '').startsWith('BABYCAM_'))
          .map((network) => network.ssid ?? '')
          .where((ssid) => ssid.isNotEmpty)
          .toList();
    } catch (e) {
      throw Exception('Échec du scan des caméras : $e');
    }
  }

  Future<Map<String, dynamic>> getCameraInfo() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/info'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Échec de la récupération des infos caméra');
      }
    } catch (e) {
      throw Exception('Erreur réseau : $e');
    }
  }

  Future<void> configureCameraWiFi(String networkSsid, String networkPassword) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/wifi/configure'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'ssid': networkSsid,
          'password': networkPassword,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Échec de la configuration du WiFi de la caméra');
      }
    } catch (e) {
      throw Exception('Erreur réseau : $e');
    }
  }
}
