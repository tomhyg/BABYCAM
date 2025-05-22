// lib/providers/nightlight_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../core/models/nightlight_settings.dart';
import '../core/services/camera_service.dart';
import '../ui/theme/app_color_schemes.dart';

class NightlightProvider with ChangeNotifier {
  CameraService? _cameraService;
  NightlightSettings _settings = const NightlightSettings();
  
  // Getters publics
  NightlightSettings get settings => _settings;
  bool get isEnabled => _settings.enabled;
  String get currentColor => _settings.color;
  int get intensity => _settings.intensity;
  
  // Getter pour les couleurs disponibles
  Map<String, List<Color>> get availableColors => AppColorSchemes.nightlightColors;

  /// Initialise le provider avec l'URL de base de la caméra
  void initialize(String baseUrl) {
    _cameraService = CameraService(baseUrl: baseUrl);
    _loadSettings();
    debugPrint('🌙 NightlightProvider initialisé avec baseUrl: $baseUrl');
  }

  /// Charge les paramètres sauvegardés
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString('nightlight_settings_v2');
      
      if (settingsJson != null) {
        final Map<String, dynamic> json = 
            Map<String, dynamic>.from(jsonDecode(settingsJson));
        _settings = NightlightSettings.fromJson(json);
        debugPrint('🌙 Paramètres veilleuse chargés: ${_settings.toJson()}');
      } else {
        debugPrint('🌙 Aucun paramètre veilleuse sauvegardé, utilisation des défauts');
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Erreur lors du chargement des paramètres veilleuse: $e');
    }
  }

  /// Sauvegarde les paramètres
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('nightlight_settings_v2', jsonEncode(_settings.toJson()));
      debugPrint('💾 Paramètres veilleuse sauvegardés');
    } catch (e) {
      debugPrint('❌ Erreur lors de la sauvegarde des paramètres veilleuse: $e');
    }
  }

  /// Active/désactive la veilleuse (toggle simple)
  Future<void> toggle() async {
    final wasEnabled = _settings.enabled;
    _settings = _settings.copyWith(enabled: !_settings.enabled);
    
    debugPrint('🌙 Toggle veilleuse: $wasEnabled → ${_settings.enabled}');
    
    await _applySettings();
    notifyListeners();
  }

  /// Met à jour les paramètres de la veilleuse
  Future<void> updateSettings({
    String? color,
    int? intensity,
    bool? enabled,
    DateTime? scheduledOff,
  }) async {
    final oldSettings = _settings;
    
    _settings = _settings.copyWith(
      color: color,
      intensity: intensity,
      enabled: enabled,
      scheduledOff: scheduledOff,
    );
    
    debugPrint('🌙 Mise à jour paramètres veilleuse:');
    debugPrint('   Couleur: ${oldSettings.color} → ${_settings.color}');
    debugPrint('   Intensité: ${oldSettings.intensity} → ${_settings.intensity}');
    debugPrint('   Activée: ${oldSettings.enabled} → ${_settings.enabled}');
    
    await _applySettings();
    notifyListeners();
  }

  /// Active la veilleuse avec des paramètres spécifiques
  Future<void> activateWithSettings({
    required String color,
    required int intensity,
  }) async {
    await updateSettings(
      color: color,
      intensity: intensity,
      enabled: true,
    );
  }

  /// Désactive la veilleuse
  Future<void> deactivate() async {
    await updateSettings(enabled: false);
  }

  /// Programme l'extinction automatique
  Future<void> scheduleOff(DateTime scheduledTime) async {
    await updateSettings(scheduledOff: scheduledTime);
    
    // Calculer le délai
    final delay = scheduledTime.difference(DateTime.now());
    if (delay.isNegative) {
      debugPrint('⚠️ Heure programmée dans le passé, extinction immédiate');
      await deactivate();
      return;
    }
    
    debugPrint('⏰ Veilleuse programmée pour s\'éteindre dans ${delay.inMinutes} minutes');
    
    // Programmer l'extinction (simple - dans une vraie app, utiliser un service de background)
    Future.delayed(delay, () {
      if (_settings.scheduledOff == scheduledTime) {
        deactivate();
        debugPrint('⏰ Extinction automatique de la veilleuse');
      }
    });
  }

  /// Annule l'extinction programmée
  Future<void> cancelScheduledOff() async {
    await updateSettings(scheduledOff: null);
    debugPrint('❌ Extinction programmée annulée');
  }

  /// Applique les paramètres sur la caméra
  Future<void> _applySettings() async {
    try {
      if (_cameraService != null) {
        // Si désactivée, envoyer intensité 0
        final effectiveIntensity = _settings.enabled ? _settings.intensity : 0;
        
        // Appeler la méthode du service caméra
        await _cameraService!.toggleNightLight(_settings.enabled, effectiveIntensity);
        
        debugPrint('✅ Paramètres veilleuse appliqués sur la caméra');
      } else {
        debugPrint('⚠️ Service caméra non initialisé, paramètres non appliqués');
      }
      
      // Sauvegarder dans tous les cas
      await _saveSettings();
      
    } catch (e) {
      debugPrint('❌ Erreur lors de l\'application des paramètres veilleuse: $e');
      // En cas d'erreur réseau, on sauvegarde quand même localement
      await _saveSettings();
      rethrow; // Relancer l'erreur pour que l'UI puisse l'afficher
    }
  }

  /// Obtient le nom lisible d'une couleur
  String getColorName(String colorKey) {
    const colorNames = {
      'warm': 'Blanc chaud',
      'cool': 'Bleu frais',
      'purple': 'Violet',
      'green': 'Vert',
      'pink': 'Rose',
      'blue': 'Bleu',
      'orange': 'Orange',
      'white': 'Blanc pur',
    };
    return colorNames[colorKey] ?? colorKey;
  }

  /// Obtient la description d'une couleur
  String getColorDescription(String colorKey) {
    const colorDescriptions = {
      'warm': 'Idéal pour l\'endormissement',
      'cool': 'Apaisant et relaxant',
      'purple': 'Mystique et doux',
      'green': 'Naturel et reposant',
      'pink': 'Tendre et réconfortant',
      'blue': 'Calme et serein',
      'orange': 'Chaleureux et énergisant',
      'white': 'Neutre et fonctionnel',
    };
    return colorDescriptions[colorKey] ?? 'Couleur personnalisée';
  }

  /// Obtient l'icône recommandée pour une couleur
  IconData getColorIcon(String colorKey) {
    const colorIcons = {
      'warm': Icons.wb_incandescent,
      'cool': Icons.ac_unit,
      'purple': Icons.auto_awesome,
      'green': Icons.park,
      'pink': Icons.favorite,
      'blue': Icons.water_drop,
      'orange': Icons.wb_sunny,
      'white': Icons.lightbulb,
    };
    return colorIcons[colorKey] ?? Icons.lightbulb;
  }

  /// Vérifie si une couleur est disponible
  bool isColorAvailable(String colorKey) {
    return AppColorSchemes.nightlightColors.containsKey(colorKey);
  }

  /// Obtient la liste des couleurs disponibles
  List<String> get availableColorKeys => AppColorSchemes.nightlightColors.keys.toList();

  /// Obtient les couleurs Flutter pour une clé de couleur
  List<Color> getFlutterColors(String colorKey) {
    return AppColorSchemes.nightlightColors[colorKey] ?? [Colors.white, Colors.grey];
  }

  /// Réinitialise aux paramètres par défaut
  Future<void> resetToDefaults() async {
    debugPrint('🔄 Réinitialisation des paramètres veilleuse');
    
    _settings = const NightlightSettings();
    await _applySettings();
    notifyListeners();
  }

  /// Obtient un résumé des paramètres actuels
  String get settingsSummary {
    if (!_settings.enabled) {
      return 'Veilleuse éteinte';
    }
    
    final colorName = getColorName(_settings.color);
    return '$colorName à ${_settings.intensity}%';
  }

  /// Vérifie si l'extinction est programmée
  bool get hasScheduledOff => _settings.scheduledOff != null;

  /// Obtient le temps restant avant extinction (si programmée)
  Duration? get timeUntilOff {
    if (_settings.scheduledOff == null) return null;
    
    final diff = _settings.scheduledOff!.difference(DateTime.now());
    return diff.isNegative ? null : diff;
  }

  /// Méthode de debug pour afficher l'état
  void debugPrintState() {
    debugPrint('🌙 État NightlightProvider:');
    debugPrint('   Activée: ${_settings.enabled}');
    debugPrint('   Couleur: ${_settings.color} (${getColorName(_settings.color)})');
    debugPrint('   Intensité: ${_settings.intensity}%');
    debugPrint('   Extinction programmée: ${_settings.scheduledOff}');
    debugPrint('   Service caméra: ${_cameraService != null ? 'OK' : 'Non initialisé'}');
  }

  @override
  void dispose() {
    debugPrint('🌙 NightlightProvider dispose');
    super.dispose();
  }
}