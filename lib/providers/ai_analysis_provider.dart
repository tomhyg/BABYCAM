// lib/providers/ai_analysis_provider.dart

import 'package:flutter/material.dart';
import '../core/models/ai_analysis.dart';
import '../core/services/ai_analysis_service.dart';

class AIAnalysisProvider with ChangeNotifier {
  AIAnalysisService? _aiAnalysisService;
  AIAnalysis? _latestAnalysis;
  List<SleepData> _sleepHistory = [];
  bool _isLoading = false;

  AIAnalysis? get latestAnalysis => _latestAnalysis;
  List<SleepData> get sleepHistory => _sleepHistory;
  bool get isLoading => _isLoading;

  void initialize(String baseUrl) {
    _aiAnalysisService = AIAnalysisService(baseUrl: baseUrl);
    _loadLatestAnalysis();
    _loadSleepHistory();
  }

  Future<void> _loadLatestAnalysis() async {
    if (_aiAnalysisService == null) return;
    
    _isLoading = true;
    notifyListeners();
    
    try {
      _latestAnalysis = await _aiAnalysisService!.getLatestAnalysis();
    } catch (e) {
      debugPrint('Error loading AI analysis: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadSleepHistory() async {
    if (_aiAnalysisService == null) return;
    
    try {
      final now = DateTime.now();
      final oneWeekAgo = now.subtract(const Duration(days: 7));
      _sleepHistory = await _aiAnalysisService!.getSleepHistory(oneWeekAgo, now);
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading sleep history: $e');
    }
  }

  Future<void> refreshAnalysis() async {
    await _loadLatestAnalysis();
    await _loadSleepHistory();
  }

  Future<Map<String, dynamic>> analyzeCry(String audioId) async {
    if (_aiAnalysisService == null) {
      return {
        'error': 'AI analysis service not initialized'
      };
    }
    
    try {
      return await _aiAnalysisService!.analyzeCry(audioId);
    } catch (e) {
      debugPrint('Error analyzing cry: $e');
      return {
        'error': e.toString()
      };
    }
  }
}