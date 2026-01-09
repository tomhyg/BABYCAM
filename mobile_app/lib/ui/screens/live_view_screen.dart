// lib/ui/screens/live_view_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../providers/camera_provider.dart';
import '../../providers/audio_provider.dart';
import '../theme/app_colors.dart';

class LiveViewScreen extends StatefulWidget {
  const LiveViewScreen({Key? key}) : super(key: key);

  @override
  _LiveViewScreenState createState() => _LiveViewScreenState();
}

class _LiveViewScreenState extends State<LiveViewScreen> {
  WebViewController? _webViewController;
  bool _isFullScreen = false;
  bool _showControls = true;
  bool _isTalking = false; // État local de l'intercom
  
  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cameraProvider = Provider.of<CameraProvider>(context, listen: false);
      debugPrint("Entrée dans LiveViewScreen - Stream actif: ${cameraProvider.isStreaming}");
      
      if (!cameraProvider.isStreaming) {
        cameraProvider.startStreaming();
      }
    });
  }
  
  @override
  void dispose() {
    // Restaurer l'orientation automatique
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
    
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      
      // AppBar moderne avec transparence
      appBar: _isFullScreen ? null : AppBar(
        backgroundColor: Colors.black.withOpacity(0.3),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Vue en direct',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        actions: [
          // Bouton capture
          IconButton(
            icon: const Icon(Icons.photo_camera, color: Colors.white),
            onPressed: () {
              cameraProvider.captureSnapshot();
              _showSnackBar('Capture d\'écran prise', AppColors.success);
            },
          ),
          // Bouton plein écran
          IconButton(
            icon: Icon(
              _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isFullScreen = !_isFullScreen;
                _showControls = !_isFullScreen;
              });
              
              if (_isFullScreen) {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.landscapeLeft,
                  DeviceOrientation.landscapeRight,
                ]);
              } else {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                ]);
              }
            },
          ),
        ],
      ),
      
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
            // Vue caméra principale
            Positioned.fill(
              child: _buildCameraView(cameraProvider),
            ),
            
            // Indicateurs d'état en haut
            if (_showControls) _buildStatusIndicators(cameraProvider),
            
            // Contrôles flottants en bas
            if (_showControls) _buildFloatingControls(cameraProvider, audioProvider),
            
            // Indicateur d'intercom actif
            if (_isTalking) _buildTalkingIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraView(CameraProvider cameraProvider) {
    if (!cameraProvider.isStreaming) {
      return _buildOfflineView();
    }

    return WebView(
      initialUrl: 'http://192.168.1.95:8080/stream',
      javascriptMode: JavascriptMode.unrestricted,
      backgroundColor: Colors.black,
      gestureNavigationEnabled: false,
      onWebViewCreated: (WebViewController controller) {
        _webViewController = controller;
      },
      onWebResourceError: (WebResourceError error) {
        debugPrint("Erreur WebView: ${error.description}");
      },
    );
  }

  Widget _buildOfflineView() {
    return Container(
      color: Colors.black,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.videocam_off,
              size: 80,
              color: Colors.white54,
            ),
            SizedBox(height: 24),
            Text(
              'Flux vidéo désactivé',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Tapez le bouton lecture pour démarrer',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicators(CameraProvider cameraProvider) {
    return Positioned(
      top: _isFullScreen ? 20 : 100,
      left: 20,
      right: 20,
      child: Row(
        children: [
          // Indicateur de connexion
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: cameraProvider.isStreaming ? Colors.green : Colors.red,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: cameraProvider.isStreaming ? Colors.green : Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  cameraProvider.isStreaming ? 'En direct' : 'Hors ligne',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          const Spacer(),
          
          // Qualité vidéo
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'HD 720p',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingControls(CameraProvider cameraProvider, AudioProvider audioProvider) {
    return Positioned(
      bottom: _isFullScreen ? 30 : 50,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Contrôle play/pause
            _buildControlButton(
              icon: cameraProvider.isStreaming ? Icons.pause : Icons.play_arrow,
              label: cameraProvider.isStreaming ? 'Pause' : 'Lecture',
              isActive: cameraProvider.isStreaming,
              onPressed: () {
                if (cameraProvider.isStreaming) {
                  cameraProvider.stopStreaming();
                } else {
                  cameraProvider.startStreaming();
                }
              },
            ),
            
            // Contrôle veilleuse
            _buildControlButton(
              icon: cameraProvider.isNightLightOn ? Icons.lightbulb : Icons.lightbulb_outline,
              label: 'Veilleuse',
              isActive: cameraProvider.isNightLightOn,
              onPressed: () {
                cameraProvider.toggleNightLight(!cameraProvider.isNightLightOn);
                _showSnackBar(
                  cameraProvider.isNightLightOn ? 'Veilleuse activée' : 'Veilleuse désactivée',
                  AppColors.info,
                );
              },
            ),
            
            // Contrôle interphone (local)
            _buildControlButton(
              icon: _isTalking ? Icons.mic : Icons.mic_none,
              label: 'Parler',
              isActive: _isTalking,
              onLongPress: () {
                setState(() {
                  _isTalking = true;
                });
                _showSnackBar('Interphone activé - Maintenez pour parler', AppColors.info);
              },
              onLongPressEnd: () {
                setState(() {
                  _isTalking = false;
                });
              },
            ),
            
            // Contrôle berceuse
            _buildControlButton(
              icon: audioProvider.isPlaying ? Icons.music_note : Icons.music_note_outlined,
              label: 'Berceuse',
              isActive: audioProvider.isPlaying,
              onPressed: () {
                if (audioProvider.isPlaying) {
                  audioProvider.stopLullaby();
                } else if (audioProvider.availableLullabies.isNotEmpty) {
                  audioProvider.playLullaby(audioProvider.availableLullabies.first);
                }
                _showSnackBar(
                  audioProvider.isPlaying ? 'Berceuse activée' : 'Berceuse arrêtée',
                  AppColors.info,
                );
              },
            ),
            
            // Bouton de capture
            _buildControlButton(
              icon: Icons.photo_camera,
              label: 'Capture',
              onPressed: () {
                cameraProvider.captureSnapshot();
                _showSnackBar('Photo capturée', AppColors.success);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    bool isActive = false,
    VoidCallback? onPressed,
    VoidCallback? onLongPress,
    VoidCallback? onLongPressEnd,
  }) {
    return GestureDetector(
      onTap: onPressed,
      onLongPress: onLongPress,
      onLongPressEnd: (_) => onLongPressEnd?.call(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: isActive ? AppColors.primary : Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: isActive ? Colors.white : Colors.white70,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.white70,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTalkingIndicator() {
    return Positioned(
      top: _isFullScreen ? 80 : 160,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.9),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              const Icon(
                Icons.mic,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Interphone actif',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String message, Color backgroundColor) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.15,
          left: 16,
          right: 16,
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}