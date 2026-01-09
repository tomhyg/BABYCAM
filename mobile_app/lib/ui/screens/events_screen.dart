import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/camera_provider.dart';
import '../../providers/ai_analysis_provider.dart';
import '../../core/models/baby_event.dart';
import '../theme/app_colors.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({Key? key}) : super(key: key);

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final cameraProvider = Provider.of<CameraProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Événements'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Tous'),
            Tab(text: 'Pleurs'),
            Tab(text: 'Mouvements'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tous les événements
          _buildEventList(
            cameraProvider.events,
            'Aucun événement enregistré',
          ),
          // Pleurs seulement
          _buildEventList(
            cameraProvider.events.where((e) => e.type == 'cry').toList(),
            'Aucun pleur détecté',
          ),
          // Mouvements seulement
          _buildEventList(
            cameraProvider.events.where((e) => e.type == 'movement').toList(),
            'Aucun mouvement détecté',
          ),
        ],
      ),
    );
  }
  
  Widget _buildEventList(List<BabyEvent> events, String emptyMessage) {
    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.event_busy, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: ListTile(
            leading: _getEventIcon(event.type),
            title: Text(_getEventTitle(event.type)),
            subtitle: Text(_formatDateTime(event.timestamp)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showEventDetails(event),
          ),
        );
      },
    );
  }
  
  Widget _getEventIcon(String type) {
    switch (type) {
      case 'cry':
        return const CircleAvatar(
          backgroundColor: Colors.red,
          child: Icon(Icons.volume_up, color: Colors.white),
        );
      case 'movement':
        return const CircleAvatar(
          backgroundColor: Colors.orange,
          child: Icon(Icons.directions_run, color: Colors.white),
        );
      case 'face_detected':
        return const CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(Icons.face, color: Colors.white),
        );
      default:
        return const CircleAvatar(
          backgroundColor: Colors.grey,
          child: Icon(Icons.event, color: Colors.white),
        );
    }
  }
  
  String _getEventTitle(String type) {
    switch (type) {
      case 'cry':
        return 'Pleurs détectés';
      case 'movement':
        return 'Mouvement détecté';
      case 'face_detected':
        return 'Visage détecté';
      default:
        return 'Événement inconnu';
    }
  }
  
  String _formatDateTime(DateTime datetime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final eventDate = DateTime(datetime.year, datetime.month, datetime.day);
    
    String dateStr;
    if (eventDate == today) {
      dateStr = 'Aujourd\'hui';
    } else if (eventDate == today.subtract(const Duration(days: 1))) {
      dateStr = 'Hier';
    } else {
      dateStr = '${datetime.day.toString().padLeft(2, '0')}/${datetime.month.toString().padLeft(2, '0')}/${datetime.year}';
    }
    
    final timeStr = '${datetime.hour.toString().padLeft(2, '0')}:${datetime.minute.toString().padLeft(2, '0')}';
    
    return '$dateStr à $timeStr';
  }
  
  void _showEventDetails(BabyEvent event) {
    if (event.type == 'cry') {
      _showCryAnalysisDialog(event);
    } else {
      // Affichage normal des événements de mouvement ou autres
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(_getEventTitle(event.type)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Date: ${_formatDateTime(event.timestamp)}'),
              if (event.imageUrl != null) ...[
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    event.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                  ),
                ),
              ],
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
  }

  void _showCryAnalysisDialog(BabyEvent event) {
    final aiProvider = Provider.of<AIAnalysisProvider>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (context) => FutureBuilder<Map<String, dynamic>>(
        future: event.metadata?['audioId'] != null 
            ? aiProvider.analyzeCry(event.metadata!['audioId'])
            : Future.value({'error': 'Aucun audio disponible pour analyse'}),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const AlertDialog(
              title: Text('Analyse des pleurs'),
              content: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Analyse en cours...'),
                  ],
                ),
              ),
            );
          }
          
          if (snapshot.hasError || !snapshot.hasData) {
            return AlertDialog(
              title: const Text('Analyse des pleurs'),
              content: Text('Erreur lors de l\'analyse: ${snapshot.error ?? 'Données non disponibles'}'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Fermer'),
                ),
              ],
            );
          }
          
          final analysis = snapshot.data!;
          final cryType = analysis['type'] ?? 'inconnu';
          final confidence = analysis['confidence'] ?? 0.0;
          final recommendation = analysis['recommendation'] ?? 'Aucune recommandation disponible';
          
          return AlertDialog(
            title: const Text('Analyse des pleurs'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Date: ${_formatDateTime(event.timestamp)}'),
                const SizedBox(height: 16),
                Text(
                  'Type de pleurs: ${_getCryTypeLabel(cryType)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: confidence,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
                const SizedBox(height: 4),
                Text('Confiance: ${(confidence * 100).toStringAsFixed(0)}%'),
                const SizedBox(height: 16),
                const Text(
                  'Recommandation:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(recommendation),
                
                if (analysis['alternatives'] != null) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Autres possibilités:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...List.generate(
                    (analysis['alternatives'] as List).length, 
                    (index) {
                      final alt = analysis['alternatives'][index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Row(
                          children: [
                            Text(_getCryTypeLabel(alt['type'])),
                            const Spacer(),
                            Text('${(alt['confidence'] * 100).toStringAsFixed(0)}%'),
                          ],
                        ),
                      );
                    }
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Fermer'),
              ),
            ],
          );
        },
      ),
    );
  }

  String _getCryTypeLabel(String type) {
    switch (type) {
      case 'hunger':
        return 'Faim';
      case 'discomfort':
        return 'Inconfort';
      case 'pain':
        return 'Douleur';
      case 'fatigue':
        return 'Fatigue';
      case 'boredom':
        return 'Ennui';
      case 'fear':
        return 'Peur';
      case 'colic':
        return 'Colique';
      default:
        return 'Inconnu';
    }
  }
}