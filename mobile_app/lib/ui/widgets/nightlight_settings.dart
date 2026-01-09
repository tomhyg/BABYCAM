// ============================================================================
// MODIFICATIONS DES MODÈLES EXISTANTS
// ============================================================================

// lib/core/models/nightlight_settings.dart (NOUVEAU)
class NightlightSettings {
  final bool enabled;
  final String color;
  final int intensity;
  final DateTime? scheduledOff;

  const NightlightSettings({
    this.enabled = false,
    this.color = 'warm',
    this.intensity = 50,
    this.scheduledOff,
  });

  NightlightSettings copyWith({
    bool? enabled,
    String? color,
    int? intensity,
    DateTime? scheduledOff,
  }) {
    return NightlightSettings(
      enabled: enabled ?? this.enabled,
      color: color ?? this.color,
      intensity: intensity ?? this.intensity,
      scheduledOff: scheduledOff ?? this.scheduledOff,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'color': color,
      'intensity': intensity,
      'scheduledOff': scheduledOff?.toIso8601String(),
    };
  }

  factory NightlightSettings.fromJson(Map<String, dynamic> json) {
    return NightlightSettings(
      enabled: json['enabled'] ?? false,
      color: json['color'] ?? 'warm',
      intensity: json['intensity'] ?? 50,
      scheduledOff: json['scheduledOff'] != null 
          ? DateTime.parse(json['scheduledOff'])
          : null,
    );
  }
}
