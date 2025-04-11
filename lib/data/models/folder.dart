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
    try {
      print("Parsing folder: ${json['name']}");

      return Folder(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        count: json['count'] ?? 0,
        resourceUrl:
            json['resource_url'] ??
            json['resourceUrl'] ??
            '', // Handle both snake_case and camelCase
        createdAt: _parseDateTime(json['created_at'] ?? json['createdAt']),
        updatedAt: _parseDateTime(json['updated_at'] ?? json['updatedAt']),
      );
    } catch (e) {
      print("Error parsing folder: $e");
      // Return a minimal valid object to avoid null errors
      return Folder(
        id: json['id'] ?? 0,
        name: json['name'] ?? 'Unknown Folder',
        count: 0,
        resourceUrl: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }

  // Helper method to safely parse DateTime
  static DateTime _parseDateTime(dynamic dateValue) {
    if (dateValue == null) {
      return DateTime.now();
    }

    try {
      return DateTime.parse(dateValue.toString());
    } catch (e) {
      print('Error parsing date in Folder: $e');
      return DateTime.now();
    }
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
