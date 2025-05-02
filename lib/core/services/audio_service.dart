import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AudioService {
  final String baseUrl;
  
  AudioService({required this.baseUrl});
  
  Future<List<String>> getAvailableLullabies() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/audio/lullabies'));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<String>();
      } else {
        throw Exception('Failed to get available lullabies');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  Future<void> playLullaby(String name) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/audio/play'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name}),
      );
      
      if (response.statusCode != 200) {
        throw Exception('Failed to play lullaby');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  Future<void> stopLullaby() async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/api/audio/stop'));
      
      if (response.statusCode != 200) {
        throw Exception('Failed to stop lullaby');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  Future<void> adjustVolume(int volume) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/audio/volume'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'volume': volume}),
      );
      
      if (response.statusCode != 200) {
        throw Exception('Failed to adjust volume');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  Future<void> toggleMicrophone(bool enabled) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/audio/microphone'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'enabled': enabled}),
      );
      
      if (response.statusCode != 200) {
        throw Exception('Failed to toggle microphone');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
