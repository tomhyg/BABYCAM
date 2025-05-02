import 'package:flutter/material.dart';
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

  CameraSettings get settings => _settings;
  String get streamUrl => _streamUrl;
  bool get isStreaming => _isStreaming;
  List<BabyEvent> get events => _events;
  bool get isNightLightOn => _isNightLightOn;

  void initialize(String baseUrl) {
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
}