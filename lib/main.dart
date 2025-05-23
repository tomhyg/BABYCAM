// lib/main.dart (mis à jour)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// Imports des écrans
import 'ui/screens/splash_screen.dart';
import 'ui/screens/onboarding_screen.dart';
import 'ui/screens/home_screen_modern.dart';

// Imports du thème
import 'ui/theme/app_theme_manager.dart';

// Providers
import 'providers/camera_provider.dart';
import 'providers/sensor_provider.dart';
import 'providers/audio_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/ai_analysis_provider.dart';
import 'providers/nightlight_provider.dart';
import 'providers/monitoring_provider.dart';
import 'providers/intercom_provider.dart';

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
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => CameraProvider()),
        ChangeNotifierProvider(create: (_) => SensorProvider()),
        ChangeNotifierProvider(create: (_) => AudioProvider()),
        ChangeNotifierProvider(create: (_) => AIAnalysisProvider()),
        ChangeNotifierProvider(create: (_) => NightlightProvider()),
        ChangeNotifierProvider(create: (_) => MonitoringProvider()),
        ChangeNotifierProvider(create: (_) => IntercomProvider()),
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
      // Initialiser le provider de paramètres en premier
      final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
      await settingsProvider.initialize();
      
      // Configurer la barre de statut selon le thème
      _updateSystemUI(settingsProvider.colorScheme);
      
      // Initialiser les autres providers
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
      
      final nightlightProvider = Provider.of<NightlightProvider>(context, listen: false);
      nightlightProvider.initialize(settingsProvider.baseUrl);
      
      final monitoringProvider = Provider.of<MonitoringProvider>(context, listen: false);
      monitoringProvider.initialize(settingsProvider.baseUrl);
      
      final intercomProvider = Provider.of<IntercomProvider>(context, listen: false);
      intercomProvider.initialize('192.168.1.95', 8080);
      
      // Attendre un court délai
      await Future.delayed(const Duration(milliseconds: 500));
      
      setState(() {
        _initialized = true;
      });
      
      debugPrint('🚀 BABYCAM AI - Tous les providers initialisés avec succès');
      debugPrint('🎨 Thème actuel: ${settingsProvider.currentThemeName}');
      
    } catch (e) {
      debugPrint('❌ Erreur lors de l\'initialisation: $e');
      setState(() {
        _initialized = true;
      });
    }
  }

  void _updateSystemUI(ColorSchemeType colorScheme) {
    final isDarkTheme = colorScheme == ColorSchemeType.dark || colorScheme == ColorSchemeType.cosmic;
    
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDarkTheme ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDarkTheme ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: isDarkTheme ? const Color(0xFF1a1a1a) : Colors.white,
      systemNavigationBarIconBrightness: isDarkTheme ? Brightness.light : Brightness.dark,
    ));
  }

  @override
  Widget build(BuildContext context) {
    // Splash screen pendant l'initialisation
    if (!_initialized) {
      return MaterialApp(
        title: 'BABYCAM AI',
        theme: AppThemeManager.createTheme(
          colorScheme: ColorSchemeType.dark,
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
          _updateSystemUI(settings.colorScheme);
        });
        
        return MaterialApp(
          title: 'BABYCAM AI',
          theme: settings.getThemeData(),
          debugShowCheckedModeBanner: false,
          
          // Configuration des routes
          home: _getStartupScreen(settings),
          
          // Configuration globale
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaleFactor: 1.0,
              ),
              child: child!,
            );
          },
        );
      },
    );
  }

  Widget _getStartupScreen(SettingsProvider settings) {
    if (!settings.onboardingCompleted) {
      debugPrint('📱 Navigation: Affichage de l\'onboarding');
      return const OnboardingScreen();
    }
    
    debugPrint('📱 Navigation: Affichage de l\'écran principal');
    return const HomeScreenModern();
  }
}