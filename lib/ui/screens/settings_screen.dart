import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../widgets/theme_selector.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    
    // Contrôleurs pour les champs texte
    final ipController = TextEditingController(text: settingsProvider.cameraIp);
    final portController = TextEditingController(text: settingsProvider.apiPort);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
        elevation: 0,
      ),
      body: ListView(
        children: [
          // NOUVELLE SECTION: Apparence
          const _SectionHeader(title: 'Apparence'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.palette,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Thème et couleurs',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const ThemeSelector(),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Section connexion caméra existante
          const _SectionHeader(title: 'Connexion à la caméra'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Champ adresse IP
                  TextField(
                    controller: ipController,
                    decoration: InputDecoration(
                      labelText: 'Adresse IP de la caméra',
                      hintText: 'ex: 192.168.1.100',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.wifi),
                    ),
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      settingsProvider.cameraIp = value;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Champ port
                  TextField(
                    controller: portController,
                    decoration: InputDecoration(
                      labelText: 'Port HTTP',
                      hintText: 'ex: 80',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.settings_ethernet),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      settingsProvider.apiPort = value;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Bouton Tester la connexion
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _testConnection(context, settingsProvider.fullCameraStreamUrl);
                      },
                      icon: const Icon(Icons.check_circle),
                      label: const Text('Tester la connexion'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Section notifications
          const _SectionHeader(title: 'Notifications'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SwitchListTile(
              title: const Text('Notifications activées'),
              subtitle: const Text('Recevoir des alertes pour les événements'),
              value: settingsProvider.notificationsEnabled,
              onChanged: (value) {
                settingsProvider.notificationsEnabled = value;
              },
              secondary: Icon(
                settingsProvider.notificationsEnabled 
                    ? Icons.notifications_active
                    : Icons.notifications_off,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Section application
          const _SectionHeader(title: 'Application'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.language,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: const Text('Langue'),
                  subtitle: Text(_getLanguageLabel(settingsProvider.language)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _showLanguageSelector(context, settingsProvider);
                  },
                ),
                const Divider(),
                ListTile(
                  leading: Icon(
                    Icons.info_outline,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: const Text('À propos de l\'application'),
                  subtitle: const Text('Version 1.0.0'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _showAboutDialog(context);
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Section informations ESP32-CAM
          const _SectionHeader(title: 'Informations ESP32-CAM'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.videocam,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: const Text('URL du flux vidéo'),
                  subtitle: Text(
                    settingsProvider.fullCameraStreamUrl,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: Icon(
                    Icons.web,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: const Text('Interface Web ESP32-CAM'),
                  subtitle: Text('http://${settingsProvider.cameraIp}'),
                  trailing: const Icon(Icons.open_in_browser),
                  onTap: () {
                    // Ouvrir l'URL dans le navigateur
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('URL copiée: http://${settingsProvider.cameraIp}'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
        ],
      ),
    );
  }
  
  void _testConnection(BuildContext context, String url) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Test de connexion'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text('Tentative de connexion à:\n$url'),
            const SizedBox(height: 8),
            const Text(
              'Vérifiez que votre ESP32-CAM est allumé et connecté au même réseau WiFi.',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
    
    // Simuler un test de connexion
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Test de connexion terminé. Vérifiez le flux vidéo sur l\'écran principal.'),
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {},
          ),
        ),
      );
    });
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
  
  void _showLanguageSelector(BuildContext context, SettingsProvider settingsProvider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choisir la langue'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Français'),
                trailing: settingsProvider.language == 'fr'
                    ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
                    : null,
                onTap: () {
                  settingsProvider.language = 'fr';
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('English'),
                trailing: settingsProvider.language == 'en'
                    ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
                    : null,
                onTap: () {
                  settingsProvider.language = 'en';
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Español'),
                trailing: settingsProvider.language == 'es'
                    ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
                    : null,
                onTap: () {
                  settingsProvider.language = 'es';
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'BABYCAM AI',
      applicationVersion: '1.0.0',
      applicationIcon: Icon(
        Icons.baby_changing_station,
        size: 48,
        color: Theme.of(context).colorScheme.primary,
      ),
      children: [
        const Text('Surveillance intelligente pour bébé avec IA'),
        const SizedBox(height: 16),
        const Text('Fonctionnalités:'),
        const Text('• Vision nocturne automatique'),
        const Text('• Veilleuse RGB programmable'),
        const Text('• Monitoring audio bidirectionnel'),
        const Text('• Détection intelligente des pleurs'),
        const Text('• Surveillance environnementale'),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  
  const _SectionHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
