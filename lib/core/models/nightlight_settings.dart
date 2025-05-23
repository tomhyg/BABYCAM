// lib/core/models/nightlight_settings.dart

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

  factory NightlightSettings.fromJson(Map<String, dynamic> json) {
    return NightlightSettings(
      enabled: json['enabled'] as bool? ?? false,
      color: json['color'] as String? ?? 'warm',
      intensity: json['intensity'] as int? ?? 50,
      scheduledOff: json['scheduledOff'] != null 
          ? DateTime.parse(json['scheduledOff'] as String)
          : null,
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

  @override
  String toString() {
    return 'NightlightSettings(enabled: $enabled, color: $color, intensity: $intensity, scheduledOff: $scheduledOff)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is NightlightSettings &&
      other.enabled == enabled &&
      other.color == color &&
      other.intensity == intensity &&
      other.scheduledOff == scheduledOff;
  }

  @override
  int get hashCode {
    return enabled.hashCode ^
      color.hashCode ^
      intensity.hashCode ^
      scheduledOff.hashCode;
  }
}