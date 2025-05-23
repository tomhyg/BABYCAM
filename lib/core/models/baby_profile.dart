// lib/core/models/baby_profile.dart

class BabyProfile {
  final String name;
  final String skinTone;
  final String faceShape;
  final String eyeColor;
  final String hairStyle;
  final DateTime? birthDate;
  final String? notes;

  const BabyProfile({
    required this.name,
    this.skinTone = 'light',
    this.faceShape = 'round',
    this.eyeColor = 'blue',
    this.hairStyle = 'blonde',
    this.birthDate,
    this.notes,
  });

  factory BabyProfile.fromJson(Map<String, dynamic> json) {
    return BabyProfile(
      name: json['name'] ?? '',
      skinTone: json['skinTone'] ?? 'light',
      faceShape: json['faceShape'] ?? 'round',
      eyeColor: json['eyeColor'] ?? 'blue',
      hairStyle: json['hairStyle'] ?? 'blonde',
      birthDate: json['birthDate'] != null 
          ? DateTime.parse(json['birthDate'])
          : null,
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'skinTone': skinTone,
      'faceShape': faceShape,
      'eyeColor': eyeColor,
      'hairStyle': hairStyle,
      'birthDate': birthDate?.toIso8601String(),
      'notes': notes,
    };
  }

  BabyProfile copyWith({
    String? name,
    String? skinTone,
    String? faceShape,
    String? eyeColor,
    String? hairStyle,
    DateTime? birthDate,
    String? notes,
  }) {
    return BabyProfile(
      name: name ?? this.name,
      skinTone: skinTone ?? this.skinTone,
      faceShape: faceShape ?? this.faceShape,
      eyeColor: eyeColor ?? this.eyeColor,
      hairStyle: hairStyle ?? this.hairStyle,
      birthDate: birthDate ?? this.birthDate,
      notes: notes ?? this.notes,
    );
  }

  // Méthodes utilitaires pour l'avatar
  String get avatarEmoji {
    switch (skinTone) {
      case 'very_light':
        return '👶🏻';
      case 'light':
        return '👶🏼';
      case 'medium':
        return '👶🏽';
      case 'dark':
        return '👶🏾';
      case 'very_dark':
        return '👶🏿';
      default:
        return '👶';
    }
  }

  int? get ageInMonths {
    if (birthDate == null) return null;
    final now = DateTime.now();
    final difference = now.difference(birthDate!);
    return (difference.inDays / 30.44).floor(); // Moyenne de jours par mois
  }

  String get ageDisplay {
    final months = ageInMonths;
    if (months == null) return '';
    
    if (months < 12) {
      return '$months mois';
    } else {
      final years = months ~/ 12;
      final remainingMonths = months % 12;
      if (remainingMonths == 0) {
        return '$years an${years > 1 ? 's' : ''}';
      } else {
        return '$years an${years > 1 ? 's' : ''} et $remainingMonths mois';
      }
    }
  }

  @override
  String toString() {
    return 'BabyProfile(name: $name, age: $ageDisplay)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is BabyProfile &&
      other.name == name &&
      other.skinTone == skinTone &&
      other.faceShape == faceShape &&
      other.eyeColor == eyeColor &&
      other.hairStyle == hairStyle &&
      other.birthDate == birthDate &&
      other.notes == notes;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      skinTone.hashCode ^
      faceShape.hashCode ^
      eyeColor.hashCode ^
      hairStyle.hashCode ^
      birthDate.hashCode ^
      notes.hashCode;
  }
}

// Options de personnalisation disponibles
class BabyAvatarOptions {
  static const Map<String, String> skinTones = {
    'very_light': 'Très clair',
    'light': 'Clair',
    'medium': 'Moyen',
    'dark': 'Foncé',
    'very_dark': 'Très foncé',
  };

  static const Map<String, String> faceShapes = {
    'round': 'Rond',
    'oval': 'Ovale',
    'square': 'Carré',
    'heart': 'Cœur',
  };

  static const Map<String, String> eyeColors = {
    'blue': 'Bleu',
    'brown': 'Marron',
    'green': 'Vert',
    'hazel': 'Noisette',
    'gray': 'Gris',
  };

  static const Map<String, String> hairStyles = {
    'blonde': 'Blond',
    'brown': 'Châtain',
    'black': 'Noir',
    'red': 'Roux',
    'bald': 'Chauve',
  };

  // Couleurs pour l'interface
  static const Map<String, Color> skinToneColors = {
    'very_light': Color(0xFFFEF0E3),
    'light': Color(0xFFF7DDC0),
    'medium': Color(0xFFE8B896),
    'dark': Color(0xFFD08B5B),
    'very_dark': Color(0xFF8B4513),
  };

  static const Map<String, Color> eyeColorColors = {
    'blue': Color(0xFF4A90E2),
    'brown': Color(0xFF8B4513),
    'green': Color(0xFF50C878),
    'hazel': Color(0xFFA0522D),
    'gray': Color(0xFF708090),
  };

  static const Map<String, Color> hairStyleColors = {
    'blonde': Color(0xFFFFD700),
    'brown': Color(0xFF8B4513),
    'black': Color(0xFF2F2F2F),
    'red': Color(0xFFCD5C5C),
    'bald': Color(0xFFE8B896),
  };
}