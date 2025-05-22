// lib/providers/intercom_provider.dart
import 'package:flutter/material.dart';
import '../core/services/intercom_service.dart';

class IntercomProvider with ChangeNotifier {
  IntercomService? _intercomService;
  bool _isInitialized = false;
  bool _isTalking = false;

  bool get isInitialized => _isInitialized;
  bool get isTalking => _isTalking;

  void initialize(String serverIp, int port) {
    _intercomService = IntercomService(serverIp: serverIp, serverPort: port);
    _intercomService!.initialize().then((_) {
      _isInitialized = true;
      notifyListeners();
    }).catchError((error) {
      debugPrint('Erreur d\'initialisation de l\'interphone: $error');
    });
  }

  Future<void> startTalking() async {
    if (_intercomService == null) return;
    
    try {
      await _intercomService!.startTalking();
      _isTalking = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur lors du démarrage de l\'interphone: $e');
      rethrow;
    }
  }

  Future<void> stopTalking() async {
    if (_intercomService == null) return;
    
    try {
      await _intercomService!.stopTalking();
      _isTalking = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur lors de l\'arrêt de l\'interphone: $e');
      rethrow;
    }
  }

  void dispose() {
    _intercomService?.dispose();
    super.dispose();
  }
}