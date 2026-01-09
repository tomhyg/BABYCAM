import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../core/models/camera_settings.dart';
import '../core/models/baby_event.dart';
import '../core/services/camera_service.dart';

class CameraProvider with ChangeNotifier {
  CameraService? _cameraService;
  CameraSettings _settings = CameraSettings();
  String _streamUrl = '';
  bool _isStreaming = false;
  List<BabyEvent> _events = [];
  bool _isNightLightOn = false;
  bool _isIntercomActive = false;
  String _baseUrl = '';

  CameraSettings get settings => _settings;
  String get streamUrl => _streamUrl;
  bool get isStreaming => _isStreaming;
  List<BabyEvent> get events => _events;
  bool get isNightLightOn => _isNightLightOn;
  bool get isIntercomActive => _isIntercomActive;
  String get baseUrl => _baseUrl;

  void initialize(String baseUrl) {
    _baseUrl = baseUrl;
    _cameraService = CameraService(baseUrl: baseUrl);
    _loadStreamUrl();
    _loadEvents();
  }

  Future<void> _loadStreamUrl() async {
    try {
      if (_cameraService != null) {
        _streamUrl = await _cameraService!.getStreamUrl();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading stream URL: $e');
    }
  }

  Future<void> _loadEvents() async {
    // Dans une application réelle, charger les événements depuis un API
    // Pour l'exemple, nous utilisons des données simulées
    _events = [
      BabyEvent(
        id: '1',
        type: 'cry',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        metadata: {'intensity': 'high'},
      ),
      BabyEvent(
        id: '2',
        type: 'movement',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      BabyEvent(
        id: '3',
        type: 'face_detected',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        imageUrl: 'https://example.com/snapshot1.jpg',
      ),
    ];
    notifyListeners();
  }

  Future<void> startStreaming() async {
    _isStreaming = true;
    notifyListeners();
  }

  Future<void> stopStreaming() async {
    _isStreaming = false;
    notifyListeners();
  }

  Future<void> updateSettings(CameraSettings newSettings) async {
    try {
      if (_cameraService != null) {
        await _cameraService!.updateSettings(newSettings);
        _settings = newSettings;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating camera settings: $e');
      rethrow;
    }
  }

  Future<void> toggleNightLight(bool enabled, [int? brightness]) async {
    try {
      if (_cameraService != null) {
        final brightnessValue = brightness ?? _settings.nightLightBrightness;
        await _cameraService!.toggleNightLight(enabled, brightnessValue);
        _isNightLightOn = enabled;
        
        // Mettre à jour les paramètres
        _settings = _settings.copyWith(
          nightLightEnabled: enabled,
          nightLightBrightness: brightnessValue,
        );
        
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error toggling night light: $e');
      rethrow;
    }
  }

  Future<void> captureSnapshot() async {
    try {
      if (_cameraService != null) {
        await _cameraService!.captureSnapshot();
      }
    } catch (e) {
      debugPrint('Error capturing snapshot: $e');
      rethrow;
    }
  }

  // Fonctions pour l'interphone
  Future<void> toggleIntercom() async {
    try {
      debugPrint('Toggling intercom. Current state: $_isIntercomActive');
      if (_isIntercomActive) {
        await stopIntercom();
      } else {
        await startIntercom();
      }
      debugPrint('Intercom toggled successfully. New state: $_isIntercomActive');
    } catch (e) {
      debugPrint('Error toggling intercom: $e');
      rethrow;
    }
  }

  Future<void> startIntercom() async {
    try {
      debugPrint('Starting intercom...');
      if (_cameraService != null) {
        final url = '$_baseUrl/api/intercom/start';
        debugPrint('POST request to: $url');
        
        final response = await http.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
        );
        
        debugPrint('Intercom start response: ${response.statusCode} - ${response.body}');
        
        if (response.statusCode == 200) {
          _isIntercomActive = true;
          notifyListeners();
          debugPrint('Intercom started successfully');
        } else {
          throw Exception('Failed to start intercom: status ${response.statusCode} - ${response.body}');
        }
      }
    } catch (e) {
      debugPrint('Error starting intercom: $e');
      rethrow;
    }
  }

  Future<void> stopIntercom() async {
    try {
      debugPrint('Stopping intercom...');
      if (_cameraService != null) {
        final url = '$_baseUrl/api/intercom/stop';
        debugPrint('POST request to: $url');
        
        final response = await http.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
        );
        
        debugPrint('Intercom stop response: ${response.statusCode} - ${response.body}');
        
        if (response.statusCode == 200) {
          _isIntercomActive = false;
          notifyListeners();
          debugPrint('Intercom stopped successfully');
        } else {
          throw Exception('Failed to stop intercom: status ${response.statusCode} - ${response.body}');
        }
      }
    } catch (e) {
      debugPrint('Error stopping intercom: $e');
      rethrow;
    }
  }
}