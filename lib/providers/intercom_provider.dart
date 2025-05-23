// lib/providers/intercom_provider.dart

import 'package:flutter/material.dart';

class IntercomProvider with ChangeNotifier {
  bool _isInitialized = false;
  bool _isTalking = false;
  String _serverIp = '';
  int _serverPort = 8080;

  bool get isInitialized => _isInitialized;
  bool get isTalking => _isTalking;
  String get serverIp => _serverIp;
  int get serverPort => _serverPort;

  /// Initialise le provider avec les paramètres du serveur
  void initialize(String serverIp, int port) {
    _serverIp = serverIp;
    _serverPort = port;
    _isInitialized = true;
    
    debugPrint('🎙️ IntercomProvider initialisé: $serverIp:$port');
    notifyListeners();
  }

  /// Démarre l'intercom (mode parler)
  Future<void> startTalking() async {
    if (!_isInitialized) {
      debugPrint('⚠️ IntercomProvider non initialisé');
      return;
    }
    
    try {
      debugPrint('🎙️ Démarrage de l\'intercom...');
      
      // Simulation d'un délai de connexion
      await Future.delayed(const Duration(milliseconds: 200));
      
      _isTalking = true;
      notifyListeners();
      
      debugPrint('✅ Intercom démarré avec succès');
    } catch (e) {
      debugPrint('❌ Erreur lors du démarrage de l\'intercom: $e');
      rethrow;
    }
  }

  /// Arrête l'intercom
  Future<void> stopTalking() async {
    if (!_isTalking) return;
    
    try {
      debugPrint('🎙️ Arrêt de l\'intercom...');
      
      // Simulation d'un délai de déconnexion
      await Future.delayed(const Duration(milliseconds: 100));
      
      _isTalking = false;
      notifyListeners();
      
      debugPrint('✅ Intercom arrêté avec succès');
    } catch (e) {
      debugPrint('❌ Erreur lors de l\'arrêt de l\'intercom: $e');
      // On arrête quand même l'état local même en cas d'erreur
      _isTalking = false;
      notifyListeners();
    }
  }

  /// Bascule l'état de l'intercom
  Future<void> toggle() async {
    if (_isTalking) {
      await stopTalking();
    } else {
      await startTalking();
    }
  }

  /// Obtient l'état de l'intercom sous forme de texte
  String get statusText {
    if (!_isInitialized) return 'Non initialisé';
    if (_isTalking) return 'Parole active';
    return 'En attente';
  }

  /// Obtient la couleur d'état
  Color get statusColor {
    if (!_isInitialized) return Colors.grey;
    if (_isTalking) return Colors.red;
    return Colors.green;
  }

  /// Méthode de debug
  void debugPrintState() {
    debugPrint('🎙️ État IntercomProvider:');
    debugPrint('   Initialisé: $_isInitialized');
    debugPrint('   En cours de communication: $_isTalking');
    debugPrint('   Serveur: $_serverIp:$_serverPort');
  }

  @override
  void dispose() {
    if (_isTalking) {
      stopTalking();
    }
    debugPrint('🎙️ IntercomProvider dispose');
    super.dispose();
  }
}