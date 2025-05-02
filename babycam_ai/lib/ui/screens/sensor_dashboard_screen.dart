import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/sensor_provider.dart';
import '../theme/app_colors.dart';

class SensorDashboardScreen extends StatefulWidget {
  const SensorDashboardScreen({Key? key}) : super(key: key);

  @override
  _SensorDashboardScreenState createState() => _SensorDashboardScreenState();
}

class _SensorDashboardScreenState extends State<SensorDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedTimeRange = 'Aujourd\'hui';
  final List<String> _timeRanges = ['Aujourd\'hui', 'Semaine', 'Mois'];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    
    // Charger les données historiques
    final sensorProvider = Provider.of<SensorProvider>(context, listen: false);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    sensorProvider.loadHistoricalData(today, now);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final sensorProvider = Provider.of<SensorProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Capteurs'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Température'),
            Tab(text: 'Humidité'),
            Tab(text: 'Qualité d\'air'),
            Tab(text: 'Luminosité'),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedTimeRange = value;
              });
              
              // Mettre à jour les données selon la plage sélectionnée
              final now = DateTime.now();
              late DateTime start;
              
              switch (_selectedTimeRange) {
                case 'Aujourd\'hui':
                  start = DateTime(now.year, now.month, now.day);
                  break;
                case 'Semaine':
                  start = now.subtract(const Duration(days: 7));
                  break;
                case 'Mois':
                  start = DateTime(now.year, now.month - 1, now.day);
                  break;
              }
              
              sensorProvider.loadHistoricalData(start, now);
            },
            itemBuilder: (context) {
              return _timeRanges.map((range) {
                return PopupMenuItem<String>(
                  value: range,
                  child: Text(range),
                );
              }).toList();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Text(_selectedTimeRange),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ],
      ),
      body: sensorProvider.currentData == null
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                // Température - Affichage simplifiée sans graphiques
                _buildSensorDisplay(
                  'Température',
                  '${sensorProvider.currentData?.temperature.toStringAsFixed(1)}°C',
                  Icons.thermostat,
                  AppColors.temperatureColor,
                ),
                // Humidité
                _buildSensorDisplay(
                  'Humidité',
                  '${sensorProvider.currentData?.humidity.toStringAsFixed(0)}%',
                  Icons.water_drop,
                  AppColors.humidityColor,
                ),
                // Qualité d'air
                _buildSensorDisplay(
                  'Qualité d\'air',
                  '${sensorProvider.currentData?.airQuality.toStringAsFixed(0)}',
                  Icons.air,
                  AppColors.airQualityColor,
                ),
                // Luminosité
                _buildSensorDisplay(
                  'Luminosité',
                  '${sensorProvider.currentData?.lightLevel.toStringAsFixed(0)} lux',
                  Icons.light_mode,
                  AppColors.lightLevelColor,
                ),
              ],
            ),
    );
  }
  
  Widget _buildSensorDisplay(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: color,
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w300,
              color: color,
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Les graphiques détaillés seront disponibles dans la prochaine version',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
