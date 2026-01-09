// lib/core/models/ai_analysis.dart

class AIAnalysis {
  final DateTime timestamp;
  final Map<String, dynamic> environmentalAnalysis;
  final Map<String, dynamic> sleepAnalysis;
  final List<String> recommendations;

  AIAnalysis({
    required this.timestamp,
    required this.environmentalAnalysis,
    required this.sleepAnalysis,
    required this.recommendations,
  });

  factory AIAnalysis.fromJson(Map<String, dynamic> json) {
    return AIAnalysis(
      timestamp: DateTime.parse(json['timestamp']),
      environmentalAnalysis: json['environmentalAnalysis'],
      sleepAnalysis: json['sleepAnalysis'],
      recommendations: List<String>.from(json['recommendations']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'environmentalAnalysis': environmentalAnalysis,
      'sleepAnalysis': sleepAnalysis,
      'recommendations': recommendations,
    };
  }
}

class SleepData {
  final DateTime date;
  final Duration totalSleepDuration;
  final int numberOfWakeUps;
  final Duration timeToFallAsleep;
  final double deepSleepPercentage;
  final double lightSleepPercentage;
  final double awakePercentage;
  final Map<String, dynamic> environmentalFactors;

  SleepData({
    required this.date,
    required this.totalSleepDuration,
    required this.numberOfWakeUps,
    required this.timeToFallAsleep,
    required this.deepSleepPercentage,
    required this.lightSleepPercentage,
    required this.awakePercentage,
    required this.environmentalFactors,
  });

  factory SleepData.fromJson(Map<String, dynamic> json) {
    return SleepData(
      date: DateTime.parse(json['date']),
      totalSleepDuration: Duration(minutes: json['totalSleepMinutes']),
      numberOfWakeUps: json['numberOfWakeUps'],
      timeToFallAsleep: Duration(minutes: json['timeToFallAsleepMinutes']),
      deepSleepPercentage: json['deepSleepPercentage'],
      lightSleepPercentage: json['lightSleepPercentage'],
      awakePercentage: json['awakePercentage'],
      environmentalFactors: json['environmentalFactors'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'totalSleepMinutes': totalSleepDuration.inMinutes,
      'numberOfWakeUps': numberOfWakeUps,
      'timeToFallAsleepMinutes': timeToFallAsleep.inMinutes,
      'deepSleepPercentage': deepSleepPercentage,
      'lightSleepPercentage': lightSleepPercentage,
      'awakePercentage': awakePercentage,
      'environmentalFactors': environmentalFactors,
    };
  }
}