import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/sensor_data.dart';

class SensorService {
  final String baseUrl;
  
  SensorService({required this.baseUrl});
  
  Future<SensorData> getCurrentData() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/sensors/current'));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return SensorData.fromJson(data);
      } else {
        throw Exception('Failed to get sensor data');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  Future<List<SensorData>> getHistoricalData(DateTime start, DateTime end) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/api/sensors/history?start=${start.toIso8601String()}&end=${end.toIso8601String()}'
        ),
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => SensorData.fromJson(item)).toList();
      } else {
        throw Exception('Failed to get historical sensor data');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  Stream<SensorData> streamSensorData() {
    // Simule un stream de données de capteur
    // Dans une application réelle, cela pourrait être une websocket ou un autre mécanisme
    final controller = StreamController<SensorData>();
    
    Timer.periodic(const Duration(seconds: 10), (timer) async {
      try {
        final data = await getCurrentData();
        controller.add(data);
      } catch (e) {
        controller.addError(e);
      }
    });
    
    return controller.stream;
  }
}
