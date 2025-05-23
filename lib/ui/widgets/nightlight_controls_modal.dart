// lib/ui/widgets/nightlight_controls_modal.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';  // ✅ Import corrigé
import '../../providers/nightlight_provider.dart';

class NightlightControlsModal extends StatefulWidget {
  const NightlightControlsModal({Key? key}) : super(key: key);

  @override
  _NightlightControlsModalState createState() => _NightlightControlsModalState();
}

class _NightlightControlsModalState extends State<NightlightControlsModal> {
  late String _selectedColor;
  late int _selectedIntensity;
  DateTime? _scheduledOff;

  @override
  void initState() {
    super.initState();
    final nightlightProvider = Provider.of<NightlightProvider>(context, listen: false);
    _selectedColor = nightlightProvider.currentColor;
    _selectedIntensity = nightlightProvider.intensity;
    _scheduledOff = nightlightProvider.settings.scheduledOff;
  }

  @override
  Widget build(BuildContext context) {
    final nightlightProvider = Provider.of<NightlightProvider>(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Contrôles Veilleuse',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Interrupteur principal
          SwitchListTile(
            title: const Text('Veilleuse'),
            subtitle: Text(nightlightProvider.settingsSummary),
            value: nightlightProvider.isEnabled,
            onChanged: (value) async {
              await nightlightProvider.toggle();
            },
            activeColor: AppColors.primary,  // ✅ Corrigé
          ),

          if (nightlightProvider.isEnabled) ...[
            const Divider(),

            // Sélection de couleur
            const Text(
              'Couleur',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: AppColors.nightlightColors.length,  // ✅ Corrigé
                itemBuilder: (context, index) {
                  final colorKey = AppColors.nightlightColors.keys.elementAt(index);  // ✅ Corrigé
                  final colors = AppColors.nightlightColors[colorKey]!;  // ✅ Corrigé
                  final isSelected = _selectedColor == colorKey;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor = colorKey;
                      });
                      nightlightProvider.updateSettings(color: colorKey);
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: colors,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? AppColors.primary : Colors.grey.shade300,  // ✅ Corrigé
                          width: isSelected ? 3 : 1,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 20,
                            )
                          : null,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Contrôle d'intensité
            const Text(
              'Intensité',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.brightness_low, size: 20),
                Expanded(
                  child: Slider(
                    value: _selectedIntensity.toDouble(),
                    min: 10,
                    max: 100,
                    divisions: 9,
                    label: '$_selectedIntensity%',
                    activeColor: AppColors.primary,  // ✅ Corrigé
                    onChanged: (value) {
                      setState(() {
                        _selectedIntensity = value.round();
                      });
                    },
                    onChangeEnd: (value) {
                      nightlightProvider.updateSettings(intensity: value.round());
                    },
                  ),
                ),
                const Icon(Icons.brightness_high, size: 20),
              ],
            ),

            const SizedBox(height: 20),

            // Programmation d'extinction
            const Text(
              'Extinction programmée',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            if (nightlightProvider.hasScheduledOff) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),  // ✅ Corrigé
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.schedule, color: AppColors.primary),  // ✅ Corrigé
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Extinction dans ${nightlightProvider.timeUntilOff?.inMinutes ?? 0} minutes',
                        style: TextStyle(color: AppColors.primary),  // ✅ Corrigé
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        nightlightProvider.cancelScheduledOff();
                        setState(() {
                          _scheduledOff = null;
                        });
                      },
                      icon: const Icon(Icons.close, size: 20),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showTimePicker(context, nightlightProvider),
                      icon: const Icon(Icons.schedule),
                      label: const Text('Programmer extinction'),
                    ),
                  ),
                ],
              ),
            ],
          ],

          const SizedBox(height: 20),

          // Boutons d'action
          Row(
            children: [
              if (nightlightProvider.isEnabled)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      nightlightProvider.deactivate();
                      Navigator.pop(context);
                    },
                    child: const Text('Éteindre'),
                  ),
                ),
              if (nightlightProvider.isEnabled) const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,  // ✅ Corrigé
                  ),
                  child: const Text('Fermer'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showTimePicker(BuildContext context, NightlightProvider provider) async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      final now = DateTime.now();
      final scheduledDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );

      // Si l'heure est déjà passée aujourd'hui, programmer pour demain
      final finalDateTime = scheduledDateTime.isBefore(now)
          ? scheduledDateTime.add(const Duration(days: 1))
          : scheduledDateTime;

      await provider.scheduleOff(finalDateTime);
      setState(() {
        _scheduledOff = finalDateTime;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Extinction programmée à ${time.format(context)}',
            ),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }
}