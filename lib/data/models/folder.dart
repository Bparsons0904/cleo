// lib/data/models/folder.dart
class Folder {
  final int id;
  final String name;
  final int count;
  final String resourceUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  Folder({
    required this.id,
    required this.name,
    required this.count,
    required this.resourceUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Folder.fromJson(Map<String, dynamic> json) {
    return Folder(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      count: json['count'] ?? 0,
      resourceUrl: json['resourceUrl'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'count': count,
      'resourceUrl': resourceUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
