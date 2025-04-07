// lib/data/models/artist.dart
class Artist {
  final int id;
  final String name;
  final String resourceUrl;

  Artist({
    required this.id,
    required this.name,
    required this.resourceUrl,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      resourceUrl: json['resource_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'resource_url': resourceUrl,
    };
  }
}
