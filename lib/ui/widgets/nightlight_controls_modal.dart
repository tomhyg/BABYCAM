// ============================================================================
// lib/ui/widgets/nightlight_controls_modal.dart (COMPLET)
// ============================================================================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_color_schemes.dart';
import '../../providers/nightlight_provider.dart';
import '../../providers/settings_provider.dart';

class NightlightControlsModal extends StatefulWidget {
  const NightlightControlsModal({Key? key}) : super(key: key);

  @override
  _NightlightControlsModalState createState() => _NightlightControlsModalState();
}

class _NightlightControlsModalState extends State<NightlightControlsModal> {
  String selectedColor = 'warm';
  double intensity = 50;

  @override
  void initState() {
    super.initState();
    final nightlightProvider = Provider.of<NightlightProvider>(context, listen: false);
    selectedColor = nightlightProvider.currentColor;
    intensity = nightlightProvider.intensity.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<SettingsProvider, NightlightProvider>(
      builder: (context, settings, nightlight, child) {
        final colors = settings.currentColors;
        final isDarkMode = settings.darkMode;
        
        return Container(
          decoration: BoxDecoration(
            color: isDarkMode ? colors['surface'] : Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.white38 : Colors.black26,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Titre
                  Row(
                    children: [
                      const Text(
                        '🌙',
                        style: TextStyle(fontSize: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Contrôles Veilleuse',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.close,
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Sélecteur de couleurs
                  _buildColorPicker(colors, isDarkMode),
                  const SizedBox(height: 32),

                  // Contrôle d'intensité
                  _buildIntensityControl(colors, isDarkMode),
                  const SizedBox(height: 32),

                  // Boutons d'action
                  _buildActionButtons(colors, isDarkMode),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildColorPicker(Map<String, Color> themeColors, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Couleur',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemCount: AppColorSchemes.nightlightColors.length,
          itemBuilder: (context, index) {
            final colorKey = AppColorSchemes.nightlightColors.keys.elementAt(index);
            final colors = AppColorSchemes.nightlightColors[colorKey]!;
            final isSelected = selectedColor == colorKey;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedColor = colorKey;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: colors,
                  ),
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(color: Colors.white, width: 3)
                      : null,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.5),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 24,
                      )
                    : null,
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        // Nom de la couleur sélectionnée
        Consumer<NightlightProvider>(
          builder: (context, nightlight, child) {
            return Center(
              child: Text(
                nightlight.getColorName(selectedColor),
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildIntensityControl(Map<String, Color> colors, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Intensité',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: colors['primary'],
            inactiveTrackColor: isDarkMode 
                ? Colors.white.withOpacity(0.2)
                : Colors.black.withOpacity(0.2),
            thumbColor: colors['primary'],
            overlayColor: colors['primary']!.withOpacity(0.2),
            trackHeight: 6,
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 12,
            ),
          ),
          child: Slider(
            value: intensity,
            min: 1,
            max: 100,
            divisions: 99,
            onChanged: (value) {
              setState(() {
                intensity = value;
              });
            },
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            '${intensity.round()}%',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colors['primary'],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(Map<String, Color> colors, bool isDarkMode) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: isDarkMode ? Colors.white70 : Colors.black54,
              side: BorderSide(
                color: isDarkMode 
                    ? Colors.white.withOpacity(0.3)
                    : Colors.black.withOpacity(0.3),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Annuler'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _applySettings,
            style: ElevatedButton.styleFrom(
              backgroundColor: colors['primary'],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Appliquer'),
          ),
        ),
      ],
    );
  }

  void _applySettings() {
    final nightlightProvider = Provider.of<NightlightProvider>(context, listen: false);
    
    nightlightProvider.updateSettings(
      color: selectedColor,
      intensity: intensity.round(),
      enabled: true,
    );

    Navigator.pop(context);

    // Afficher confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Veilleuse: ${nightlightProvider.getColorName(selectedColor)} à ${intensity.round()}%',
        ),
        backgroundColor: Provider.of<SettingsProvider>(context, listen: false).currentColors['primary'],
      ),
    );
  }
}
