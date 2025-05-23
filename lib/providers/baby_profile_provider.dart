// lib/providers/baby_profile_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../core/models/baby_profile.dart';

class BabyProfileProvider with ChangeNotifier {
  SharedPreferences? _prefs;
  BabyProfile _profile = const BabyProfile(name: '');
  bool _hasProfile = false;

  BabyProfile get profile => _profile;
  bool get hasProfile => _hasProfile && _profile.name.isNotEmpty;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profileJson = _prefs?.getString('baby_profile');
      if (profileJson != null) {
        final Map<String, dynamic> json = 
            Map<String, dynamic>.from(jsonDecode(profileJson));
        _profile = BabyProfile.fromJson(json);
        _hasProfile = _profile.name.isNotEmpty;
        debugPrint('👶 Profil bébé chargé: ${_profile.name}');
      } else {
        debugPrint('👶 Aucun profil bébé trouvé');
        _hasProfile = false;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Erreur lors du chargement du profil bébé: $e');
      _hasProfile = false;
    }
  }

  Future<void> saveProfile(BabyProfile profile) async {
    try {
      _profile = profile;
      _hasProfile = profile.name.isNotEmpty;
      
      await _prefs?.setString('baby_profile', jsonEncode(profile.toJson()));
      
      debugPrint('💾 Profil bébé sauvegardé: ${profile.name}');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Erreur lors de la sauvegarde du profil bébé: $e');
      rethrow;
    }
  }

  Future<void> updateProfile({
    String? name,
    String? skinTone,
    String? faceShape,
    String? eyeColor,
    String? hairStyle,
    DateTime? birthDate,
    String? notes,
  }) async {
    final updatedProfile = _profile.copyWith(
      name: name,
      skinTone: skinTone,
      faceShape: faceShape,
      eyeColor: eyeColor,
      hairStyle: hairStyle,
      birthDate: birthDate,
      notes: notes,
    );
    
    await saveProfile(updatedProfile);
  }

  Future<void> deleteProfile() async {
    try {
      await _prefs?.remove('baby_profile');
      _profile = const BabyProfile(name: '');
      _hasProfile = false;
      
      debugPrint('🗑️ Profil bébé supprimé');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Erreur lors de la suppression du profil bébé: $e');
      rethrow;
    }
  }

  // Méthodes utilitaires pour l'UI
  String get displayName => _profile.name.isEmpty ? 'Mon bébé' : _profile.name;
  
  String get shortName {
    if (_profile.name.isEmpty) return 'B';
    return _profile.name.substring(0, 1).toUpperCase();
  }

  Color get skinToneColor => 
      BabyAvatarOptions.skinToneColors[_profile.skinTone] ?? 
      BabyAvatarOptions.skinToneColors['light']!;

  Color get eyeColor => 
      BabyAvatarOptions.eyeColorColors[_profile.eyeColor] ?? 
      BabyAvatarOptions.eyeColorColors['blue']!;

  Color get hairColor => 
      BabyAvatarOptions.hairStyleColors[_profile.hairStyle] ?? 
      BabyAvatarOptions.hairStyleColors['blonde']!;

  String get greetingMessage {
    final hour = DateTime.now().hour;
    final name = displayName;
    
    if (hour < 12) {
      return 'Bonjour $name !';
    } else if (hour < 18) {
      return 'Bon après-midi $name !';
    } else {
      return 'Bonsoir $name !';
    }
  }

  String get statusMessage {
    if (!hasProfile) return 'Configuration du profil requise';
    
    final age = _profile.ageDisplay;
    if (age.isNotEmpty) {
      return '$age • Tout va bien';
    } else {
      return 'Tout va bien';
    }
  }

  // Validation du profil
  bool get isProfileComplete {
    return _profile.name.isNotEmpty && 
           _profile.birthDate != null;
  }

  List<String> get missingFields {
    List<String> missing = [];
    if (_profile.name.isEmpty) missing.add('Nom');
    if (_profile.birthDate == null) missing.add('Date de naissance');
    return missing;
  }

  void debugPrintProfile() {
    debugPrint('👶 État BabyProfileProvider:');
    debugPrint('   Nom: ${_profile.name}');
    debugPrint('   Âge: ${_profile.ageDisplay}');
    debugPrint('   Profil complet: $isProfileComplete');
    debugPrint('   A un profil: $hasProfile');
  }
}