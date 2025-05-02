import 'package:flutter/material.dart';
import '../core/services/audio_service.dart';

class AudioProvider with ChangeNotifier {
  AudioService? _audioService;
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
      if (_audioService != null) {
        await _audioService!.playLullaby(name);
        _currentLullaby = name;
        _isPlaying = true;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error playing lullaby: $e');
      rethrow;
    }
  }

  Future<void> stopLullaby() async {
    try {
      if (_audioService != null) {
        await _audioService!.stopLullaby();
        _isPlaying = false;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error stopping lullaby: $e');
      rethrow;
    }
  }

  Future<void> adjustVolume(int newVolume) async {
    try {
      if (_audioService != null) {
        await _audioService!.adjustVolume(newVolume);
        _volume = newVolume;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error adjusting volume: $e');
      rethrow;
    }
  }

  Future<void> toggleMicrophone(bool enabled) async {
    try {
      if (_audioService != null) {
        await _audioService!.toggleMicrophone(enabled);
        _isMicrophoneEnabled = enabled;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error toggling microphone: $e');
      rethrow;
    }
  }
}
