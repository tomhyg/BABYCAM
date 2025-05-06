// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ui/screens/splash_screen_modern.dart';
import 'ui/screens/onboarding_screen.dart';
import 'ui/theme/app_theme_logo.dart';
import 'providers/camera_provider.dart';
import 'providers/sensor_provider.dart';
import 'providers/audio_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/ai_analysis_provider.dart';
import 'core/services/notification_service.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Forcer l'orientation portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Style de la barre de statut
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  ));
  
  // Initialisation des services
  //final notificationService = NotificationService();
  //await notificationService.initialize();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CameraProvider()),
        ChangeNotifierProvider(create: (_) => SensorProvider()),
        ChangeNotifierProvider(create: (_) => AudioProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => AIAnalysisProvider()),
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
    // Initialiser les providers
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    await settingsProvider.initialize();
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.initialize();
    
    setState(() {
      _initialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    
    if (!_initialized) {
      return MaterialApp(
        title: 'BABYCAM AI',
        theme: AppThemeLogo.lightTheme,
        darkTheme: AppThemeLogo.darkTheme,
        themeMode: ThemeMode.system,
        home: const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
    
    return MaterialApp(
      title: 'BABYCAM AI',
      theme: AppThemeLogo.lightTheme,
      darkTheme: AppThemeLogo.darkTheme,
      themeMode: settingsProvider.darkMode ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: _getStartupScreen(),
    );
  }

  Widget _getStartupScreen() {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    
    // Afficher l'onboarding au premier lancement
    if (!settingsProvider.onboardingCompleted) {
      return const OnboardingScreen();
    }
    
    // Si onboarding complété, montrer le splash screen
    return const SplashScreenModern();
  }
}