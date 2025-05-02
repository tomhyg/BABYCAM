import 'dart:async';
import 'package:flutter/material.dart';
import '../core/models/sensor_data.dart';
import '../core/services/sensor_service.dart';

class SensorProvider with ChangeNotifier {
  SensorService? _sensorService;
  SensorData? _currentData;
  List<SensorData> _historicalData = [];
  StreamSubscription<SensorData>? _dataStreamSubscription;

  SensorData? get currentData => _currentData;
  List<SensorData> get historicalData => _historicalData;

  void initialize(String baseUrl) {
    _sensorService = SensorService(baseUrl: baseUrl);
    _loadCurrentData();
    _startDataStream();
  }

  Future<void> _loadCurrentData() async {
    try {
      if (_sensorService != null) {
        _currentData = await _sensorService!.getCurrentData();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading current sensor data: $e');
    }
  }

  Future<void> loadHistoricalData(DateTime start, DateTime end) async {
    try {
      if (_sensorService != null) {
        _historicalData = await _sensorService!.getHistoricalData(start, end);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading historical sensor data: $e');
    }
  }

  void _startDataStream() {
    if (_sensorService != null) {
      _dataStreamSubscription = _sensorService!.streamSensorData().listen(
        (data) {
          _currentData = data;
          notifyListeners();
        },
        onError: (error) {
          debugPrint('Error in sensor data stream: $error');
        },
      );
    }
  }

  @override
  void dispose() {
    _dataStreamSubscription?.cancel();
    super.dispose();
  }
}
