class BabyEvent {
  final String id;
  final String type; // cry, movement, face_detected, etc.
  final DateTime timestamp;
  final String? imageUrl;
  final Map<String, dynamic>? metadata;

  BabyEvent({
    required this.id,
    required this.type,
    required this.timestamp,
    this.imageUrl,
    this.metadata,
  });

  factory BabyEvent.fromJson(Map<String, dynamic> json) {
    return BabyEvent(
      id: json['id'],
      type: json['type'],
      timestamp: DateTime.parse(json['timestamp']),
      imageUrl: json['imageUrl'],
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'timestamp': timestamp.toIso8601String(),
      'imageUrl': imageUrl,
      'metadata': metadata,
    };
  }
}
