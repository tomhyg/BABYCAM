import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../core/services/audio_service.dart';

class AudioProvider with ChangeNotifier {
  AudioService? _audioService;
  String _baseUrl = '';
  List<String> _availableLullabies = [];
  String? _currentLullaby;
  bool _isPlaying = false;
  int _volume = 50;
  bool _isMicrophoneEnabled = true;

  List<String> get availableLullabies => _availableLullabies;
  String? get currentLullaby => _currentLullaby;
  bool get isPlaying => _isPlaying;
  int get volume => _volume;
  bool get isMicrophoneEnabled => _isMicrophoneEnabled;

  void initialize(String baseUrl) {
    _baseUrl = baseUrl;
    _audioService = AudioService(baseUrl: baseUrl);
    _loadLullabies();
  }

  Future<void> _loadLullabies() async {
    try {
      if (_audioService != null) {
        _availableLullabies = await _audioService!.getAvailableLullabies();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading lullabies: $e');
      // En cas d'erreur, on fournit des berceuses par défaut
      _availableLullabies = [
        'Berceuse 1',
        'Berceuse 2',
        'Berceuse 3',
        'Twinkle Twinkle Little Star',
        'Rock-a-bye Baby',
      ];
      notifyListeners();
    }
  }

  Future<void> playLullaby(String name) async {
    try {
      debugPrint('Playing lullaby: $name');
      
      if (_audioService != null) {
        // Arrêter d'abord toute berceuse en cours
        await stopLullaby();
        
        // Puis démarrer la nouvelle berceuse
        final response = await http.post(
          Uri.parse('$_baseUrl/api/audio/play'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'name': name}),
        );
        
        debugPrint('Play lullaby response: ${response.statusCode} - ${response.body}');
        
        if (response.statusCode == 200) {
          _currentLullaby = name;
          _isPlaying = true;
          notifyListeners();
          debugPrint('Lullaby started successfully: $name');
        } else {
          throw Exception('Failed to play lullaby: ${response.statusCode} - ${response.body}');
        }
      }
    } catch (e) {
      debugPrint('Error playing lullaby: $e');
      rethrow;
    }
  }

  Future<void> stopLullaby() async {
    try {
      debugPrint('Stopping lullaby...');
      
      if (_audioService != null) {
        final response = await http.post(
          Uri.parse('$_baseUrl/api/audio/stop'),
          headers: {'Content-Type': 'application/json'},
        );
        
        debugPrint('Stop lullaby response: ${response.statusCode}');
        
        if (response.statusCode == 200) {
          _isPlaying = false;
          notifyListeners();
          debugPrint('Lullaby stopped successfully');
        } else {
          throw Exception('Failed to stop lullaby: ${response.statusCode}');
        }
      }
    } catch (e) {
      debugPrint('Error stopping lullaby: $e');
      rethrow;
    }
  }

  Future<void> adjustVolume(int newVolume) async {
    try {
      debugPrint('Adjusting volume to: $newVolume');
      
      if (_audioService != null) {
        final response = await http.post(
          Uri.parse('$_baseUrl/api/audio/volume'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'volume': newVolume}),
        );
        
        debugPrint('Adjust volume response: ${response.statusCode}');
        
        if (response.statusCode == 200) {
          _volume = newVolume;
          notifyListeners();
          debugPrint('Volume adjusted successfully');
        } else {
          throw Exception('Failed to adjust volume: ${response.statusCode}');
        }
      }
    } catch (e) {
      debugPrint('Error adjusting volume: $e');
      rethrow;
    }
  }

  Future<void> toggleMicrophone(bool enabled) async {
    try {
      debugPrint('Toggling microphone: $enabled');
      
      if (_audioService != null) {
        final response = await http.post(
          Uri.parse('$_baseUrl/api/audio/microphone'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'enabled': enabled}),
        );
        
        debugPrint('Toggle microphone response: ${response.statusCode}');
        
        if (response.statusCode == 200) {
          _isMicrophoneEnabled = enabled;
          notifyListeners();
          debugPrint('Microphone toggled successfully');
        } else {
          throw Exception('Failed to toggle microphone: ${response.statusCode}');
        }
      }
    } catch (e) {
      debugPrint('Error toggling microphone: $e');
      rethrow;
    }
  }
}