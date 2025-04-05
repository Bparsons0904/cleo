// lib/data/models/style.dart
class Style {
  final int id;
  final String name;

  Style({
    required this.id,
    required this.name,
  });

  factory Style.fromJson(Map<String, dynamic> json) {
    // Handle both string ID and integer ID cases
    return Style(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
