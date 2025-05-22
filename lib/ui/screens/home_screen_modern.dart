// lib/ui/screens/home_screen_modern.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../theme/app_colors_logo.dart';
import '../../providers/camera_provider.dart';
import '../../providers/sensor_provider.dart';
import '../../providers/audio_provider.dart';
import 'live_view_screen.dart';
import 'events_screen.dart';
import 'sensor_dashboard_screen.dart';
import 'statistics_screen.dart';
import '../widgets/animated_gradient_background.dart';
import '../widgets/sensor_card_modern.dart';

class HomeScreenModern extends StatefulWidget {
  const HomeScreenModern({Key? key}) : super(key: key);

  @override
  _HomeScreenModernState createState() => _HomeScreenModernState();
}

class _HomeScreenModernState extends State<HomeScreenModern> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cameraProvider = Provider.of<CameraProvider>(context);
    final sensorProvider = Provider.of<SensorProvider>(context);
    final audioProvider = Provider.of<AudioProvider>(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // En-tête avec gradient animé
            AnimatedGradientBackground(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Logo et titre
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.baby_changing_station,
                            size: 28,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'BABYCAM AI',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Bonjour ! Tout va bien',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Bouton de notifications
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                            onPressed: () {
                              // Logique pour afficher les notifications
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Affichage du flux vidéo (preview) avec optimisation
                    GestureDetector(
                      onTap: () {
                        // Ouvrir l'écran de vue en direct
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LiveViewScreen()),
                        );
                      },
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.hardEdge, // Important pour éviter le débordement
                        child: Stack(
                          children: [
                            // Flux vidéo avec WebView optimisé
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: cameraProvider.isStreaming
                                ? WebView(
                                    initialUrl: 'about:blank',
                                    javascriptMode: JavascriptMode.unrestricted,
                                    backgroundColor: Colors.black,
                                    onWebViewCreated: (WebViewController controller) {
                                      // Utiliser HTML pour contrôler le format d'affichage
                                      controller.loadHtmlString('''
                                        <!DOCTYPE html>
                                        <html>
                                        <head>
                                          <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                          <style>
                                            body { 
                                              margin: 0; 
                                              padding: 0; 
                                              background-color: black; 
                                              overflow: hidden;
                                              width: 100vw;
                                              height: 100vh;
                                              display: flex;
                                              align-items: center;
                                              justify-content: center;
                                            }
                                            img { 
                                              min-width: 100%; 
                                              min-height: 100%; 
                                              width: auto;
                                              height: auto;
                                              object-fit: cover; /* Pour remplir tout l'espace */
                                            }
                                          </style>
                                        </head>
                                        <body>
                                          <img src="http://192.168.1.95:8080/stream" />
                                        </body>
                                        </html>
                                      ''');
                                    },
                                    onWebResourceError: (error) {
                                      print("Erreur WebView: ${error.description}");
                                    },
                                  )
                                : Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.videocam_off,
                                          size: 48,
                                          color: Colors.white.withOpacity(0.7),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Flux vidéo désactivé',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.7),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            ),
                            
                            // Icône de caméra en haut à droite
                            Positioned(
                              top: 12,
                              right: 12,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      cameraProvider.isStreaming ? Icons.videocam : Icons.videocam_off,
                                      color: cameraProvider.isStreaming ? Colors.green : Colors.red,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      cameraProvider.isStreaming ? 'En direct' : 'Arrêté',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                            // Bouton de lecture/pause en bas à droite
                            Positioned(
                              bottom: 12,
                              right: 12,
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    if (cameraProvider.isStreaming) {
                                      cameraProvider.stopStreaming();
                                    } else {
                                      cameraProvider.startStreaming();
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(30),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: colorScheme.primary,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: colorScheme.primary.withOpacity(0.5),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      cameraProvider.isStreaming ? Icons.pause : Icons.play_arrow,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Contrôles rapides sous le flux vidéo (sans mode nuit)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center, // Centre les boutons
                        children: [
                          _buildQuickActionButton(
                            icon: Icons.photo_camera,
                            label: 'Capture',
                            onTap: () {
                              cameraProvider.captureSnapshot();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Capture d\'écran prise'),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  backgroundColor: colorScheme.primary,
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 24), // Plus d'espace entre les boutons
                                              // Nouveau bouton d'interphone
                          _buildQuickActionButton(
                            icon: cameraProvider.isIntercomActive ? Icons.mic_off : Icons.mic,
                            label: 'Interphone',
                            isActive: cameraProvider.isIntercomActive,
                            onTap: () async {
                              try {
                                await cameraProvider.toggleIntercom();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      cameraProvider.isIntercomActive 
                                          ? 'Interphone activé' 
                                          : 'Interphone désactivé'
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Erreur: $e'),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                          ),
                          const SizedBox(width: 24),
                          

                          
                          _buildQuickActionButton(
                            icon: cameraProvider.isNightLightOn ? Icons.lightbulb : Icons.lightbulb_outline,
                            label: 'Veilleuse',
                            isActive: cameraProvider.isNightLightOn,
                            onTap: () {
                              cameraProvider.toggleNightLight(!cameraProvider.isNightLightOn);
                            },
                          ),
                          const SizedBox(width: 48), // Plus d'espace entre les boutons
                          
                          _buildQuickActionButton(
                            icon: audioProvider.isPlaying ? Icons.music_note : Icons.music_note_outlined,
                            label: 'Berceuse',
                            isActive: audioProvider.isPlaying,
                            onTap: () {
                              if (audioProvider.isPlaying) {
                                audioProvider.stopLullaby();
                              } else if (audioProvider.currentLullaby != null) {
                                audioProvider.playLullaby(audioProvider.currentLullaby!);
                              } else if (audioProvider.availableLullabies.isNotEmpty) {
                                audioProvider.playLullaby(audioProvider.availableLullabies.first);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Contenu principal avec défilement
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    
                    // Section des capteurs environnementaux
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Conditions environnementales',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onBackground,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SensorDashboardScreen()),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Détails',
                                style: TextStyle(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                                color: colorScheme.primary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    // Cartes des capteurs
                    if (sensorProvider.currentData != null)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: colorScheme.outlineVariant,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: SensorCardModern(
                                    title: 'Température',
                                    value: '${sensorProvider.currentData!.temperature.toStringAsFixed(1)}°C',
                                    icon: Icons.thermostat,
                                    color: AppColorsLogo.temperatureColor,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 100,
                                  color: colorScheme.outlineVariant,
                                ),
                                Expanded(
                                  child: SensorCardModern(
                                    title: 'Humidité',
                                    value: '${sensorProvider.currentData!.humidity.toStringAsFixed(0)}%',
                                    icon: Icons.water_drop,
                                    color: AppColorsLogo.humidityColor,
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 1,
                              color: colorScheme.outlineVariant,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: SensorCardModern(
                                    title: 'Qualité d\'air',
                                    value: sensorProvider.currentData!.airQuality.toStringAsFixed(0),
                                    icon: Icons.air,
                                    color: AppColorsLogo.airQualityColor,
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(16),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 100,
                                  color: colorScheme.outlineVariant,
                                ),
                                Expanded(
                                  child: SensorCardModern(
                                    title: 'Luminosité',
                                    value: '${sensorProvider.currentData!.lightLevel.toStringAsFixed(0)} lux',
                                    icon: Icons.light_mode,
                                    color: AppColorsLogo.lightLevelColor,
                                    borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    else
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                    
                    const SizedBox(height: 24),
                    
                    // Section des derniers événements
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Derniers événements',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onBackground,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const EventsScreen()),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Voir tout',
                                style: TextStyle(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                                color: colorScheme.primary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    // Liste des événements
                    if (cameraProvider.events.isNotEmpty)
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: colorScheme.outlineVariant,
                            width: 1,
                          ),
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cameraProvider.events.length > 3 ? 3 : cameraProvider.events.length,
                          separatorBuilder: (context, index) => Divider(
                            height: 1,
                            color: colorScheme.outlineVariant,
                          ),
                          itemBuilder: (context, index) {
                            final event = cameraProvider.events[index];
                            return ListTile(
                              leading: _buildEventIcon(event.type),
                              title: Text(
                                _getEventTitle(event.type),
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: colorScheme.onBackground,
                                ),
                              ),
                              subtitle: Text(
                                '${_formatDate(event.timestamp)} - ${_formatTime(event.timestamp)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              trailing: Icon(
                                Icons.chevron_right,
                                color: colorScheme.onSurfaceVariant,
                              ),
                              onTap: () {
                                // Afficher les détails de l'événement
                              },
                            );
                          },
                        ),
                      )
                    else
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: colorScheme.outlineVariant,
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.event_available,
                                  size: 48,
                                  color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Aucun événement récent',
                                  style: TextStyle(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    
                    const SizedBox(height: 24),
                    
                    // Section statistiques (résumé)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Aperçu du sommeil',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onBackground,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const StatisticsScreen()),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Statistiques',
                                style: TextStyle(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                                color: colorScheme.primary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    // Aperçu du sommeil
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: colorScheme.outlineVariant,
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: _buildSleepStatItem(
                                label: 'Durée',
                                value: '7h20',
                                icon: Icons.bed,
                                color: AppColorsLogo.sleepColor,
                              ),
                            ),
                            Expanded(
                              child: _buildSleepStatItem(
                                label: 'Qualité',
                                value: 'Bonne',
                                icon: Icons.thumb_up,
                                color: AppColorsLogo.success,
                              ),
                            ),
                            Expanded(
                              child: _buildSleepStatItem(
                                label: 'Réveils',
                                value: '3',
                                icon: Icons.notifications_active,
                                color: AppColorsLogo.warning,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isActive 
                  ? Colors.white
                  : Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: isActive
                  ? Theme.of(context).colorScheme.primary
                  : Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEventIcon(String type) {
    Color backgroundColor;
    IconData iconData;
    
    switch (type) {
      case 'cry':
        backgroundColor = Colors.red.shade100;
        iconData = Icons.volume_up;
        break;
      case 'movement':
        backgroundColor = Colors.orange.shade100;
        iconData = Icons.directions_run;
        break;
      case 'face_detected':
        backgroundColor = Colors.blue.shade100;
        iconData = Icons.face;
        break;
      default:
        backgroundColor = Colors.grey.shade100;
        iconData = Icons.event;
    }
    
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        iconData,
        color: backgroundColor.withAlpha(255),
      ),
    );
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
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final eventDate = DateTime(datetime.year, datetime.month, datetime.day);
    
    if (eventDate == today) {
      return 'Aujourd\'hui';
    } else if (eventDate == today.subtract(const Duration(days: 1))) {
      return 'Hier';
    } else {
      return '${datetime.day.toString().padLeft(2, '0')}/${datetime.month.toString().padLeft(2, '0')}/${datetime.year}';
    }
  }
  
  String _formatTime(DateTime datetime) {
    return '${datetime.hour.toString().padLeft(2, '0')}:${datetime.minute.toString().padLeft(2, '0')}';
  }
  
  Widget _buildSleepStatItem({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
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
}