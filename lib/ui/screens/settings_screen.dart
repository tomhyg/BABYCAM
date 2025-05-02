import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';

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
      ),
      body: ListView(
        children: [
          const _SectionHeader(title: 'Connexion à la caméra'),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Champ adresse IP
                TextField(
                  controller: ipController,
                  decoration: const InputDecoration(
                    labelText: 'Adresse IP de la caméra',
                    hintText: 'ex: 192.168.1.100',
                    border: OutlineInputBorder(),
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
                  decoration: const InputDecoration(
                    labelText: 'Port HTTP',
                    hintText: 'ex: 80',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    settingsProvider.apiPort = value;
                  },
                ),
                const SizedBox(height: 16),
                
                // Bouton Tester la connexion
                ElevatedButton.icon(
                  onPressed: () {
                    _testConnection(context, settingsProvider.fullCameraStreamUrl);
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('Tester la connexion'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(),
          
          const _SectionHeader(title: 'Caméra'),
          ListTile(
            leading: const Icon(Icons.videocam),
            title: const Text('Paramètres de la caméra'),
            subtitle: const Text('Résolution, qualité d\'image, etc.'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Ouvrir l'écran des paramètres de la caméra
            },
          ),
          const Divider(),
          
          const _SectionHeader(title: 'Notifications'),
          SwitchListTile(
            title: const Text('Notifications activées'),
            subtitle: const Text('Recevoir des alertes pour les événements'),
            value: settingsProvider.notificationsEnabled,
            onChanged: (value) {
              settingsProvider.notificationsEnabled = value;
            },
          ),
          const Divider(),
          
          const _SectionHeader(title: 'Application'),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Langue'),
            subtitle: Text(_getLanguageLabel(settingsProvider.language)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showLanguageSelector(context, settingsProvider);
            },
          ),
          SwitchListTile(
            title: const Text('Thème sombre'),
            value: settingsProvider.darkMode,
            onChanged: (value) {
              settingsProvider.darkMode = value;
            },
          ),
          const Divider(),
          
          const _SectionHeader(title: 'Informations ESP32-CAM'),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('URL du flux vidéo'),
            subtitle: Text(settingsProvider.fullCameraStreamUrl),
          ),
          ListTile(
            leading: const Icon(Icons.web),
            title: const Text('Interface Web ESP32-CAM'),
            subtitle: Text('http://${settingsProvider.cameraIp}'),
            trailing: const Icon(Icons.open_in_browser),
            onTap: () {
              // Ouvrir l'URL dans le navigateur (vous auriez besoin d'un plugin comme url_launcher)
            },
          ),
          const Divider(),
          
          const _SectionHeader(title: 'À propos'),
          const ListTile(
            leading: Icon(Icons.info),
            title: Text('Version'),
            subtitle: Text('1.0.0'),
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Aide et support'),
            onTap: () {
              // Ouvrir la page d'aide
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
  
  void _testConnection(BuildContext context, String url) {
    // Cette fonction pourrait utiliser un package HTTP pour tester si l'URL est accessible
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Test de connexion'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text('Tentative de connexion à: $url'),
            const SizedBox(height: 8),
            const Text('Vérifiez que votre ESP32-CAM est allumé et connecté au même réseau WiFi.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
    
    // Vous pouvez implémenter un vrai test de connexion avec http.get
    // et afficher le résultat après quelques secondes
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pour un test réel, utilisez le bouton Play sur l\'écran de la caméra'),
          duration: Duration(seconds: 5),
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
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () {
                  settingsProvider.language = 'fr';
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('English'),
                trailing: settingsProvider.language == 'en'
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () {
                  settingsProvider.language = 'en';
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Español'),
                trailing: settingsProvider.language == 'es'
                    ? const Icon(Icons.check, color: Colors.green)
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
}

class _SectionHeader extends StatelessWidget {
  final String title;
  
  const _SectionHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
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