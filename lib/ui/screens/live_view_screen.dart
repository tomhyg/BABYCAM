import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/camera_provider.dart';
import '../../providers/audio_provider.dart';

class LiveViewScreen extends StatelessWidget {
  const LiveViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cameraProvider = Provider.of<CameraProvider>(context);
    final audioProvider = Provider.of<AudioProvider>(context);
    
    // Débogage
    print("Stream URL: ${cameraProvider.streamUrl}");
    print("Is Streaming: ${cameraProvider.isStreaming}");
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vue en direct'),
        actions: [
          IconButton(
            icon: const Icon(Icons.photo_camera),
            onPressed: () {
              cameraProvider.captureSnapshot();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Capture d\'écran prise')),
              );
            },
          ),
          IconButton(
            icon: Icon(
              cameraProvider.settings.nightVisionEnabled
                  ? Icons.nightlight_round
                  : Icons.nightlight_outlined,
            ),
            onPressed: () {
              final newSettings = cameraProvider.settings.copyWith(
                nightVisionEnabled: !cameraProvider.settings.nightVisionEnabled,
              );
              cameraProvider.updateSettings(newSettings);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Flux vidéo
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.black,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (cameraProvider.isStreaming && cameraProvider.streamUrl.isNotEmpty)
                    Image.network(
                      "http://192.168.1.95:8080/stream", // URL directe au lieu de cameraProvider.streamUrl
                      fit: BoxFit.contain,
                      gaplessPlayback: true,  // Important pour un streaming fluide
                      // Suppression des paramètres cacheWidth et cacheHeight
                      headers: const {'Connection': 'keep-alive', 'Keep-Alive': 'timeout=5, max=1000'},
                      errorBuilder: (context, error, stackTrace) {
                        print("Erreur de chargement du flux: $error");
                        print("Stack trace: $stackTrace");
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min, // Limite la taille de la colonne
                            children: [
                              Icon(
                                Icons.error_outline, 
                                size: 64, 
                                color: Colors.white54
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Impossible de charger le flux vidéo',
                                style: TextStyle(color: Colors.white54, fontSize: 16),
                              ),
                            ],
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        );
                      },
                    )
                  else
                    const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min, // Limite la taille de la colonne
                        children: [
                          Icon(
                            Icons.videocam_off, 
                            size: 64, 
                            color: Colors.white54
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Flux vidéo désactivé',
                            style: TextStyle(color: Colors.white54, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  
                  // Bouton lecture/pause
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: FloatingActionButton(
                      onPressed: () {
                        if (cameraProvider.isStreaming) {
                          cameraProvider.stopStreaming();
                        } else {
                          cameraProvider.startStreaming();
                        }
                      },
                      backgroundColor: Colors.black54,
                      child: Icon(
                        cameraProvider.isStreaming ? Icons.pause : Icons.play_arrow,
                        size: 32,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Contrôles
          Expanded(
            flex: 2,
            child: SingleChildScrollView( // Ajout de SingleChildScrollView
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Limite la taille de la colonne
                children: [
                  // Contrôle veilleuse
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min, // Limite la taille de la colonne
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Veilleuse',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Switch(
                                value: cameraProvider.isNightLightOn,
                                onChanged: (enabled) {
                                  cameraProvider.toggleNightLight(enabled);
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.brightness_low, size: 20),
                              Expanded(
                                child: Slider(
                                  value: cameraProvider.settings.nightLightBrightness.toDouble(),
                                  min: 0,
                                  max: 100,
                                  divisions: 10,
                                  label: '${cameraProvider.settings.nightLightBrightness}%',
                                  onChanged: cameraProvider.isNightLightOn
                                      ? (value) {
                                          cameraProvider.toggleNightLight(true, value.toInt());
                                        }
                                      : null,
                                ),
                              ),
                              const Icon(Icons.brightness_high, size: 20),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Contrôle audio
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min, // Limite la taille de la colonne
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Berceuses',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                icon: Icon(
                                  audioProvider.isPlaying
                                      ? Icons.pause_circle_filled
                                      : Icons.play_circle_filled,
                                  size: 32,
                                  color: Theme.of(context).colorScheme.primary,
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
                              ),
                            ],
                          ),
                          if (audioProvider.availableLullabies.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            DropdownButton<String>(
                              isExpanded: true,
                              value: audioProvider.currentLullaby,
                              hint: const Text('Sélectionner une berceuse'),
                              onChanged: (value) {
                                if (value != null) {
                                  audioProvider.playLullaby(value);
                                }
                              },
                              items: audioProvider.availableLullabies.map((lullaby) {
                                return DropdownMenuItem<String>(
                                  value: lullaby,
                                  child: Text(lullaby),
                                );
                              }).toList(),
                            ),
                          ] else
                            const Text('Aucune berceuse disponible'),
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
    );
  }
}