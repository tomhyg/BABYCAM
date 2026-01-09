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
      // Facultatif : Ajouter des données simulées en cas d'erreur
      _currentData = SensorData(
        timestamp: DateTime.now(),
        temperature: 22.5,
        humidity: 45.0,
        airQuality: 92.0,
        pressure: 1013.0,
        lightLevel: 220.0,
      );
      notifyListeners();
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
      // Facultatif : Ajouter des données simulées en cas d'erreur
      final now = DateTime.now();
      _historicalData = List.generate(
        24,
        (index) => SensorData(
          timestamp: now.subtract(Duration(hours: index)),
          temperature: 22.0 + (index % 5),
          humidity: 45.0 + (index % 10),
          airQuality: 90.0 + (index % 8),
          pressure: 1010.0 + (index % 10),
          lightLevel: 200.0 + (index % 50),
        ),
      );
      notifyListeners();
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
          // Optionnel : Gérer l'erreur de stream en créant des données simulées
        },
      );
    }
  }

  // Méthode pour rafraîchir manuellement les données
  Future<void> refreshData() async {
    await _loadCurrentData();
  }

  @override
  void dispose() {
    _dataStreamSubscription?.cancel();
    super.dispose();
  }
}