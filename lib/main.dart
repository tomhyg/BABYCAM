// lib/main.dart (COMPLET)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// Imports des écrans
import 'ui/screens/splash_screen.dart';
import 'ui/screens/onboarding_screen.dart';
import 'ui/screens/home_screen_modern.dart';

// Imports du thème
import 'ui/theme/app_color_schemes.dart';
import 'ui/theme/app_theme_manager.dart';

// Providers existants
import 'providers/camera_provider.dart';
import 'providers/sensor_provider.dart';
import 'providers/audio_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/ai_analysis_provider.dart';

// Nouveaux providers
import 'providers/nightlight_provider.dart';
import 'providers/monitoring_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Forcer l'orientation portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(
    MultiProvider(
      providers: [
        // Providers existants
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => CameraProvider()),
        ChangeNotifierProvider(create: (_) => SensorProvider()),
        ChangeNotifierProvider(create: (_) => AudioProvider()),
        ChangeNotifierProvider(create: (_) => AIAnalysisProvider()),
        
        // Nouveaux providers pour les fonctionnalités avancées
        ChangeNotifierProvider(create: (_) => NightlightProvider()),
        ChangeNotifierProvider(create: (_) => MonitoringProvider()),
      ],
      child: const BabycamApp(),
    ),
  );
}

class BabycamApp extends StatefulWidget {
  const BabycamApp({Key? key}) : super(key: key);

  @override
  _BabycamAppState createState() => _BabycamAppState();
}

class _BabycamAppState extends State<BabycamApp> {
  bool _initialized = false;
  
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }
  
  Future<void> _initializeApp() async {
    try {
      // Initialiser le provider de paramètres en premier (contient les thèmes)
      final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
      await settingsProvider.initialize();
      
      // Configurer la barre de statut selon le thème
      _updateSystemUI(settingsProvider.darkMode);
      
      // Initialiser les providers existants
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.initialize();
      
      final cameraProvider = Provider.of<CameraProvider>(context, listen: false);
      cameraProvider.initialize(settingsProvider.baseUrl);
      
      final sensorProvider = Provider.of<SensorProvider>(context, listen: false);
      sensorProvider.initialize(settingsProvider.baseUrl);
      
      final audioProvider = Provider.of<AudioProvider>(context, listen: false);
      audioProvider.initialize(settingsProvider.baseUrl);
      
      final aiAnalysisProvider = Provider.of<AIAnalysisProvider>(context, listen: false);
      aiAnalysisProvider.initialize(settingsProvider.baseUrl);
      
      // Initialiser les nouveaux providers
      final nightlightProvider = Provider.of<NightlightProvider>(context, listen: false);
      nightlightProvider.initialize(settingsProvider.baseUrl);
      
      final monitoringProvider = Provider.of<MonitoringProvider>(context, listen: false);
      monitoringProvider.initialize(settingsProvider.baseUrl);
      
      // Attendre un court délai pour s'assurer que tout est initialisé
      await Future.delayed(const Duration(milliseconds: 500));
      
      setState(() {
        _initialized = true;
      });
      
      debugPrint('🚀 BABYCAM AI - Tous les providers initialisés avec succès');
      debugPrint('🎨 Thème actuel: ${settingsProvider.currentThemeName}');
      debugPrint('🌓 Mode sombre: ${settingsProvider.darkMode}');
      
    } catch (e) {
      debugPrint('❌ Erreur lors de l\'initialisation: $e');
      // En cas d'erreur, on marque quand même comme initialisé pour éviter un blocage
      setState(() {
        _initialized = true;
      });
    }
  }

  void _updateSystemUI(bool isDarkMode) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: isDarkMode ? const Color(0xFF1a1a1a) : Colors.white,
      systemNavigationBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
    ));
  }

  @override
  Widget build(BuildContext context) {
    // Affichage du splash screen pendant l'initialisation
    if (!_initialized) {
      return MaterialApp(
        title: 'BABYCAM AI',
        theme: AppThemeManager.createTheme(
          colorScheme: ColorSchemeType.cosmic,
          isDarkMode: true,
        ),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1a1a2e),
                  Color(0xFF2d2d47),
                ],
              ),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.baby_changing_station,
                    size: 80,
                    color: Colors.white,
                  ),
                  SizedBox(height: 24),
                  Text(
                    'BABYCAM AI',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Initialisation...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 32),
                  CircularProgressIndicator(
                    color: Color(0xFF8E77FF),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    
    // Application principale avec thème dynamique
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        // Mettre à jour la barre de statut quand le thème change
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _updateSystemUI(settings.darkMode);
        });
        
        return MaterialApp(
          title: 'BABYCAM AI',
          theme: AppThemeManager.createTheme(
            colorScheme: settings.colorScheme,
            isDarkMode: settings.darkMode,
          ),
          debugShowCheckedModeBanner: false,
          
          // Configuration des routes
          home: _getStartupScreen(settings),
          
          // Configuration globale
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaleFactor: 1.0, // Empêche le zoom système
              ),
              child: child!,
            );
          },
        );
      },
    );
  }

  Widget _getStartupScreen(SettingsProvider settings) {
    // Logique de navigation au démarrage
    if (!settings.onboardingCompleted) {
      debugPrint('📱 Navigation: Affichage de l\'onboarding');
      return const OnboardingScreen();
    }
    
    debugPrint('📱 Navigation: Affichage de l\'écran principal');
    return const HomeScreenModern();
  }
}

// ============================================================================
// CONFIGURATION GLOBALE DE L'APPLICATION
// ============================================================================
class AppConfig {
  static const String appName = 'BABYCAM AI';
  static const String appVersion = '2.0.0';
  
  // Configuration par défaut du thème
  static const ColorSchemeType defaultColorScheme = ColorSchemeType.cosmic;
  static const bool defaultDarkMode = true;
  
  // Configuration de debug
  static const bool enableDebugLogs = true;
  
  static void debugLog(String message) {
    if (enableDebugLogs) {
      debugPrint('🔧 BABYCAM: $message');
    }
  }
}