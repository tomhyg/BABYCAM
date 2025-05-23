// lib/ui/screens/onboarding_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/auth_provider.dart';
import '../theme/app_colors.dart';
import 'home_screen_modern.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _numPages = 4;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _ssidController = TextEditingController();
  final TextEditingController _wifiPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _notificationsAllowed = true;
  bool _locationAllowed = true;

  @override
  void dispose() {
    _pageController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _ssidController.dispose();
    _wifiPasswordController.dispose();
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
            colors: [AppColors.primary, AppColors.primaryVariant, AppColors.secondary],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Pages principales
              PageView(
                controller: _pageController,
                physics: _isLoading ? const NeverScrollableScrollPhysics() : const AlwaysScrollableScrollPhysics(),
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  _buildWelcomePage(),
                  _buildCreateAccountPage(),
                  _buildConnectCameraPage(),
                  _buildPermissionsPage(),
                ],
              ),
              
              // Contrôles de navigation en bas
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    _buildPageIndicator(),
                    const SizedBox(height: 30),
                    _buildBottomButtons(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomePage() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo principal
          Hero(
            tag: 'babycam_logo',
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(90),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                Icons.baby_changing_station,
                size: 90,
                color: AppColors.primary,
              ),
            ),
          ),
          
          const SizedBox(height: 50),
          
          // Titre principal
          const Text(
            'Bienvenue sur',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 10),
          
          const Text(
            'BABYCAM AI',
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 30),
          
          // Description
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Surveillance intelligente pour le bien-être de votre bébé',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                
                // Fonctionnalités
                Column(
                  children: [
                    _buildFeatureRow(Icons.videocam, 'Vision nocturne HD'),
                    _buildFeatureRow(Icons.mic, 'Détection intelligente des pleurs'),
                    _buildFeatureRow(Icons.sensors, 'Surveillance environnementale'),
                    _buildFeatureRow(Icons.nightlight_round, 'Veilleuse programmable'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white.withOpacity(0.8),
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateAccountPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          
          // Titre
          const Text(
            'Créer un compte',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 10),
          
          Text(
            'Pour sauvegarder vos données et accéder à votre caméra en toute sécurité',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
            ),
          ),
          
          const SizedBox(height: 40),
          
          // Formulaire
          _buildTextFormField(
            controller: _emailController,
            hintText: 'Adresse email',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          
          const SizedBox(height: 20),
          
          _buildTextFormField(
            controller: _passwordController,
            hintText: 'Mot de passe',
            prefixIcon: Icons.lock_outline,
            obscureText: true,
          ),
          
          const SizedBox(height: 20),
          
          _buildTextFormField(
            controller: _confirmPasswordController,
            hintText: 'Confirmer le mot de passe',
            prefixIcon: Icons.lock_outline,
            obscureText: true,
          ),
          
          const SizedBox(height: 30),
          
          // Information de sécurité
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.security,
                  color: Colors.white.withOpacity(0.8),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Vos données sont chiffrées et sécurisées',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectCameraPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          
          // Titre
          const Text(
            'Connecter votre BABYCAM',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 10),
          
          Text(
            'Assurez-vous que votre caméra est allumée et en mode d\'appairage',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
            ),
          ),
          
          const SizedBox(height: 40),
          
          // Instructions
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                _buildInstructionStep('1', 'Allumez votre BABYCAM'),
                _buildInstructionStep('2', 'Connectez-vous au WiFi de la caméra'),
                _buildInstructionStep('3', 'Configurez votre réseau WiFi'),
              ],
            ),
          ),
          
          const SizedBox(height: 30),
          
          // Configuration WiFi
          _buildTextFormField(
            controller: _ssidController,
            hintText: 'Nom de votre réseau WiFi',
            prefixIcon: Icons.wifi,
          ),
          
          const SizedBox(height: 20),
          
          _buildTextFormField(
            controller: _wifiPasswordController,
            hintText: 'Mot de passe WiFi',
            prefixIcon: Icons.lock_outline,
            obscureText: true,
          ),
          
          const SizedBox(height: 25),
          
          // Bouton scan QR
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // Logique scan QR
                _showInfoSnackBar('Fonctionnalité de scan QR à venir');
              },
              icon: Icon(Icons.qr_code_scanner, color: AppColors.primary),
              label: const Text('Scanner le QR code de la caméra'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(30.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height - 250, // Espace pour les boutons
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40), // Réduit de 60 à 40
            
            // Titre
            const Text(
              'Autorisations nécessaires',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28, // Réduit de 32 à 28
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 10),
            
            Text(
              'Pour profiter pleinement de toutes les fonctionnalités',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 16,
              ),
            ),
            
            const SizedBox(height: 30), // Réduit de 40 à 30
            
            // Permissions
            _buildPermissionTile(
              icon: Icons.notifications_active,
              title: 'Notifications',
              description: 'Pour vous alerter des événements importants de votre bébé',
              isEnabled: _notificationsAllowed,
              onChanged: (value) {
                setState(() {
                  _notificationsAllowed = value;
                });
              },
            ),
            
            const SizedBox(height: 16), // Réduit de 20 à 16
            
            _buildPermissionTile(
              icon: Icons.location_on,
              title: 'Localisation',
              description: 'Pour connecter automatiquement votre appareil aux réseaux Wi-Fi',
              isEnabled: _locationAllowed,
              onChanged: (value) {
                setState(() {
                  _locationAllowed = value;
                });
              },
            ),
            
            const SizedBox(height: 30), // Réduit de 40 à 30
            
            // Information supplémentaire - Version compacte
            Container(
              padding: const EdgeInsets.all(16), // Réduit de 20 à 16
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.privacy_tip,
                    color: Colors.white.withOpacity(0.8),
                    size: 24, // Réduit de 30 à 24
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Vie privée protégée',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14, // Réduit de 16 à 14
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Données chiffrées et stockées localement',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12, // Réduit de 14 à 12
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Espacement flexible pour pousser le contenu vers le haut
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
          prefixIcon: Icon(prefixIcon, color: Colors.white.withOpacity(0.7)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        ),
      ),
    );
  }

  Widget _buildPermissionTile({
    required IconData icon,
    required String title,
    required String description,
    required bool isEnabled,
    required Function(bool) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          Switch(
            value: isEnabled,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: AppColors.secondary,
            inactiveThumbColor: Colors.white70,
            inactiveTrackColor: Colors.white24,
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < _numPages; i++) {
      indicators.add(
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: i == _currentPage ? 40 : 12,
          height: 12,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: i == _currentPage 
                ? Colors.white 
                : Colors.white.withOpacity(0.4),
          ),
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: indicators,
    );
  }

  Widget _buildBottomButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: _currentPage == 0
          ? Center(
              child: _buildNextButton(),
            )
          : Row(
              children: [
                // Bouton Précédent - Version compacte
                Expanded(
                  flex: 1,
                  child: TextButton(
                    onPressed: _isLoading ? null : () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_back_ios, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'Retour',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Bouton Suivant/Commencer
                Expanded(
                  flex: 2,
                  child: _buildNextButton(),
                ),
              ],
            ),
    );
  }

  Widget _buildNextButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : () {
        if (_currentPage == _numPages - 1) {
          _finishOnboarding();
        } else {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        elevation: 8,
        shadowColor: Colors.black26,
      ),
      child: _isLoading
          ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 3,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _currentPage == _numPages - 1 ? 'Commencer' : 'Suivant',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  _currentPage == _numPages - 1 ? Icons.check : Icons.arrow_forward_ios,
                  size: 16,
                ),
              ],
            ),
    );
  }

  // === MÉTHODES DE FINALISATION ===

  void _finishOnboarding() async {
    // Validation des champs obligatoires
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showErrorSnackBar('Veuillez remplir tous les champs obligatoires');
      _navigateToPage(1); // Retour à la page de création de compte
      return;
    }

    // Validation de l'email
    if (!_isValidEmail(_emailController.text)) {
      _showErrorSnackBar('Veuillez entrer une adresse email valide');
      _navigateToPage(1);
      return;
    }

    // Validation de la correspondance des mots de passe
    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorSnackBar('Les mots de passe ne correspondent pas');
      _navigateToPage(1);
      return;
    }

    // Validation de la longueur du mot de passe
    if (_passwordController.text.length < 6) {
      _showErrorSnackBar('Le mot de passe doit contenir au moins 6 caractères');
      _navigateToPage(1);
      return;
    }

    // Démarrer le processus de finalisation
    setState(() {
      _isLoading = true;
    });

    try {
      // Récupérer les providers
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
      
      debugPrint('📱 Onboarding: Démarrage de la finalisation');
      
      // 1. Créer le compte utilisateur
      debugPrint('📱 Onboarding: Création du compte utilisateur');
      await authProvider.register(
        _emailController.text.trim(),
        _passwordController.text,
      );
      
      // 2. Sauvegarder les paramètres WiFi si fournis
      if (_ssidController.text.isNotEmpty && _wifiPasswordController.text.isNotEmpty) {
        debugPrint('📱 Onboarding: Sauvegarde des paramètres WiFi');
        await settingsProvider.saveWifiCredentials(
          _ssidController.text.trim(),
          _wifiPasswordController.text,
        );
      }
      
      // 3. Sauvegarder les préférences de notifications
      debugPrint('📱 Onboarding: Sauvegarde des préférences');
      settingsProvider.notificationsEnabled = _notificationsAllowed;
      
      // 4. Marquer l'onboarding comme terminé
      debugPrint('📱 Onboarding: Marquage comme terminé');
      await settingsProvider.setOnboardingCompleted(true);
      
      // 5. Attendre un court délai pour l'UX
      await Future.delayed(const Duration(milliseconds: 1000));
      
      // 6. Naviguer vers l'écran principal
      if (mounted) {
        debugPrint('📱 Onboarding: Navigation vers l\'écran principal');
        _showSuccessSnackBar('Bienvenue dans BABYCAM AI !');
        
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomeScreenModern(),
            settings: const RouteSettings(name: '/home'),
          ),
        );
      }
      
    } catch (e) {
      debugPrint('❌ Onboarding: Erreur lors de la finalisation: $e');
      
      if (mounted) {
        _showErrorSnackBar('Erreur lors de la création du compte: ${e.toString()}');
      }
      
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // === MÉTHODES UTILITAIRES ===

  void _navigateToPage(int pageIndex) {
    _pageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showInfoSnackBar(String message) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.info,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}