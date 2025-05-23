// lib/providers/monitoring_provider.dart

import 'package:flutter/material.dart';
import '../core/models/monitoring_state.dart';
import '../core/services/audio_service.dart';

class MonitoringProvider with ChangeNotifier {
  AudioService? _audioService;
  MonitoringState _currentState = MonitoringState.inactive;
  bool _isTransitioning = false;
  
  // Getters publics
  MonitoringState get currentState => _currentState;
  bool get isActive => _currentState != MonitoringState.inactive;
  bool get isTransitioning => _isTransitioning;
  
  // Getters de commodité pour l'UI - ✅ Corrigés
  String get currentLabel => _currentState.displayName;  // ✅ Changé de .label à .displayName
  IconData get currentIcon => _currentState.icon;
  Color get currentColor => _currentState.color;

  /// Initialise le provider avec l'URL de base
  void initialize(String baseUrl) {
    _audioService = AudioService(baseUrl: baseUrl);
    debugPrint('🎧 MonitoringProvider initialisé avec baseUrl: $baseUrl');
  }

  /// Cycle entre les états de monitoring
  Future<void> cycleState() async {
    if (_isTransitioning) {
      debugPrint('🎧 Transition en cours, cycle ignoré');
      return;
    }

    final states = MonitoringState.values;
    final currentIndex = states.indexOf(_currentState);
    final nextIndex = (currentIndex + 1) % states.length;
    final nextState = states[nextIndex];
    
    debugPrint('🎧 Cycle: ${_currentState.displayName} → ${nextState.displayName}');  // ✅ Corrigé
    await setMonitoringState(nextState);
  }

  /// Définit un état de monitoring spécifique
  Future<void> setMonitoringState(MonitoringState state) async {
    if (_currentState == state) {
      debugPrint('🎧 État déjà actif: ${state.displayName}');  // ✅ Corrigé
      return;
    }

    _isTransitioning = true;
    notifyListeners();

    try {
      final oldState = _currentState;
      
      // Appeler le service audio si disponible
      if (_audioService != null) {
        // Pour l'instant, on simule l'appel car l'ESP32 ne supporte pas encore
        // await _audioService!.setMonitoringMode(state);
        
        // Simulation d'un délai réseau
        await Future.delayed(const Duration(milliseconds: 200));
      }
      
      _currentState = state;
      
      debugPrint('✅ État monitoring changé: ${oldState.displayName} → ${state.displayName}');  // ✅ Corrigé
      
      // Feedback haptique pour améliorer l'UX
      _triggerHapticFeedback(state);
      
    } catch (e) {
      debugPrint('❌ Erreur lors du changement d\'état monitoring: $e');
      // En cas d'erreur, on garde l'ancien état
    } finally {
      _isTransitioning = false;
      notifyListeners();
    }
  }

  /// Active uniquement l'écoute
  Future<void> startListening() async {
    await setMonitoringState(MonitoringState.listening);
  }

  /// Active uniquement le mode parler
  Future<void> startTalking() async {
    await setMonitoringState(MonitoringState.talking);
  }

  /// Active l'intercom (écoute + parler)
  Future<void> startIntercom() async {
    await setMonitoringState(MonitoringState.intercom);
  }

  /// Désactive le monitoring
  Future<void> stop() async {
    await setMonitoringState(MonitoringState.inactive);
  }

  /// Basculer entre inactif et écoute (toggle simple)
  Future<void> toggleListening() async {
    if (_currentState == MonitoringState.listening) {
      await stop();
    } else {
      await startListening();
    }
  }

  /// Vérifie si l'écoute est active
  bool get isListening => 
      _currentState == MonitoringState.listening || 
      _currentState == MonitoringState.intercom;

  /// Vérifie si le mode parler est actif
  bool get isTalking => 
      _currentState == MonitoringState.talking || 
      _currentState == MonitoringState.intercom;

  /// Obtient la description de l'état actuel
  String get stateDescription {
    switch (_currentState) {
      case MonitoringState.inactive:
        return 'Surveillance audio désactivée';
      case MonitoringState.listening:
        return 'Écoute des sons de la chambre';
      case MonitoringState.talking:
        return 'Communication vers bébé active';
      case MonitoringState.intercom:
        return 'Communication bidirectionnelle active';
    }
  }

  /// Obtient des conseils d'utilisation pour l'état actuel
  String get usageTip {
    switch (_currentState) {
      case MonitoringState.inactive:
        return 'Tapez pour activer la surveillance audio';
      case MonitoringState.listening:
        return 'Vous entendez les sons de la chambre';
      case MonitoringState.talking:
        return 'Parlez pour rassurer bébé';
      case MonitoringState.intercom:
        return 'Communication complète active';
    }
  }

  /// Déclenche un feedback haptique selon l'état
  void _triggerHapticFeedback(MonitoringState state) {
    // Note: Vous pouvez utiliser le package 'vibration' pour un feedback plus avancé
    switch (state) {
      case MonitoringState.inactive:
        // Pas de vibration pour l'arrêt
        break;
      case MonitoringState.listening:
        // Vibration courte pour l'écoute
        debugPrint('📳 Feedback haptique: écoute activée');
        break;
      case MonitoringState.talking:
        // Vibration double pour parler
        debugPrint('📳 Feedback haptique: mode parler activé');
        break;
      case MonitoringState.intercom:
        // Vibration longue pour intercom
        debugPrint('📳 Feedback haptique: intercom activé');
        break;
    }
  }

  /// Obtient la couleur d'état pour l'UI
  Color getStateColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final baseColor = _currentState.color;
    
    // Adapter la couleur selon le thème
    if (brightness == Brightness.dark) {
      return baseColor;
    } else {
      return baseColor.withOpacity(0.8);
    }
  }

  /// Réinitialise le monitoring
  Future<void> reset() async {
    debugPrint('🔄 Réinitialisation du monitoring');
    await setMonitoringState(MonitoringState.inactive);
  }

  /// Méthode de debug pour afficher l'état - ✅ Corrigée
  void debugPrintState() {
    debugPrint('🎧 État MonitoringProvider:');
    debugPrint('   État actuel: ${_currentState.displayName}');  // ✅ Corrigé
    debugPrint('   Est actif: $isActive');
    debugPrint('   Écoute: $isListening');
    debugPrint('   Parler: $isTalking');
    debugPrint('   En transition: $_isTransitioning');
    debugPrint('   Service audio: ${_audioService != null ? 'OK' : 'Non initialisé'}');
  }

  @override
  void dispose() {
    debugPrint('🎧 MonitoringProvider dispose');
    super.dispose();
  }
}