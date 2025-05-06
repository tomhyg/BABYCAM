// lib/ui/screens/splash_screen_modern.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../../providers/settings_provider.dart';
import '../../providers/camera_provider.dart';
import '../../providers/sensor_provider.dart';
import '../../providers/audio_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/ai_analysis_provider.dart';
import '../widgets/animated_gradient_background.dart';
import 'home_screen_modern.dart';
import 'onboarding_screen.dart';

class SplashScreenModern extends StatefulWidget {
  const SplashScreenModern({Key? key}) : super(key: key);

  @override
  _SplashScreenModernState createState() => _SplashScreenModernState();
}

class _SplashScreenModernState extends State<SplashScreenModern> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  
  bool _isLoading = true;
  String _statusText = 'Initialisation...';
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    
    // Configuration des animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );
    
    _animationController.forward();
    
    // Initialisation de l'application
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final steps = 6; // Nombre total d'étapes d'initialisation
    int currentStep = 0;
    
    // Fonction pour mettre à jour le statut
    void updateStatus(String status) {
      setState(() {
        _statusText = status;
        currentStep++;
        _progress = currentStep / steps;
      });
    }
    
    // Initialisation de tous les providers
    try {
      updateStatus('Chargement des paramètres...');
      await Future.delayed(const Duration(milliseconds: 500));
      
      final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
      await settingsProvider.initialize();
      
      updateStatus('Vérification de l\'authentification...');
      await Future.delayed(const Duration(milliseconds: 400));
      
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.initialize();
      
      updateStatus('Connexion à la caméra...');
      await Future.delayed(const Duration(milliseconds: 600));
      
      final cameraProvider = Provider.of<CameraProvider>(context, listen: false);
      cameraProvider.initialize(settingsProvider.baseUrl);
      
      updateStatus('Chargement des capteurs...');
      await Future.delayed(const Duration(milliseconds: 500));
      
      final sensorProvider = Provider.of<SensorProvider>(context, listen: false);
      sensorProvider.initialize(settingsProvider.baseUrl);
      
      updateStatus('Chargement des berceuses...');
      await Future.delayed(const Duration(milliseconds: 400));
      
      final audioProvider = Provider.of<AudioProvider>(context, listen: false);
      audioProvider.initialize(settingsProvider.baseUrl);
      
      updateStatus('Initialisation de l\'IA...');
      await Future.delayed(const Duration(milliseconds: 600));
      
      final aiAnalysisProvider = Provider.of<AIAnalysisProvider>(context, listen: false);
      aiAnalysisProvider.initialize(settingsProvider.baseUrl);
      
      // Attendre un peu pour montrer l'écran splash complet
      await Future.delayed(const Duration(seconds: 1));
      
      setState(() {
        _isLoading = false;
      });
      
      // Animation finale avant de naviguer
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Naviguer vers l'écran approprié
      if (mounted) {
        if (!settingsProvider.onboardingCompleted) {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const OnboardingScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              transitionDuration: const Duration(milliseconds: 500),
            ),
          );
        } else {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const HomeScreenModern(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              transitionDuration: const Duration(milliseconds: 500),
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _statusText = 'Erreur lors de l\'initialisation: $e';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    
    return Scaffold(
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: Center(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: child,
                  ),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.baby_changing_station,
                      size: 80,
                      color: Color(0xFF8E77FF), // AppColorsModern.primary
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // Titre et sous-titre
                  const Text(
                    'BABYCAM AI',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Surveillance intelligente pour bébé',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 64),
                  
                  // Indicateur de chargement
                  if (_isLoading) ...[
                    // Barre de progression
                    Container(
                      width: 240,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Stack(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            width: 240 * _progress,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Texte de statut
                    Text(
                      _statusText,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ] else ...[
                    // Message de succès
                    const Text(
                      'Démarrage en cours...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}