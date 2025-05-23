// lib/ui/screens/splash_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/camera_provider.dart';
import '../../providers/sensor_provider.dart';
import '../../providers/audio_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/ai_analysis_provider.dart';
import '../../providers/nightlight_provider.dart';
import 'home_screen_modern.dart';
import 'onboarding_screen.dart';
import '../theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0, 
      end: 1.0
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8, 
      end: 1.0
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    _animationController.forward();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      debugPrint('🚀 Début de l\'initialisation BABYCAM AI');
      
      // Initialisation de tous les providers
      final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
      await settingsProvider.initialize();
      debugPrint('✅ SettingsProvider initialisé');
      
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.initialize();
      debugPrint('✅ AuthProvider initialisé');
      
      final cameraProvider = Provider.of<CameraProvider>(context, listen: false);
      cameraProvider.initialize(settingsProvider.baseUrl);
      debugPrint('✅ CameraProvider initialisé avec URL: ${settingsProvider.baseUrl}');
      
      final sensorProvider = Provider.of<SensorProvider>(context, listen: false);
      sensorProvider.initialize(settingsProvider.baseUrl);
      debugPrint('✅ SensorProvider initialisé');
      
      final audioProvider = Provider.of<AudioProvider>(context, listen: false);
      audioProvider.initialize(settingsProvider.baseUrl);
      debugPrint('✅ AudioProvider initialisé');
      
      final aiAnalysisProvider = Provider.of<AIAnalysisProvider>(context, listen: false);
      aiAnalysisProvider.initialize(settingsProvider.baseUrl);
      debugPrint('✅ AIAnalysisProvider initialisé');
      
      final nightlightProvider = Provider.of<NightlightProvider>(context, listen: false);
      nightlightProvider.initialize(settingsProvider.baseUrl);
      debugPrint('✅ NightlightProvider initialisé');
      
      // Attendre un peu pour montrer le splash screen
      await Future.delayed(const Duration(seconds: 3));
      
      debugPrint('🎯 Initialisation terminée, navigation vers l\'écran principal');
      
      // Naviguer vers l'écran approprié
      if (mounted) {
        if (!settingsProvider.onboardingCompleted) {
          debugPrint('📱 Navigation vers OnboardingScreen');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const OnboardingScreen()),
          );
        } else {
          debugPrint('📱 Navigation vers HomeScreenModern');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreenModern()),
          );
        }
      }
    } catch (e) {
      debugPrint('❌ Erreur lors de l\'initialisation: $e');
      // En cas d'erreur, naviguer quand même vers l'écran principal après un délai
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreenModern()),
        );
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              AppColors.primary,
              AppColors.primaryVariant,
              AppColors.secondary,
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo principal avec animation
                    Hero(
                      tag: 'babycam_logo',
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 30,
                              offset: const Offset(0, 15),
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.baby_changing_station,
                          size: 100,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 50),
                    
                    // Titre principal
                    const Text(
                      'BABYCAM AI',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                        shadows: [
                          Shadow(
                            blurRadius: 10,
                            color: Colors.black26,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Sous-titre
                    Text(
                      'Surveillance bébé intelligente',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 60),
                    
                    // Indicateur de chargement avec animation
                    Column(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 3,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        Text(
                          'Initialisation en cours...',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 80),
                    
                    // Version et informations
                    Column(
                      children: [
                        Text(
                          'Version 1.0.0',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Surveillance intelligente avec IA',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}