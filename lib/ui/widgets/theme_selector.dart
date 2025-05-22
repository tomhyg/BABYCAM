import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_color_schemes.dart';
import '../../providers/settings_provider.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mode sombre/clair
            Card(
              child: SwitchListTile(
                title: const Text(
                  'Mode sombre',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: const Text('Interface sombre pour protéger vos yeux'),
                value: settings.darkMode,
                onChanged: (value) => settings.setDarkMode(value),
                secondary: Icon(
                  settings.darkMode ? Icons.dark_mode : Icons.light_mode,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Titre section couleurs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Palette de couleurs',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Grille des palettes de couleurs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2.5,
                ),
                itemCount: ColorSchemeType.values.length,
                itemBuilder: (context, index) {
                  final type = ColorSchemeType.values[index];
                  final colors = AppColorSchemes.getColorScheme(type);
                  final isSelected = settings.colorScheme == type;
                  
                  return GestureDetector(
                    onTap: () => settings.setColorScheme(type),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected 
                              ? colors['primary']! 
                              : Colors.grey.withOpacity(0.3),
                          width: isSelected ? 3 : 1,
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            colors['primary']!,
                            colors['secondary']!,
                          ],
                        ),
                        boxShadow: isSelected ? [
                          BoxShadow(
                            color: colors['primary']!.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ] : null,
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  AppColorSchemes.getThemeIcon(type),
                                  color: Colors.white,
                                  size: 24,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  AppColorSchemes.getThemeName(type),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  AppColorSchemes.getThemeDescription(type),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 10,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check,
                                  color: colors['primary'],
                                  size: 16,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Aperçu des couleurs sélectionnées
            Consumer<SettingsProvider>(
              builder: (context, settings, child) {
                final colors = AppColorSchemes.getColorScheme(settings.colorScheme);
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Aperçu des couleurs',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildColorPreview('Principale', colors['primary']!),
                            const SizedBox(width: 12),
                            _buildColorPreview('Secondaire', colors['secondary']!),
                            const SizedBox(width: 12),
                            _buildColorPreview('Accent', colors['accent']!),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildColorPreview(String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
