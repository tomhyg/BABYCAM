import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'live_view_screen.dart';
import 'events_screen.dart';
import 'sensor_dashboard_screen.dart';
import 'settings_screen.dart';
import '../../providers/camera_provider.dart';
import '../../providers/sensor_provider.dart';
import '../widgets/sensor_card_widget.dart';
import '../theme/app_text_styles.dart';
import 'statistics_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  
  final List<Widget> _screens = [
    const HomeContent(),
    const LiveViewScreen(),
    const EventsScreen(),
    const SensorDashboardScreen(),
    const SettingsScreen(),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.videocam),
            label: 'Caméra',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Événements',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sensors),
            label: 'Capteurs',
          ),
          BottomNavigationBarItem(  
            icon: Icon(Icons.bar_chart),
            label: 'Statistiques',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Paramètres',
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cameraProvider = Provider.of<CameraProvider>(context);
    final sensorProvider = Provider.of<SensorProvider>(context);
    
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'BABYCAM AI',
              style: AppTextStyles.headline1,
            ),
            const SizedBox(height: 24),
            // Dernière image de la caméra
            Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => const LiveViewScreen()),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: cameraProvider.isStreaming
                          ? Image.network(
                              cameraProvider.streamUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Center(
                                child: Icon(Icons.error_outline, size: 48),
                              ),
                            )
                          : const Center(
                              child: Icon(Icons.videocam_off, size: 48),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Vue en direct',
                              style: AppTextStyles.subtitle1,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              if (cameraProvider.isStreaming) {
                                cameraProvider.stopStreaming();
                              } else {
                                cameraProvider.startStreaming();
                              }
                            },
                            icon: Icon(
                              cameraProvider.isStreaming ? Icons.pause : Icons.play_arrow,
                            ),
                            label: Text(
                              cameraProvider.isStreaming ? 'Pause' : 'Démarrer',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Données des capteurs
            const Text(
              'Conditions environnementales',
              style: AppTextStyles.headline3,
            ),
            const SizedBox(height: 16),
            if (sensorProvider.currentData != null)
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  SensorCardWidget(
                    title: 'Température',
                    value: '${sensorProvider.currentData!.temperature.toStringAsFixed(1)}°C',
                    icon: Icons.thermostat,
                    color: Colors.orange,
                  ),
                  SensorCardWidget(
                    title: 'Humidité',
                    value: '${sensorProvider.currentData!.humidity.toStringAsFixed(0)}%',
                    icon: Icons.water_drop,
                    color: Colors.blue,
                  ),
                  SensorCardWidget(
                    title: 'Qualité d\'air',
                    value: sensorProvider.currentData!.airQuality.toStringAsFixed(0),
                    icon: Icons.air,
                    color: Colors.green,
                  ),
                  SensorCardWidget(
                    title: 'Luminosité',
                    value: '${sensorProvider.currentData!.lightLevel.toStringAsFixed(0)} lux',
                    icon: Icons.light_mode,
                    color: Colors.amber,
                  ),
                ],
              ),
            if (sensorProvider.currentData == null)
              const Center(
                child: CircularProgressIndicator(),
              ),
            const SizedBox(height: 24),
            // Derniers événements
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Derniers événements',
                  style: AppTextStyles.headline3,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EventsScreen()),
                    );
                  },
                  child: const Text('Voir tout'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...cameraProvider.events.take(3).map((event) => ListTile(
              leading: _getEventIcon(event.type),
              title: Text(_getEventTitle(event.type)),
              subtitle: Text(
                '${_formatDate(event.timestamp)} - ${_formatTime(event.timestamp)}',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Afficher les détails de l'événement
              },
            )),
            if (cameraProvider.events.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text('Aucun événement récent'),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  Icon _getEventIcon(String type) {
    switch (type) {
      case 'cry':
        return const Icon(Icons.volume_up, color: Colors.red);
      case 'movement':
        return const Icon(Icons.directions_run, color: Colors.orange);
      case 'face_detected':
        return const Icon(Icons.face, color: Colors.blue);
      default:
        return const Icon(Icons.event, color: Colors.grey);
    }
  }
  
  String _getEventTitle(String type) {
    switch (type) {
      case 'cry':
        return 'Pleurs détectés';
      case 'movement':
        return 'Mouvement détecté';
      case 'face_detected':
        return 'Visage détecté';
      default:
        return 'Événement inconnu';
    }
  }
  
  String _formatDate(DateTime datetime) {
    return '${datetime.day.toString().padLeft(2, '0')}/${datetime.month.toString().padLeft(2, '0')}/${datetime.year}';
  }
  
  String _formatTime(DateTime datetime) {
    return '${datetime.hour.toString().padLeft(2, '0')}:${datetime.minute.toString().padLeft(2, '0')}';
  }
}
