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
      id: json['id'],
      name: json['name'],
      count: json['count'],
      resourceUrl: json['resource_url'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'count': count,
      'resource_url': resourceUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
