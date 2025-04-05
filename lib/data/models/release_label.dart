// lib/data/models/release_label.dart
class ReleaseLabel {
  final int id;
  final String name;
  final String catno;
  final String resourceUrl;

  ReleaseLabel({
    required this.id,
    required this.name,
    required this.catno,
    required this.resourceUrl,
  });

  factory ReleaseLabel.fromJson(Map<String, dynamic> json) {
    return ReleaseLabel(
      id: json['id'],
      name: json['name'],
      catno: json['catno'] ?? '',
      resourceUrl: json['resource_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'catno': catno,
      'resource_url': resourceUrl,
    };
  }
}
