import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../providers/camera_provider.dart';
import '../../providers/audio_provider.dart';
import '../../providers/intercom_provider.dart';

class LiveViewScreen extends StatefulWidget {
  const LiveViewScreen({Key? key}) : super(key: key);

  @override
  _LiveViewScreenState createState() => _LiveViewScreenState();
}

class _LiveViewScreenState extends State<LiveViewScreen> {
  WebViewController? _webViewController;
  bool _isFullScreen = false;
  bool _showControls = true;
  
  @override
  void initState() {
    super.initState();
    // Force l'orientation paysage pour cette page
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cameraProvider = Provider.of<CameraProvider>(context, listen: false);
      print("Entrée dans LiveViewScreen - Stream actif: ${cameraProvider.isStreaming}");
      
      if (!cameraProvider.isStreaming) {
        cameraProvider.startStreaming();
      }
    });
  }
  
  @override
  void dispose() {
    // Restaurer l'orientation automatique lorsque l'utilisateur quitte cette page
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    
    _webViewController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cameraProvider = Provider.of<CameraProvider>(context);
    final audioProvider = Provider.of<AudioProvider>(context);
    final intercomProvider = Provider.of<IntercomProvider>(context);
    
    return Scaffold(
      // Enlever l'appBar en plein écran
      appBar: _isFullScreen ? null : AppBar(
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
              _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
            ),
            onPressed: () {
              setState(() {
                _isFullScreen = !_isFullScreen;
                _showControls = !_isFullScreen;
              });
            },
          ),
        ],
      ),
      // Masquer les boutons de navigation en plein écran
      extendBodyBehindAppBar: true,
      body: GestureDetector(
        // Afficher/masquer les contrôles en tapant sur l'écran
        onTap: () {
          if (_isFullScreen) {
            setState(() {
              _showControls = !_showControls;
            });
          }
        },
        child: Stack(
          children: [
            // Fond noir
            Container(color: Colors.black),
            
            // WebView pour le flux caméra (toujours visible)
            if (cameraProvider.isStreaming)
              WebView(
                initialUrl: 'http://192.168.1.95:8080/stream',
                javascriptMode: JavascriptMode.unrestricted,
                backgroundColor: Colors.black,
                gestureNavigationEnabled: false,
                onWebViewCreated: (WebViewController controller) {
                  _webViewController = controller;
                },
                onWebResourceError: (WebResourceError error) {
                  print("Erreur WebView: ${error.description}");
                },
              )
            else
              const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
            
            // Contrôles flottants (visibles selon _showControls)
            if (_showControls)
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Contrôle play/pause
                      FloatingActionButton.small(
                        heroTag: "play_pause",
                        onPressed: () {
                          if (cameraProvider.isStreaming) {
                            cameraProvider.stopStreaming();
                          } else {
                            cameraProvider.startStreaming();
                          }
                        },
                        backgroundColor: Colors.white,
                        child: Icon(
                          cameraProvider.isStreaming ? Icons.pause : Icons.play_arrow,
                          color: Colors.black,
                        ),
                      ),
                      
                      // Contrôle veilleuse
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FloatingActionButton.small(
                            heroTag: "nightlight",
                            onPressed: () {
                              cameraProvider.toggleNightLight(!cameraProvider.isNightLightOn);
                            },
                            backgroundColor: cameraProvider.isNightLightOn 
                                ? Colors.amber 
                                : Colors.white,
                            child: Icon(
                              Icons.lightbulb,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Veilleuse',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      
                      // Contrôle interphone
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onLongPressStart: (_) {
                              intercomProvider.startTalking();
                            },
                            onLongPressEnd: (_) {
                              intercomProvider.stopTalking();
                            },
                            onLongPressCancel: () {
                              intercomProvider.stopTalking();
                            },
                            child: FloatingActionButton.small(
                              heroTag: "intercom",
                              onPressed: null, // Utilise le geste LongPress plutôt que onPressed
                              backgroundColor: intercomProvider.isTalking 
                                  ? Colors.red 
                                  : Colors.white,
                              child: Icon(
                                Icons.mic,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Interphone',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      
                      // Contrôle berceuse
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FloatingActionButton.small(
                            heroTag: "lullaby",
                            onPressed: () {
                              if (audioProvider.isPlaying) {
                                audioProvider.stopLullaby();
                              } else if (audioProvider.currentLullaby != null) {
                                audioProvider.playLullaby(audioProvider.currentLullaby!);
                              } else if (audioProvider.availableLullabies.isNotEmpty) {
                                audioProvider.playLullaby(audioProvider.availableLullabies.first);
                              }
                            },
                            backgroundColor: audioProvider.isPlaying 
                                ? Colors.green 
                                : Colors.white,
                            child: Icon(
                              audioProvider.isPlaying ? Icons.music_note : Icons.music_off,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Berceuse',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      
                      // Bouton de capture d'écran
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FloatingActionButton.small(
                            heroTag: "snapshot",
                            onPressed: () {
                              cameraProvider.captureSnapshot();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Capture d\'écran prise'),
                                  duration: Duration(seconds: 1),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.photo_camera,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Capture',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      
                      // Contrôle plein écran
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FloatingActionButton.small(
                            heroTag: "fullscreen",
                            onPressed: () {
                              setState(() {
                                _isFullScreen = !_isFullScreen;
                              });
                            },
                            backgroundColor: Colors.white,
                            child: Icon(
                              _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _isFullScreen ? 'Normal' : 'Plein écran',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
            // Indicateur d'interphone actif
            if (intercomProvider.isTalking)
              Positioned(
                top: 80,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.mic,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Interphone actif',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}