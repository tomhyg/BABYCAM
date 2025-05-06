// lib/ui/screens/sensor_dashboard_modern.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/sensor_provider.dart';
import '../theme/app_colors_logo.dart';
import '../widgets/sensor_card_modern.dart';

class SensorDashboardModern extends StatefulWidget {
  const SensorDashboardModern({Key? key}) : super(key: key);

  @override
  _SensorDashboardModernState createState() => _SensorDashboardModernState();
}

class _SensorDashboardModernState extends State<SensorDashboardModern> with SingleTickerProviderStateMixin {
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Environnement'),
        elevation: 0,
        actions: [
          // Sélecteur de plage temporelle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: colorScheme.outlineVariant,
                  width: 1,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedTimeRange,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: colorScheme.primary,
                  ),
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                  dropdownColor: colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  onChanged: (value) {
                    if (value != null) {
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
                    }
                  },
                  items: _timeRanges.map((range) {
                    return DropdownMenuItem<String>(
                      value: range,
                      child: Text(range),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColorsLogo.secondary,
          labelColor: colorScheme.onBackground,
          unselectedLabelColor: colorScheme.onSurfaceVariant,
          tabs: const [
            Tab(text: 'Tout'),
            Tab(text: 'Température'),
            Tab(text: 'Humidité'),
            Tab(text: 'Air & Lumière'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Vue d'ensemble
          _buildOverviewTab(sensorProvider),
          
          // Température
          _buildTemperatureTab(sensorProvider),
          
          // Humidité
          _buildHumidityTab(sensorProvider),
          
          // Qualité d'air et luminosité
          _buildAirLightTab(sensorProvider),
        ],
      ),
    );
  }
  
  Widget _buildOverviewTab(SensorProvider sensorProvider) {
    if (sensorProvider.currentData == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Carte d'aperçu
          _buildOverviewCard(sensorProvider),
          
          const SizedBox(height: 24),
          
          // Titre de section
          Text(
            'Données en temps réel',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Grille de capteurs
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: [
              _buildSensorCard(
                title: 'Température',
                value: '${sensorProvider.currentData!.temperature.toStringAsFixed(1)}°C',
                icon: Icons.thermostat,
                color: AppColorsLogo.temperatureColor,
                subtitle: _getTemperatureDescription(sensorProvider.currentData!.temperature),
              ),
              _buildSensorCard(
                title: 'Humidité',
                value: '${sensorProvider.currentData!.humidity.toStringAsFixed(0)}%',
                icon: Icons.water_drop,
                color: AppColorsLogo.humidityColor,
                subtitle: _getHumidityDescription(sensorProvider.currentData!.humidity),
              ),
              _buildSensorCard(
                title: 'Qualité d\'air',
                value: sensorProvider.currentData!.airQuality.toStringAsFixed(0),
                icon: Icons.air,
                color: AppColorsLogo.airQualityColor,
                subtitle: _getAirQualityDescription(sensorProvider.currentData!.airQuality),
              ),
              _buildSensorCard(
                title: 'Luminosité',
                value: '${sensorProvider.currentData!.lightLevel.toStringAsFixed(0)} lux',
                icon: Icons.light_mode,
                color: AppColorsLogo.lightLevelColor,
                subtitle: _getLightLevelDescription(sensorProvider.currentData!.lightLevel),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Titre de section
          Text(
            'Évaluation de l\'environnement',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Carte d'évaluation
          _buildAssessmentCard(sensorProvider),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }
  
  Widget _buildOverviewCard(SensorProvider sensorProvider) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Calculer la qualité globale (simplifiée)
    final temperature = sensorProvider.currentData!.temperature;
    final humidity = sensorProvider.currentData!.humidity;
    final airQuality = sensorProvider.currentData!.airQuality;
    
    int qualityScore = 0;
    
    // Température idéale entre 19 et 22°C
    if (temperature >= 19 && temperature <= 22) {
      qualityScore += 3;
    } else if (temperature >= 17 && temperature <= 24) {
      qualityScore += 2;
    } else {
      qualityScore += 1;
    }
    
    // Humidité idéale entre 40 et 60%
    if (humidity >= 40 && humidity <= 60) {
      qualityScore += 3;
    } else if (humidity >= 30 && humidity <= 70) {
      qualityScore += 2;
    } else {
      qualityScore += 1;
    }
    
    // Qualité d'air idéale au-dessus de 80
    if (airQuality >= 80) {
      qualityScore += 3;
    } else if (airQuality >= 60) {
      qualityScore += 2;
    } else {
      qualityScore += 1;
    }
    
    // Calculer le pourcentage de qualité
    final qualityPercent = (qualityScore / 9) * 100;
    
    // Déterminer la couleur et le message
    Color qualityColor;
    String qualityMessage;
    
    if (qualityPercent >= 80) {
      qualityColor = AppColorsLogo.success;
      qualityMessage = 'Excellent pour bébé';
    } else if (qualityPercent >= 60) {
      qualityColor = AppColorsLogo.secondary;
      qualityMessage = 'Bon environnement';
    } else if (qualityPercent >= 40) {
      qualityColor = AppColorsLogo.highlight;
      qualityMessage = 'Environnement acceptable';
    } else {
      qualityColor = AppColorsLogo.warning;
      qualityMessage = 'Améliorations possibles';
    }
    
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: qualityColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    qualityPercent >= 60 ? Icons.check_circle : Icons.info_outline,
                    color: qualityColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'État de la chambre',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      qualityMessage,
                      style: TextStyle(
                        fontSize: 14,
                        color: qualityColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceVariant,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${qualityPercent.round()}%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: qualityColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: qualityPercent / 100,
              backgroundColor: colorScheme.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(qualityColor),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 16),
            Text(
              'Dernière mise à jour: ${_formatDateTime(DateTime.now())}',
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAssessmentCard(SensorProvider sensorProvider) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Générer des recommandations simples
    final recommendations = <String>[];
    
    final temperature = sensorProvider.currentData!.temperature;
    final humidity = sensorProvider.currentData!.humidity;
    final airQuality = sensorProvider.currentData!.airQuality;
    final lightLevel = sensorProvider.currentData!.lightLevel;
    
    if (temperature < 18) {
      recommendations.add('Augmentez légèrement la température de la pièce pour le confort de bébé.');
    } else if (temperature > 24) {
      recommendations.add('Baissez la température pour éviter que bébé n\'ait trop chaud.');
    }
    
    if (humidity < 40) {
      recommendations.add('L\'air est un peu sec, un humidificateur pourrait être bénéfique.');
    } else if (humidity > 60) {
      recommendations.add('Réduisez l\'humidité pour éviter le développement de moisissures.');
    }
    
    if (airQuality < 70) {
      recommendations.add('Aérez la pièce pour améliorer la qualité de l\'air.');
    }
    
    if (lightLevel > 200) {
      recommendations.add('La luminosité est élevée, pensez à tamiser la lumière pendant le sommeil.');
    }
    
    // Si tout va bien
    if (recommendations.isEmpty) {
      recommendations.add('Tous les paramètres sont dans les plages optimales pour bébé. Continuez ainsi !');
    }
    
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: AppColorsLogo.accent,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Recommandations',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...recommendations.map((recommendation) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.arrow_right,
                    color: AppColorsLogo.secondary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      recommendation,
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurface,
                      ),
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
  
  Widget _buildSensorCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    String? subtitle,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildTemperatureTab(SensorProvider sensorProvider) {
    if (sensorProvider.currentData == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    
    // Données pour le graphique (simulées)
    final spots = <FlSpot>[
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
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Grande carte de température
          _buildDetailedSensorCard(
            title: 'Température',
            value: '${sensorProvider.currentData!.temperature.toStringAsFixed(1)}°C',
            icon: Icons.thermostat,
            color: AppColorsLogo.temperatureColor,
            subtitle: _getTemperatureDescription(sensorProvider.currentData!.temperature),
          ),
          
          const SizedBox(height: 24),
          
          // Graphique
          _buildLineChart(
            spots: spots,
            color: AppColorsLogo.temperatureColor,
            title: 'Évolution sur ${_selectedTimeRange.toLowerCase()}',
            minY: 18,
            maxY: 26,
            showDots: true,
          ),
          
          const SizedBox(height: 24),
          
          // Statistiques
          _buildStatisticsCard(
            title: 'Statistiques de température',
            items: [
              {'label': 'Minimum', 'value': '21.3°C'},
              {'label': 'Maximum', 'value': '23.0°C'},
              {'label': 'Moyenne', 'value': '22.2°C'},
              {'label': 'Plage optimale', 'value': '19-22°C'},
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Recommandations
          _buildRecommendationsCard(
            title: 'À propos de la température',
            recommendations: [
              'La température idéale pour la chambre d\'un bébé se situe entre 19 et 22°C.',
              'Des variations de température trop importantes peuvent perturber le sommeil.',
              'Ne surchauffez pas la chambre, vérifiez régulièrement la température de la pièce.',
              'Adaptez les vêtements de nuit en fonction de la température de la chambre.',
            ],
            color: AppColorsLogo.temperatureColor,
          ),
        ],
      ),
    );
  }
  
  Widget _buildHumidityTab(SensorProvider sensorProvider) {
    if (sensorProvider.currentData == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    
    // Données pour le graphique (simulées)
    final spots = <FlSpot>[
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
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Grande carte d'humidité
          _buildDetailedSensorCard(
            title: 'Humidité',
            value: '${sensorProvider.currentData!.humidity.toStringAsFixed(0)}%',
            icon: Icons.water_drop,
            color: AppColorsLogo.humidityColor,
            subtitle: _getHumidityDescription(sensorProvider.currentData!.humidity),
          ),
          
          const SizedBox(height: 24),
          
          // Graphique
          _buildLineChart(
            spots: spots,
            color: AppColorsLogo.humidityColor,
            title: 'Évolution sur ${_selectedTimeRange.toLowerCase()}',
            minY: 30,
            maxY: 70,
            showDots: true,
          ),
          
          const SizedBox(height: 24),
          
          // Statistiques
          _buildStatisticsCard(
            title: 'Statistiques d\'humidité',
            items: [
              {'label': 'Minimum', 'value': '43%'},
              {'label': 'Maximum', 'value': '48%'},
              {'label': 'Moyenne', 'value': '45.2%'},
              {'label': 'Plage optimale', 'value': '40-60%'},
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Recommandations
          _buildRecommendationsCard(
            title: 'À propos de l\'humidité',
            recommendations: [
              'Un taux d\'humidité entre 40% et 60% est idéal pour la santé respiratoire de bébé.',
              'Un air trop sec peut irriter les voies respiratoires et assécher la peau.',
              'Une humidité excessive favorise le développement de moisissures et d\'acariens.',
              'Utilisez un humidificateur ou un déshumidificateur si nécessaire pour maintenir un taux optimal.',
            ],
            color: AppColorsLogo.humidityColor,
          ),
        ],
      ),
    );
  }
  
  Widget _buildAirLightTab(SensorProvider sensorProvider) {
    if (sensorProvider.currentData == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cartes de capteurs
          Row(
            children: [
              Expanded(
                child: _buildDetailedSensorCard(
                  title: 'Qualité d\'air',
                  value: sensorProvider.currentData!.airQuality.toStringAsFixed(0),
                  icon: Icons.air,
                  color: AppColorsLogo.airQualityColor,
                  subtitle: _getAirQualityDescription(sensorProvider.currentData!.airQuality),
                  compact: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDetailedSensorCard(
                  title: 'Luminosité',
                  value: '${sensorProvider.currentData!.lightLevel.toStringAsFixed(0)} lux',
                  icon: Icons.light_mode,
                  color: AppColorsLogo.lightLevelColor,
                  subtitle: _getLightLevelDescription(sensorProvider.currentData!.lightLevel),
                  compact: true,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Graphiques
          _buildDualLineChart(
            title: 'Évolution sur ${_selectedTimeRange.toLowerCase()}',
            airQualitySpots: [
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
            ],
            lightLevelSpots: [
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
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Statistiques
          _buildStatisticsCard(
            title: 'Statistiques de qualité d\'air',
            items: [
              {'label': 'Minimum', 'value': '89'},
              {'label': 'Maximum', 'value': '95'},
              {'label': 'Moyenne', 'value': '92.1'},
              {'label': 'Seuil de qualité', 'value': '>80'},
            ],
          ),
          
          const SizedBox(height: 16),
          
          _buildStatisticsCard(
            title: 'Statistiques de luminosité',
            items: [
              {'label': 'Minimum', 'value': '170 lux'},
              {'label': 'Maximum', 'value': '230 lux'},
              {'label': 'Moyenne', 'value': '201.3 lux'},
              {'label': 'Idéal sommeil', 'value': '<10 lux'},
              {'label': 'Idéal éveil', 'value': '200-300 lux'},
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Recommandations
          _buildRecommendationsCard(
            title: 'Qualité de l\'environnement',
            recommendations: [
              'Veillez à bien aérer la chambre chaque jour pour renouveler l\'air.',
              'Pendant le sommeil, la chambre doit être sombre (<10 lux) pour favoriser la production de mélatonine.',
              'Une lumière douce (200-300 lux) est idéale pendant les périodes d\'éveil et de jeu.',
              'Maintenez une bonne qualité d\'air en évitant les produits ménagers agressifs ou parfumés.',
            ],
            color: AppColorsLogo.accent,
          ),
        ],
      ),
    );
  }
  
  Widget _buildDetailedSensorCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    String? subtitle,
    bool compact = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.all(compact ? 12.0 : 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: compact ? 20 : 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: compact ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            SizedBox(height: compact ? 12 : 20),
            Text(
              value,
              style: TextStyle(
                fontSize: compact ? 28 : 36,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: compact ? 12 : 14,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildLineChart({
    required List<FlSpot> spots,
    required Color color,
    required String title,
    required double minY,
    required double maxY,
    bool showDots = true,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 240,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: 2,
                    verticalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: colorScheme.outlineVariant,
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: colorScheme.outlineVariant,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 2,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          // Formater les heures
                          final hour = value.toInt() * 2;
                          final hourStr = hour.toString().padLeft(2, '0') + 'h';
                          
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              hourStr,
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: (maxY - minY) / 4,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          );
                        },
                        reservedSize: 40,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      bottom: BorderSide(
                        color: colorScheme.outlineVariant,
                        width: 1,
                      ),
                      left: BorderSide(
                        color: colorScheme.outlineVariant,
                        width: 1,
                      ),
                      right: BorderSide.none,
                      top: BorderSide.none,
                    ),
                  ),
                  minX: 0,
                  maxX: 11,
                  minY: minY,
                  maxY: maxY,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: [
                          color.withOpacity(0.8),
                          color,
                        ],
                      ),
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
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            color.withOpacity(0.3),
                            color.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDualLineChart({
    required String title,
    required List<FlSpot> airQualitySpots,
    required List<FlSpot> lightLevelSpots,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Couleurs
    final airQualityColor = AppColorsLogo.airQualityColor;
    final lightLevelColor = AppColorsLogo.lightLevelColor;
    
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(
                  color: airQualityColor,
                  label: 'Qualité d\'air',
                ),
                const SizedBox(width: 24),
                _buildLegendItem(
                  color: lightLevelColor,
                  label: 'Luminosité',
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 240,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: 20,
                    verticalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: colorScheme.outlineVariant,
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: colorScheme.outlineVariant,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 2,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          // Formater les heures
                          final hour = value.toInt() * 2;
                          final hourStr = hour.toString().padLeft(2, '0') + 'h';
                          
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              hourStr,
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 20,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          );
                        },
                        reservedSize: 40,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      bottom: BorderSide(
                        color: colorScheme.outlineVariant,
                        width: 1,
                      ),
                      left: BorderSide(
                        color: colorScheme.outlineVariant,
                        width: 1,
                      ),
                      right: BorderSide.none,
                      top: BorderSide.none,
                    ),
                  ),
                  minX: 0,
                  maxX: 11,
                  minY: 80,
                  maxY: 240,
                  lineBarsData: [
                    // Qualité d'air
                    LineChartBarData(
                      spots: airQualitySpots,
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: [
                          airQualityColor.withOpacity(0.8),
                          airQualityColor,
                        ],
                      ),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: airQualityColor,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: false,
                      ),
                    ),
                    
                    // Luminosité
                    LineChartBarData(
                      spots: lightLevelSpots,
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: [
                          lightLevelColor.withOpacity(0.8),
                          lightLevelColor,
                        ],
                      ),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: lightLevelColor,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: false,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildLegendItem({
    required Color color,
    required String label,
  }) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
  
  Widget _buildStatisticsCard({
    required String title,
    required List<Map<String, String>> items,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
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
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    item['value']!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
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
  
  Widget _buildRecommendationsCard({
    required String title,
    required List<String> recommendations,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: color,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...recommendations.map((recommendation) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.arrow_right,
                    color: color,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      recommendation,
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurface,
                      ),
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
  
  String _formatDateTime(DateTime dateTime) {
    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }
  
  String _getTemperatureDescription(double temperature) {
    if (temperature < 16) {
      return 'Trop frais pour bébé';
    } else if (temperature >= 16 && temperature < 19) {
      return 'Un peu frais';
    } else if (temperature >= 19 && temperature <= 22) {
      return 'Idéal pour bébé';
    } else if (temperature > 22 && temperature <= 24) {
      return 'Légèrement chaud';
    } else {
      return 'Trop chaud pour bébé';
    }
  }
  
  String _getHumidityDescription(double humidity) {
    if (humidity < 30) {
      return 'Air très sec';
    } else if (humidity >= 30 && humidity < 40) {
      return 'Air un peu sec';
    } else if (humidity >= 40 && humidity <= 60) {
      return 'Humidité idéale';
    } else if (humidity > 60 && humidity <= 70) {
      return 'Légèrement humide';
    } else {
      return 'Trop humide';
    }
  }
  
  String _getAirQualityDescription(double airQuality) {
    if (airQuality >= 90) {
      return 'Excellente qualité';
    } else if (airQuality >= 70 && airQuality < 90) {
      return 'Bonne qualité';
    } else if (airQuality >= 50 && airQuality < 70) {
      return 'Qualité moyenne';
    } else {
      return 'Qualité insuffisante';
    }
  }
  
  String _getLightLevelDescription(double lightLevel) {
    if (lightLevel < 10) {
      return 'Obscurité (idéal sommeil)';
    } else if (lightLevel >= 10 && lightLevel < 50) {
      return 'Très faible luminosité';
    } else if (lightLevel >= 50 && lightLevel < 200) {
      return 'Faible luminosité';
    } else if (lightLevel >= 200 && lightLevel < 400) {
      return 'Luminosité confortable';
    } else {
      return 'Luminosité élevée';
    }
  }
}