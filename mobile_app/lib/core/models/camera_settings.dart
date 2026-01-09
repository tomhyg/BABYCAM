class CameraSettings {
  final bool nightVisionEnabled;
  final int brightness;
  final int contrast;
  final bool motionDetectionEnabled;
  final int motionSensitivity;
  final bool audioDetectionEnabled;
  final int audioSensitivity;
  final bool nightLightEnabled;
  final int nightLightBrightness;
  final String resolution; // "HD", "FHD", etc.
  final int frameRate;

  CameraSettings({
    this.nightVisionEnabled = true,
    this.brightness = 50,
    this.contrast = 50,
    this.motionDetectionEnabled = true,
    this.motionSensitivity = 50,
    this.audioDetectionEnabled = true,
    this.audioSensitivity = 50,
    this.nightLightEnabled = false,
    this.nightLightBrightness = 30,
    this.resolution = "HD",
    this.frameRate = 15,
  });

  factory CameraSettings.fromJson(Map<String, dynamic> json) {
    return CameraSettings(
      nightVisionEnabled: json['nightVisionEnabled'] ?? true,
      brightness: json['brightness'] ?? 50,
      contrast: json['contrast'] ?? 50,
      motionDetectionEnabled: json['motionDetectionEnabled'] ?? true,
      motionSensitivity: json['motionSensitivity'] ?? 50,
      audioDetectionEnabled: json['audioDetectionEnabled'] ?? true,
      audioSensitivity: json['audioSensitivity'] ?? 50,
      nightLightEnabled: json['nightLightEnabled'] ?? false,
      nightLightBrightness: json['nightLightBrightness'] ?? 30,
      resolution: json['resolution'] ?? "HD",
      frameRate: json['frameRate'] ?? 15,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nightVisionEnabled': nightVisionEnabled,
      'brightness': brightness,
      'contrast': contrast,
      'motionDetectionEnabled': motionDetectionEnabled,
      'motionSensitivity': motionSensitivity,
      'audioDetectionEnabled': audioDetectionEnabled,
      'audioSensitivity': audioSensitivity,
      'nightLightEnabled': nightLightEnabled,
      'nightLightBrightness': nightLightBrightness,
      'resolution': resolution,
      'frameRate': frameRate,
    };
  }

  CameraSettings copyWith({
    bool? nightVisionEnabled,
    int? brightness,
    int? contrast,
    bool? motionDetectionEnabled,
    int? motionSensitivity,
    bool? audioDetectionEnabled,
    int? audioSensitivity,
    bool? nightLightEnabled,
    int? nightLightBrightness,
    String? resolution,
    int? frameRate,
  }) {
    return CameraSettings(
      nightVisionEnabled: nightVisionEnabled ?? this.nightVisionEnabled,
      brightness: brightness ?? this.brightness,
      contrast: contrast ?? this.contrast,
      motionDetectionEnabled: motionDetectionEnabled ?? this.motionDetectionEnabled,
      motionSensitivity: motionSensitivity ?? this.motionSensitivity,
      audioDetectionEnabled: audioDetectionEnabled ?? this.audioDetectionEnabled,
      audioSensitivity: audioSensitivity ?? this.audioSensitivity,
      nightLightEnabled: nightLightEnabled ?? this.nightLightEnabled,
      nightLightBrightness: nightLightBrightness ?? this.nightLightBrightness,
      resolution: resolution ?? this.resolution,
      frameRate: frameRate ?? this.frameRate,
    );
  }
}
