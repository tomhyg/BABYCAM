// lib/core/services/ai_analysis_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ai_analysis.dart';
import '../models/sensor_data.dart';

class AIAnalysisService {
  final String baseUrl;
  
  AIAnalysisService({required this.baseUrl});
  
  Future<AIAnalysis> getLatestAnalysis() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/ai/analysis/latest'));
      
      if (response.statusCode == 200) {
        return AIAnalysis.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to get AI analysis');
      }
    } catch (e) {
      // Pour la version de démonstration, renvoyer des données fictives
      return _getMockAnalysis();
    }
  }
  
  Future<List<SleepData>> getSleepHistory(DateTime start, DateTime end) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/api/ai/sleep/history?start=${start.toIso8601String()}&end=${end.toIso8601String()}'
        ),
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => SleepData.fromJson(item)).toList();
      } else {
        throw Exception('Failed to get sleep history');
      }
    } catch (e) {
      // Pour la version de démonstration, renvoyer des données fictives
      return _getMockSleepHistory();
    }
  }
  
  Future<Map<String, dynamic>> analyzeEnvironment(List<SensorData> sensorData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/ai/analyze/environment'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'sensorData': sensorData.map((data) => data.toJson()).toList(),
        }),
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to analyze environment');
      }
    } catch (e) {
      // Pour la version de démonstration, renvoyer des données fictives
      return {
        'temperature': {
          'status': 'good',
          'value': 22.5,
          'recommendation': 'La température est optimale pour le sommeil.'
        },
        'humidity': {
          'status': 'good',
          'value': 45,
          'recommendation': 'Le taux d\'humidité est idéal.'
        },
        'airQuality': {
          'status': 'excellent',
          'value': 92,
          'recommendation': 'Excellente qualité d\'air.'
        },
        'lightLevel': {
          'status': 'warning',
          'value': 215,
          'recommendation': 'Réduire la luminosité pour améliorer le sommeil.'
        }
      };
    }
  }
  
  Future<Map<String, dynamic>> analyzeCry(String audioId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/ai/analyze/cry/$audioId'));
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to analyze cry');
      }
    } catch (e) {
      // Pour la version de démonstration, renvoyer des données fictives
      return {
        'type': 'hunger',
        'confidence': 0.85,
        'alternatives': [
          {'type': 'discomfort', 'confidence': 0.10},
          {'type': 'fatigue', 'confidence': 0.05}
        ],
        'recommendation': 'Le bébé a probablement faim.'
      };
    }
  }
  
  // Méthodes de création de données fictives pour la démo
  AIAnalysis _getMockAnalysis() {
    return AIAnalysis(
      timestamp: DateTime.now(),
      environmentalAnalysis: {
        'temperature': {
          'status': 'good',
          'value': 22.5,
          'trend': '+0.3',
          'recommendation': 'La température est optimale pour le sommeil.'
        },
        'humidity': {
          'status': 'good',
          'value': 45,
          'trend': '-2',
          'recommendation': 'Le taux d\'humidité est idéal.'
        },
        'airQuality': {
          'status': 'excellent',
          'value': 92,
          'trend': '+2',
          'recommendation': 'Excellente qualité d\'air.'
        },
        'lightLevel': {
          'status': 'warning',
          'value': 215,
          'trend': '-30',
          'recommendation': 'Réduire la luminosité pour améliorer le sommeil.'
        }
      },
      sleepAnalysis: {
        'totalSleepTime': '7h20',
        'wakeUps': 3,
        'timeToFallAsleep': '25 min',
        'deepSleepPercentage': 65,
        'lightSleepPercentage': 20,
        'awakePercentage': 15,
        'quality': 'good'
      },
      recommendations: [
        'Réduire la luminosité pendant les périodes de sommeil',
        'Maintenir la température actuelle qui est idéale',
        'Envisager une routine plus apaisante avant le coucher pour réduire le temps d\'endormissement'
      ],
    );
  }
  
  List<SleepData> _getMockSleepHistory() {
    final now = DateTime.now();
    return List.generate(7, (index) {
      final date = now.subtract(Duration(days: index));
      // Générer des données aléatoires mais cohérentes
      final deepSleepPct = 60.0 + (index % 3) * 5;
      final lightSleepPct = 25.0 - (index % 2) * 5;
      final awakePct = 100 - deepSleepPct - lightSleepPct;
      
      return SleepData(
        date: date,
        totalSleepDuration: Duration(hours: 7, minutes: 20 + (index % 4) * 10),
        numberOfWakeUps: 2 + (index % 3),
        timeToFallAsleep: Duration(minutes: 20 + (index % 3) * 5),
        deepSleepPercentage: deepSleepPct,
        lightSleepPercentage: lightSleepPct,
        awakePercentage: awakePct,
        environmentalFactors: {
          'temperature': 22.5 + (index % 3) * 0.3,
          'humidity': 45 + (index % 5),
          'airQuality': 90 + (index % 5),
          'lightLevel': 200 - (index % 4) * 10,
        },
      );
    });
  }
}