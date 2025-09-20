// Data models for the SignBridge Flutter app

class TranscriptItem {
  final String id;
  final DateTime timestamp;
  final String text;
  final TranscriptType type;
  final double confidence;

  TranscriptItem({
    required this.id,
    required this.timestamp,
    required this.text,
    required this.type,
    required this.confidence,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'text': text,
      'type': type.name,
      'confidence': confidence,
    };
  }

  factory TranscriptItem.fromJson(Map<String, dynamic> json) {
    return TranscriptItem(
      id: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
      text: json['text'],
      type: TranscriptType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => TranscriptType.sign,
      ),
      confidence: json['confidence'].toDouble(),
    );
  }
}

enum TranscriptType { sign, speech }

class ARTextBubble {
  final String id;
  final String text;
  final BubblePosition position;
  final double opacity;
  final double scale;

  ARTextBubble({
    required this.id,
    required this.text,
    required this.position,
    this.opacity = 1.0,
    this.scale = 1.0,
  });

  ARTextBubble copyWith({
    String? id,
    String? text,
    BubblePosition? position,
    double? opacity,
    double? scale,
  }) {
    return ARTextBubble(
      id: id ?? this.id,
      text: text ?? this.text,
      position: position ?? this.position,
      opacity: opacity ?? this.opacity,
      scale: scale ?? this.scale,
    );
  }
}

class SignCard {
  final String id;
  final String word;
  final String description;
  final List<String> steps;
  final String? animationUrl;

  SignCard({
    required this.id,
    required this.word,
    required this.description,
    required this.steps,
    this.animationUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'word': word,
      'description': description,
      'steps': steps,
      'animationUrl': animationUrl,
    };
  }

  factory SignCard.fromJson(Map<String, dynamic> json) {
    return SignCard(
      id: json['id'],
      word: json['word'],
      description: json['description'],
      steps: List<String>.from(json['steps']),
      animationUrl: json['animationUrl'],
    );
  }
}

/// Helper class for positioning UI elements
class BubblePosition {
  final double x;
  final double y;

  const BubblePosition(this.x, this.y);

  static const BubblePosition zero = BubblePosition(0, 0);

  @override
  String toString() => 'BubblePosition($x, $y)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BubblePosition &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}
