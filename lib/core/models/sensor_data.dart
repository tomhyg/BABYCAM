class SensorData {
  final DateTime timestamp;
  final double temperature; // en °C
  final double humidity; // en %
  final double airQuality; // index de qualité
  final double pressure; // en hPa
  final double lightLevel; // en lux
  final double? distance; // en cm (capteur ToF)
  final Map<String, dynamic>? additionalData;

  SensorData({
    required this.timestamp,
    required this.temperature,
    required this.humidity,
    required this.airQuality,
    required this.pressure,
    required this.lightLevel,
    this.distance,
    this.additionalData,
  });

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      timestamp: DateTime.parse(json['timestamp']),
      temperature: json['temperature']?.toDouble() ?? 0.0,
      humidity: json['humidity']?.toDouble() ?? 0.0,
      airQuality: json['airQuality']?.toDouble() ?? 0.0,
      pressure: json['pressure']?.toDouble() ?? 0.0,
      lightLevel: json['lightLevel']?.toDouble() ?? 0.0,
      distance: json['distance']?.toDouble(),
      additionalData: json['additionalData'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'temperature': temperature,
      'humidity': humidity,
      'airQuality': airQuality,
      'pressure': pressure,
      'lightLevel': lightLevel,
      'distance': distance,
      'additionalData': additionalData,
    };
  }
}
