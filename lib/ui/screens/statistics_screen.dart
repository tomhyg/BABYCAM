// lib/ui/screens/statistics_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/sensor_provider.dart';
import '../theme/app_colors.dart';


class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedTimeRange = 'Aujourd\'hui';
  final List<String> _timeRanges = ['Aujourd\'hui', 'Semaine', 'Mois'];
  
  // Dummy data for charts (will be replaced with real data from API)
  final List<FlSpot> _temperatureSpots = [
    const FlSpot(0, 22.5),
    const FlSpot(1, 22.8),
    const FlSpot(2, 23.0),
    const FlSpot(3, 22.7),
    const FlSpot(4, 22.3),
    const FlSpot(5, 22.0),
    const FlSpot(6, 21.8),
    const FlSpot(7, 21.5),
    const FlSpot(8, 21.3),
    const FlSpot(9, 22.0),
    const FlSpot(10, 22.5),
    const FlSpot(11, 23.0),
  ];

  final List<FlSpot> _humiditySpots = [
    const FlSpot(0, 45),
    const FlSpot(1, 44),
    const FlSpot(2, 43),
    const FlSpot(3, 45),
    const FlSpot(4, 47),
    const FlSpot(5, 48),
    const FlSpot(6, 47),
    const FlSpot(7, 46),
    const FlSpot(8, 45),
    const FlSpot(9, 44),
    const FlSpot(10, 43),
    const FlSpot(11, 45),
  ];

  final List<FlSpot> _airQualitySpots = [
    const FlSpot(0, 92),
    const FlSpot(1, 91),
    const FlSpot(2, 93),
    const FlSpot(3, 94),
    const FlSpot(4, 92),
    const FlSpot(5, 90),
    const FlSpot(6, 89),
    const FlSpot(7, 91),
    const FlSpot(8, 93),
    const FlSpot(9, 95),
    const FlSpot(10, 94),
    const FlSpot(11, 92),
  ];

  final List<FlSpot> _lightLevelSpots = [
    const FlSpot(0, 215),
    const FlSpot(1, 220),
    const FlSpot(2, 230),
    const FlSpot(3, 225),
    const FlSpot(4, 215),
    const FlSpot(5, 210),
    const FlSpot(6, 200),
    const FlSpot(7, 190),
    const FlSpot(8, 185),
    const FlSpot(9, 180),
    const FlSpot(10, 175),
    const FlSpot(11, 170),
  ];

  // Dummy pie chart data for sleep analysis
  final List<PieChartSectionData> _sleepSections = [
    PieChartSectionData(
      color: AppColors.primary,
      value: 65,
      title: '65%',
      radius: 50,
      titleStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    PieChartSectionData(
      color: AppColors.secondary,
      value: 20,
      title: '20%',
      radius: 50,
      titleStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    PieChartSectionData(
      color: AppColors.babyPink,
      value: 15,
      title: '15%',
      radius: 50,
      titleStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    
    // Load historical data
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistiques'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Température'),
            Tab(text: 'Humidité'),
            Tab(text: 'Qualité d\'air'),
            Tab(text: 'Luminosité'),
            Tab(text: 'Sommeil'),
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
              
              Provider.of<SensorProvider>(context, listen: false).loadHistoricalData(start, now);
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
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTemperatureTab(),
          _buildHumidityTab(),
          _buildAirQualityTab(),
          _buildLightLevelTab(),
          _buildSleepAnalysisTab(),
        ],
      ),
    );
  }

  Widget _buildTemperatureTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCard(
            title: 'Température',
            currentValue: '22.5°C',
            trend: '+0.3°C',
            trendPositive: false,
            icon: Icons.thermostat,
            color: AppColors.temperatureColor,
            description: 'Température moyenne dans la chambre',
          ),
          const SizedBox(height: 24),
          _buildLineChart(
            spots: _temperatureSpots,
            color: AppColors.temperatureColor,
            gradientColors: [
              AppColors.temperatureColor.withOpacity(0.3),
              AppColors.temperatureColor.withOpacity(0.05),
            ],
            minY: 18,
            maxY: 26,
            showDots: true,
            title: 'Évolution de la température',
            yAxisTitle: 'Température (°C)',
          ),
          const SizedBox(height: 24),
          _buildStatisticsTable(
            title: 'Statistiques de température',
            items: [
              {'label': 'Minimale', 'value': '21.3°C'},
              {'label': 'Maximale', 'value': '23.0°C'},
              {'label': 'Moyenne', 'value': '22.2°C'},
              {'label': 'Optimale', 'value': '20-22°C'},
            ],
          ),
          const SizedBox(height: 24),
          _buildInsightsCard(
            title: 'Analyse IA',
            insights: [
              'La température est légèrement au-dessus de la plage optimale pour le sommeil du bébé.',
              'Considérez baisser légèrement le chauffage pour améliorer le confort du sommeil.',
              'Les fluctuations de température sont minimes, ce qui est idéal pour un sommeil stable.',
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHumidityTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCard(
            title: 'Humidité',
            currentValue: '45%',
            trend: '-2%',
            trendPositive: true,
            icon: Icons.water_drop,
            color: AppColors.humidityColor,
            description: 'Taux d\'humidité dans la chambre',
          ),
          const SizedBox(height: 24),
          _buildLineChart(
            spots: _humiditySpots,
            color: AppColors.humidityColor,
            gradientColors: [
              AppColors.humidityColor.withOpacity(0.3),
              AppColors.humidityColor.withOpacity(0.05),
            ],
            minY: 30,
            maxY: 60,
            showDots: true,
            title: 'Évolution de l\'humidité',
            yAxisTitle: 'Humidité (%)',
          ),
          const SizedBox(height: 24),
          _buildStatisticsTable(
            title: 'Statistiques d\'humidité',
            items: [
              {'label': 'Minimale', 'value': '43%'},
              {'label': 'Maximale', 'value': '48%'},
              {'label': 'Moyenne', 'value': '45.2%'},
              {'label': 'Optimale', 'value': '40-60%'},
            ],
          ),
          const SizedBox(height: 24),
          _buildInsightsCard(
            title: 'Analyse IA',
            insights: [
              'Le niveau d\'humidité est dans la plage optimale pour le confort respiratoire.',
              'La stabilité du taux d\'humidité est bénéfique pour éviter les irritations cutanées.',
              'Aucune action n\'est nécessaire, l\'environnement est idéal pour le sommeil.',
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAirQualityTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCard(
            title: 'Qualité d\'air',
            currentValue: '92',
            trend: '+2',
            trendPositive: true,
            icon: Icons.air,
            color: AppColors.airQualityColor,
            description: 'Indice de qualité de l\'air (0-100)',
          ),
          const SizedBox(height: 24),
          _buildLineChart(
            spots: _airQualitySpots,
            color: AppColors.airQualityColor,
            gradientColors: [
              AppColors.airQualityColor.withOpacity(0.3),
              AppColors.airQualityColor.withOpacity(0.05),
            ],
            minY: 80,
            maxY: 100,
            showDots: true,
            title: 'Évolution de la qualité d\'air',
            yAxisTitle: 'Indice',
          ),
          const SizedBox(height: 24),
          _buildStatisticsTable(
            title: 'Statistiques de qualité d\'air',
            items: [
              {'label': 'Minimale', 'value': '89'},
              {'label': 'Maximale', 'value': '95'},
              {'label': 'Moyenne', 'value': '92.1'},
              {'label': 'Optimale', 'value': '>90'},
            ],
          ),
          const SizedBox(height: 24),
          _buildInsightsCard(
            title: 'Analyse IA',
            insights: [
              'La qualité de l\'air est excellente, favorisant un développement respiratoire sain.',
              'Aucun signe de polluants ou d\'allergènes détectés dans l\'environnement.',
              'Continuez à aérer régulièrement la pièce pour maintenir cette qualité optimale.',
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLightLevelTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCard(
            title: 'Luminosité',
            currentValue: '215 lux',
            trend: '-30 lux',
            trendPositive: true,
            icon: Icons.light_mode,
            color: AppColors.lightLevelColor,
            description: 'Niveau de lumière dans la chambre',
          ),
          const SizedBox(height: 24),
          _buildLineChart(
            spots: _lightLevelSpots,
            color: AppColors.lightLevelColor,
            gradientColors: [
              AppColors.lightLevelColor.withOpacity(0.3),
              AppColors.lightLevelColor.withOpacity(0.05),
            ],
            minY: 150,
            maxY: 250,
            showDots: true,
            title: 'Évolution de la luminosité',
            yAxisTitle: 'Lux',
          ),
          const SizedBox(height: 24),
          _buildStatisticsTable(
            title: 'Statistiques de luminosité',
            items: [
              {'label': 'Minimale', 'value': '170 lux'},
              {'label': 'Maximale', 'value': '230 lux'},
              {'label': 'Moyenne', 'value': '201.3 lux'},
              {'label': 'Optimale pour sommeil', 'value': '<10 lux'},
            ],
          ),
          const SizedBox(height: 24),
          _buildInsightsCard(
            title: 'Analyse IA',
            insights: [
              'Le niveau de luminosité est trop élevé pour un sommeil optimal pendant les périodes de repos.',
              'Envisagez d\'installer des rideaux occultants pour réduire la lumière pendant les siestes et la nuit.',
              'Les variations de luminosité peuvent perturber le rythme circadien du bébé.',
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSleepAnalysisTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Analyse du sommeil',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Basé sur les conditions environnementales et les détections de mouvement',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              '7h20',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Temps de sommeil',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              '3',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: AppColors.secondary,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Réveils',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              '25 min',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: AppColors.babyPink,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Temps d\'endormissement',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Phases de sommeil',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        sections: _sleepSections,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildLegendItem('Sommeil profond', AppColors.primary),
                      _buildLegendItem('Sommeil léger', AppColors.secondary),
                      _buildLegendItem('Éveil', AppColors.babyPink),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildInsightsCard(
            title: 'Analyse IA du sommeil',
            insights: [
              'La qualité du sommeil est bonne avec une prédominance de sommeil profond.',
              'Les conditions environnementales sont favorables, mais une réduction de la luminosité pourrait améliorer la durée du sommeil.',
              'Le temps d\'endormissement est légèrement supérieur à la moyenne, essayez une routine plus apaisante avant le coucher.',
              'Les réveils sont peu fréquents et de courte durée, indiquant un sommeil relativement stable.',
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String currentValue,
    required String trend,
    required bool trendPositive,
    required IconData icon,
    required Color color,
    required String description,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currentValue,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    Icon(
                      trendPositive ? Icons.arrow_upward : Icons.arrow_downward,
                      color: trendPositive ? Colors.green : Colors.red,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      trend,
                      style: TextStyle(
                        color: trendPositive ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'depuis hier',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getTitleText(double value) {
    switch (value.toInt()) {
      case 0:
        return '00h';
      case 3:
        return '03h';
      case 6:
        return '06h';
      case 9:
        return '09h';
      case 12:
        return '12h';
      default:
        return '';
    }
  }

  Widget _buildLineChart({
    required List<FlSpot> spots,
    required Color color,
    required List<Color> gradientColors,
    required double minY,
    required double maxY,
    required bool showDots,
    required String title,
    required String yAxisTitle,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 240,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 2,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.withOpacity(0.2),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            _getTitleText(value),
                            style: const TextStyle(
                              color: Color(0xff68737d),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              color: Color(0xff67727d),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                  ),
                  minX: 0,
                  maxX: 12,
                  minY: minY,
                  maxY: maxY,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: color,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: showDots,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: color,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: gradientColors,
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                yAxisTitle,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsTable({
    required String title,
    required List<Map<String, String>> items,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item['label']!,
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    item['value']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightsCard({
    required String title,
    required List<String> insights,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.lightbulb,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...insights.map((insight) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.primary,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(insight),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
  return Row(
    children: [
      Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
      const SizedBox(width: 4),
      Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[700],
        ),
      ),
    ],
  );
}
}
