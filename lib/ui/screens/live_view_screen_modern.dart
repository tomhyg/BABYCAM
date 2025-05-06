// lib/ui/screens/live_view_screen_modern.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../../providers/camera_provider.dart';
import '../../providers/audio_provider.dart';
import '../theme/app_colors_logo.dart';
import '../widgets/babycam_logo.dart';

class LiveViewScreenModern extends StatefulWidget {
  const LiveViewScreenModern({Key? key}) : super(key: key);

  @override
  _LiveViewScreenModernState createState() => _LiveViewScreenModernState();
}

class _LiveViewScreenModernState extends State<LiveViewScreenModern> with TickerProviderStateMixin {
  late TabController _tabController;
  bool _showControls = true;
  bool _isPictureInPictureEnabled = false;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Démarre automatiquement le streaming au chargement de l'écran
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cameraProvider = Provider.of<CameraProvider>(context, listen: false);
      if (!cameraProvider.isStreaming) {
        cameraProvider.startStreaming();
      }
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cameraProvider = Provider.of<CameraProvider>(context);
    final audioProvider = Provider.of<AudioProvider>(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Débogage
    print("Stream URL: ${cameraProvider.streamUrl}");
    print("Is Streaming: ${cameraProvider.isStreaming}");
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _showControls ? AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: BackButton(
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text(
              'Vision en direct',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.photo_camera,
                  color: Colors.white,
                ),
                onPressed: () {
                  cameraProvider.captureSnapshot();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Capture d\'écran prise'),
                      backgroundColor: AppColorsLogo.secondary,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(
                  _isPictureInPictureEnabled ? Icons.picture_in_picture_alt : Icons.picture_in_picture,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _isPictureInPictureEnabled = !_isPictureInPictureEnabled;
                  });
                },
              ),
            ],
            flexibleSpace: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Colors.black.withOpacity(0.2),
                ),
              ),
            ),
          ) : null,
        ),
      ),
      body: Stack(
        children: [
          // Fond noir
          Container(
            color: Colors.black,
          ),
          
          // Flux vidéo
          GestureDetector(
            onTap: () {
              setState(() {
                _showControls = !_showControls;
              });
            },
            child: Center(
              child: cameraProvider.isStreaming
                ? Image.network(
                    // Utiliser exactement la même URL que sur la page d'accueil
                    "http://192.168.1.95:8080/stream",
                    fit: BoxFit.contain,
                    gaplessPlayback: true,
                    // Utiliser les mêmes en-têtes qu'à la page d'accueil
                    headers: const {
                      'Connection': 'keep-alive', 
                      'Keep-Alive': 'timeout=5, max=1000',
                      'Cache-Control': 'no-cache, no-store',
                      'Pragma': 'no-cache'
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          // Logo pulsant en attendant le chargement
                          const BabycamLogo(
                            size: 100,
                            animate: true,
                          ),
                          const SizedBox(height: 20),
                          CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                : null,
                            color: AppColorsLogo.secondary,
                          ),
                        ],
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      // Amélioré pour afficher l'erreur et faciliter le débogage
                      print("Erreur de chargement du flux: $error");
                      print("Stack trace: $stackTrace");
                      return _buildErrorDisplay();
                    },
                  )
                : _buildCameraOffDisplay(),
            ),
          ),
          
          // Contrôles du bas
          if (_showControls)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: SafeArea(
                      top: false,
                      child: Column(
                        mainAxisSize: MainAxisSize.min, // Limite la taille de la colonne
                        children: [
                          // Indicateurs d'état
                          Padding(
                            padding: const EdgeInsets.only(top: 16, left: 20, right: 20),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _buildStatusIndicator(
                                    icon: Icons.wifi,
                                    label: 'Connecté',
                                    isActive: cameraProvider.isStreaming,
                                  ),
                                  const SizedBox(width: 24),
                                  _buildStatusIndicator(
                                    icon: cameraProvider.settings.nightVisionEnabled
                                        ? Icons.nightlight_round
                                        : Icons.wb_sunny,
                                    label: cameraProvider.settings.nightVisionEnabled
                                        ? 'Vision nocturne'
                                        : 'Mode jour',
                                    isActive: true,
                                  ),
                                  const SizedBox(width: 24),
                                  _buildStatusIndicator(
                                    icon: Icons.light_mode,
                                    label: 'Veilleuse',
                                    isActive: cameraProvider.isNightLightOn,
                                  ),
                                  const SizedBox(width: 24),
                                  _buildStatusIndicator(
                                    icon: Icons.music_note,
                                    label: 'Berceuse',
                                    isActive: audioProvider.isPlaying,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          // Onglets
                          TabBar(
                            controller: _tabController,
                            indicatorColor: AppColorsLogo.secondary,
                            indicatorSize: TabBarIndicatorSize.label,
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.white.withOpacity(0.7),
                            tabs: const [
                              Tab(text: 'Contrôles'),
                              Tab(text: 'Réglages'),
                            ],
                          ),
                          
                          // Contenu des onglets - utilisation de ConstrainedBox pour limiter la hauteur
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.height * 0.35, // Limite à 35% de la hauteur de l'écran
                            ),
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                // Onglet contrôles
                                SingleChildScrollView(
                                  child: _buildControlsTab(
                                    cameraProvider: cameraProvider,
                                    audioProvider: audioProvider,
                                  ),
                                ),
                                
                                // Onglet réglages
                                SingleChildScrollView(
                                  child: _buildSettingsTab(
                                    cameraProvider: cameraProvider,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
          // Bouton play/pause flottant
          if (_showControls)
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.35 + 20, // Position ajustée dynamiquement
              right: 20,
              child: FloatingActionButton(
                backgroundColor: cameraProvider.isStreaming
                    ? AppColorsLogo.error
                    : AppColorsLogo.secondary,
                elevation: 8,
                child: Icon(
                  cameraProvider.isStreaming ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (cameraProvider.isStreaming) {
                    cameraProvider.stopStreaming();
                  } else {
                    cameraProvider.startStreaming();
                  }
                },
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _buildErrorDisplay() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: AppColorsLogo.error,
              ),
              const SizedBox(height: 16),
              const Text(
                'Impossible de charger le flux vidéo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Vérifiez votre connexion et réessayez',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColorsLogo.secondary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  setState(() {});
                  Provider.of<CameraProvider>(context, listen: false).startStreaming();
                },
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildCameraOffDisplay() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              const BabycamLogo(
                size: 80,
                animate: true,
              ),
              const SizedBox(height: 24),
              const Text(
                'Flux vidéo désactivé',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Appuyez sur le bouton Play pour démarrer la caméra',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColorsLogo.secondary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Provider.of<CameraProvider>(context, listen: false).startStreaming();
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Démarrer'),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildStatusIndicator({
    required IconData icon,
    required String label,
    required bool isActive,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isActive
                ? AppColorsLogo.secondary.withOpacity(0.7)
                : Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive
                ? Colors.white
                : Colors.white.withOpacity(0.7),
            fontSize: 10,
          ),
        ),
      ],
    );
  }
  
  Widget _buildControlsTab({
    required CameraProvider cameraProvider,
    required AudioProvider audioProvider,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Contrôle de la veilleuse
          Text(
            'Veilleuse',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Switch(
                value: cameraProvider.isNightLightOn,
                onChanged: (value) {
                  cameraProvider.toggleNightLight(value);
                },
                activeColor: AppColorsLogo.secondary,
                activeTrackColor: AppColorsLogo.secondary.withOpacity(0.5),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Slider(
                  value: cameraProvider.settings.nightLightBrightness.toDouble(),
                  min: 0,
                  max: 100,
                  divisions: 10,
                  activeColor: AppColorsLogo.secondary,
                  inactiveColor: Colors.white.withOpacity(0.2),
                  onChanged: cameraProvider.isNightLightOn
                      ? (value) {
                          cameraProvider.toggleNightLight(true, value.toInt());
                        }
                      : null,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.brightness_high,
                color: cameraProvider.isNightLightOn
                    ? Colors.white
                    : Colors.white.withOpacity(0.5),
                size: 20,
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Contrôle des berceuses
          Text(
            'Berceuses',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: audioProvider.isPlaying
                      ? AppColorsLogo.error
                      : AppColorsLogo.secondary,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(12),
                ),
                onPressed: () {
                  if (audioProvider.isPlaying) {
                    audioProvider.stopLullaby();
                  } else if (audioProvider.currentLullaby != null) {
                    audioProvider.playLullaby(audioProvider.currentLullaby!);
                  } else if (audioProvider.availableLullabies.isNotEmpty) {
                    audioProvider.playLullaby(audioProvider.availableLullabies.first);
                  }
                },
                child: Icon(
                  audioProvider.isPlaying ? Icons.stop : Icons.play_arrow,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  ),
                  dropdownColor: AppColorsLogo.surfaceDark,
                  value: audioProvider.currentLullaby,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white,
                  ),
                  hint: Text(
                    'Sélectionner une berceuse',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  items: audioProvider.availableLullabies.map((lullaby) {
                    return DropdownMenuItem<String>(
                      value: lullaby,
                      child: Text(lullaby),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      audioProvider.playLullaby(value);
                    }
                  },
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Contrôle du volume
          Row(
            children: [
              Icon(
                Icons.volume_down,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Slider(
                  value: audioProvider.volume.toDouble(),
                  min: 0,
                  max: 100,
                  divisions: 10,
                  activeColor: AppColorsLogo.secondary,
                  inactiveColor: Colors.white.withOpacity(0.2),
                  onChanged: (value) {
                    audioProvider.adjustVolume(value.toInt());
                  },
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.volume_up,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildSettingsTab({
    required CameraProvider cameraProvider,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Contrôle de la vision nocturne
          Text(
            'Vision nocturne',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Switch(
                value: cameraProvider.settings.nightVisionEnabled,
                onChanged: (value) {
                  final newSettings = cameraProvider.settings.copyWith(
                    nightVisionEnabled: value,
                  );
                  cameraProvider.updateSettings(newSettings);
                },
                activeColor: AppColorsLogo.secondary,
                activeTrackColor: AppColorsLogo.secondary.withOpacity(0.5),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  cameraProvider.settings.nightVisionEnabled
                      ? 'Activée (pour surveillance dans le noir)'
                      : 'Désactivée (pour lumière ambiante)',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Contrôle de la qualité d'image
          Text(
            'Qualité d\'image',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.image_aspect_ratio,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  ),
                  dropdownColor: AppColorsLogo.surfaceDark,
                  value: cameraProvider.settings.resolution,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white,
                  ),
                  items: const [
                    DropdownMenuItem<String>(
                      value: "SD",
                      child: Text("Standard (480p)"),
                    ),
                    DropdownMenuItem<String>(
                      value: "HD",
                      child: Text("HD (720p)"),
                    ),
                    DropdownMenuItem<String>(
                      value: "FHD",
                      child: Text("Full HD (1080p)"),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      final newSettings = cameraProvider.settings.copyWith(
                        resolution: value,
                      );
                      cameraProvider.updateSettings(newSettings);
                    }
                  },
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Contrôle de la luminosité
          Text(
            'Luminosité',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.brightness_4,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Slider(
                  value: cameraProvider.settings.brightness.toDouble(),
                  min: 0,
                  max: 100,
                  divisions: 10,
                  activeColor: AppColorsLogo.secondary,
                  inactiveColor: Colors.white.withOpacity(0.2),
                  onChanged: (value) {
                    final newSettings = cameraProvider.settings.copyWith(
                      brightness: value.toInt(),
                    );
                    cameraProvider.updateSettings(newSettings);
                  },
                ),
              ),
              SizedBox(
                width: 40,
                child: Text(
                  '${cameraProvider.settings.brightness}%',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Contrôle du contraste
          Text(
            'Contraste',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.contrast,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Slider(
                  value: cameraProvider.settings.contrast.toDouble(),
                  min: 0,
                  max: 100,
                  divisions: 10,
                  activeColor: AppColorsLogo.secondary,
                  inactiveColor: Colors.white.withOpacity(0.2),
                  onChanged: (value) {
                    final newSettings = cameraProvider.settings.copyWith(
                      contrast: value.toInt(),
                    );
                    cameraProvider.updateSettings(newSettings);
                  },
                ),
              ),
              SizedBox(
                width: 40,
                child: Text(
                  '${cameraProvider.settings.contrast}%',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}