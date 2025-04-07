// lib/data/models/label.dart
class Label {
  final int id;
  final String name;
  final String resourceUrl;
  final String entityType;

  Label({
    required this.id,
    required this.name,
    required this.resourceUrl,
    required this.entityType,
  });

  factory Label.fromJson(Map<String, dynamic> json) {
    // Add simple debug printing
    print("Parsing Label: ${json['name']}");
    
    return Label(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      // Handle potentially null string values
      resourceUrl: (json['resourceUrl'] ?? '').toString(),
      entityType: (json['entityType'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'resourceUrl': resourceUrl,
      'entityType': entityType,
    };
  }
}

// lib/data/models/release_label.dart
class ReleaseLabel {
  final int releaseId;
  final int labelId;
  final String catno;
  final Label? label;

  ReleaseLabel({
    required this.releaseId,
    required this.labelId,
    required this.catno,
    this.label,
  });

  factory ReleaseLabel.fromJson(Map<String, dynamic> json) {
    // Add simple debug printing
    print("Parsing ReleaseLabel with catno: ${json['catno']}");
    
    return ReleaseLabel(
      releaseId: json['releaseId'] ?? 0,
      labelId: json['labelId'] ?? 0,
      catno: json['catno'] ?? '',
      label: json['label'] != null ? Label.fromJson(json['label']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'releaseId': releaseId,
      'labelId': labelId,
      'catno': catno,
      'label': label?.toJson(),
    };
  }
}
