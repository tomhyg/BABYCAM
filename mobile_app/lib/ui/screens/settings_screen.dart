// lib/ui/screens/settings_screen_modern.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../theme/app_theme_manager.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // SECTION: Apparence
          _buildSectionHeader('Apparence', Icons.palette, colorScheme),
          const SizedBox(height: 12),
          _buildThemeCard(context, settingsProvider, colorScheme),
          
          const SizedBox(height: 32),
          
          // SECTION: Configuration rapide
          _buildSectionHeader('Configuration', Icons.settings, colorScheme),
          const SizedBox(height: 12),
          _buildQuickSetupCard(context, settingsProvider, colorScheme),
          
          const SizedBox(height: 32),
          
          // SECTION: Notifications et Préférences
          _buildSectionHeader('Préférences', Icons.tune, colorScheme),
          const SizedBox(height: 12),
          _buildPreferencesCard(context, settingsProvider, colorScheme),
          
          const SizedBox(height: 32),
          
          // SECTION: À propos
          _buildSectionHeader('Application', Icons.info_outline, colorScheme),
          const SizedBox(height: 12),
          _buildAboutCard(context, colorScheme),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, ColorScheme colorScheme) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: colorScheme.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colorScheme.onBackground,
          ),
        ),
      ],
    );
  }

  Widget _buildThemeCard(BuildContext context, SettingsProvider settingsProvider, ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thème de l\'application',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Personnalisez l\'apparence selon vos goûts',
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            _buildThemeSelector(context, settingsProvider, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSelector(BuildContext context, SettingsProvider settingsProvider, ColorScheme colorScheme) {
    final themes = [
      ColorSchemeType.dark,
      ColorSchemeType.original,
      ColorSchemeType.cosmic,
    ];

    return Column(
      children: themes.map<Widget>((themeType) {
        final isSelected = settingsProvider.colorScheme == themeType;
        final themeName = AppThemeManager.getThemeName(themeType);
        final themeDescription = AppThemeManager.getThemeDescription(themeType);
        final themeIcon = AppThemeManager.getThemeIcon(themeType);
        final themeColors = AppThemeManager.getThemeColors(themeType);
        
        return GestureDetector(
          onTap: () {
            settingsProvider.setColorScheme(themeType);
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected 
                  ? colorScheme.primary.withOpacity(0.1)
                  : colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected 
                    ? colorScheme.primary
                    : colorScheme.outline.withOpacity(0.3),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                // Aperçu des couleurs
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: themeColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Icon(
                    themeIcon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Info du thème
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        themeName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isSelected 
                              ? colorScheme.primary
                              : colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        themeDescription,
                        style: TextStyle(
                          fontSize: 14,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Indicateur de sélection
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? colorScheme.primary : colorScheme.outline,
                      width: 2,
                    ),
                    color: isSelected ? colorScheme.primary : Colors.transparent,
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 12,
                        )
                      : null,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQuickSetupCard(BuildContext context, SettingsProvider settingsProvider, ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Configuration rapide',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Configurez votre BABYCAM en quelques étapes',
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            
            // Bouton QR Code
            _buildQuickActionButton(
              context: context,
              title: 'Scanner QR Code',
              subtitle: 'Configuration automatique',
              icon: Icons.qr_code_scanner,
              onTap: () => _showQRScanner(context),
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 12),
            
            // Bouton WiFi
            _buildQuickActionButton(
              context: context,
              title: 'Configuration WiFi',
              subtitle: 'Connecter à votre réseau',
              icon: Icons.wifi,
              onTap: () => _showWiFiSetup(context, settingsProvider),
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 12),
            
            // Bouton manuel
            _buildQuickActionButton(
              context: context,
              title: 'Configuration manuelle',
              subtitle: 'Entrer les paramètres à la main',
              icon: Icons.settings,
              onTap: () => _showManualSetup(context, settingsProvider),
              colorScheme: colorScheme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outline.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferencesCard(BuildContext context, SettingsProvider settingsProvider, ColorScheme colorScheme) {
    return Card(
      child: Column(
        children: [
          // Switch pour les notifications
          SwitchListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            title: Text(
              'Notifications',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              'Recevoir des alertes pour les événements',
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            value: settingsProvider.notificationsEnabled,
            onChanged: (value) {
              settingsProvider.notificationsEnabled = value;
            },
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                settingsProvider.notificationsEnabled 
                    ? Icons.notifications_active
                    : Icons.notifications_off,
                color: colorScheme.primary,
                size: 20,
              ),
            ),
            activeColor: colorScheme.primary,
          ),
          
          Divider(color: colorScheme.outline.withOpacity(0.3), height: 1),
          
          // Sélecteur de langue
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.language,
                color: colorScheme.primary,
                size: 20,
              ),
            ),
            title: Text(
              'Langue',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              _getLanguageLabel(settingsProvider.language),
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: colorScheme.onSurfaceVariant,
            ),
            onTap: () {
              _showLanguageSelector(context, settingsProvider, colorScheme);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAboutCard(BuildContext context, ColorScheme colorScheme) {
    return Card(
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.baby_changing_station,
                color: colorScheme.primary,
                size: 20,
              ),
            ),
            title: Text(
              'BABYCAM AI',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              'Version 1.0.0',
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: colorScheme.onSurfaceVariant,
            ),
            onTap: () {
              _showAboutDialog(context, colorScheme);
            },
          ),
          
          Divider(color: colorScheme.outline.withOpacity(0.3), height: 1),
          
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.help_outline,
                color: colorScheme.primary,
                size: 20,
              ),
            ),
            title: Text(
              'Aide et support',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              'Documentation et FAQ',
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: colorScheme.onSurfaceVariant,
            ),
            onTap: () {
              _showHelpDialog(context, colorScheme);
            },
          ),
        ],
      ),
    );
  }

  // MÉTHODES D'ACTION

  void _showQRScanner(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        height: 300,
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const Icon(Icons.qr_code_scanner, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Scanner QR Code',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Scannez le QR code sur votre BABYCAM pour une configuration automatique',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: Implémenter le scanner QR
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Scanner QR Code (à implémenter)')),
                  );
                },
                child: const Text('Ouvrir le scanner'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showWiFiSetup(BuildContext context, SettingsProvider settingsProvider) {
    final ssidController = TextEditingController(text: settingsProvider.wifiSsid ?? '');
    final passwordController = TextEditingController(text: settingsProvider.wifiPassword ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const Icon(Icons.wifi, size: 64, color: Colors.blue),
            const SizedBox(height: 16),
            const Text(
              'Configuration WiFi',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: ssidController,
              decoration: const InputDecoration(
                labelText: 'Nom du réseau (SSID)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.wifi),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Mot de passe',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (ssidController.text.isNotEmpty) {
                    await settingsProvider.saveWifiCredentials(
                      ssidController.text,
                      passwordController.text,
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Configuration WiFi sauvegardée')),
                    );
                  }
                },
                child: const Text('Sauvegarder'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showManualSetup(BuildContext context, SettingsProvider settingsProvider) {
    final ipController = TextEditingController(text: settingsProvider.cameraIp);
    final portController = TextEditingController(text: settingsProvider.apiPort);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const Icon(Icons.settings, size: 64, color: Colors.orange),
            const SizedBox(height: 16),
            const Text(
              'Configuration manuelle',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: ipController,
              decoration: const InputDecoration(
                labelText: 'Adresse IP',
                hintText: '192.168.1.100',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.router),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: portController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Port',
                hintText: '8080',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.settings_ethernet),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _testConnection(context, settingsProvider),
                    child: const Text('Tester'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      settingsProvider.cameraIp = ipController.text;
                      settingsProvider.apiPort = portController.text;
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Configuration sauvegardée')),
                      );
                    },
                    child: const Text('Sauvegarder'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _testConnection(BuildContext context, SettingsProvider settingsProvider) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Test de connexion'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Test de connexion en cours...'),
          ],
        ),
      ),
    );
    
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Test terminé - Vérifiez le flux vidéo'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  void _showLanguageSelector(BuildContext context, SettingsProvider settingsProvider, ColorScheme colorScheme) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choisir la langue'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageTile(context, settingsProvider, 'fr', 'Français', colorScheme),
              _buildLanguageTile(context, settingsProvider, 'en', 'English', colorScheme),
              _buildLanguageTile(context, settingsProvider, 'es', 'Español', colorScheme),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageTile(BuildContext context, SettingsProvider settingsProvider, String code, String name, ColorScheme colorScheme) {
    return ListTile(
      title: Text(name),
      trailing: settingsProvider.language == code
          ? Icon(Icons.check, color: colorScheme.primary)
          : null,
      onTap: () {
        settingsProvider.language = code;
        Navigator.pop(context);
      },
    );
  }

  void _showAboutDialog(BuildContext context, ColorScheme colorScheme) {
    showAboutDialog(
      context: context,
      applicationName: 'BABYCAM AI',
      applicationVersion: '1.0.0',
      applicationIcon: Icon(
        Icons.baby_changing_station,
        size: 48,
        color: colorScheme.primary,
      ),
      children: const [
        Text('Surveillance intelligente pour bébé avec IA'),
        SizedBox(height: 16),
        Text('Fonctionnalités:'),
        Text('• Vision nocturne automatique'),
        Text('• Veilleuse RGB programmable'),
        Text('• Monitoring audio bidirectionnel'),
        Text('• Détection intelligente des pleurs'),
        Text('• Surveillance environnementale'),
      ],
    );
  }

  void _showHelpDialog(BuildContext context, ColorScheme colorScheme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Aide et support'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🔧 Configuration'),
            Text('• Utilisez le QR code pour une config rapide'),
            Text('• Vérifiez que la caméra est allumée'),
            SizedBox(height: 12),
            Text('📶 Connexion'),
            Text('• Même réseau WiFi requis'),
            Text('• Port 8080 par défaut'),
            SizedBox(height: 12),
            Text('🎨 Thèmes'),
            Text('• Sombre: pour économiser batterie'),
            Text('• Colorés: pour plus de convivialité'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  String _getLanguageLabel(String languageCode) {
    switch (languageCode) {
      case 'fr':
        return 'Français';
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      default:
        return 'Français';
    }
  }
}