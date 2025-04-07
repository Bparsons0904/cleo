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
    try {
      print("Parsing Label");
      print("Label JSON: $json");
      
      // Check each field individually
      final id = json['id'];
      print("Label.id: $id (${id.runtimeType})");
      
      final name = json['name'];
      print("Label.name: $name (${name.runtimeType})");
      
      final resourceUrl = json['resourceUrl'];
      print("Label.resourceUrl: $resourceUrl (${resourceUrl?.runtimeType})");
      
      final entityType = json['entityType'];
      print("Label.entityType: $entityType (${entityType?.runtimeType})");
      
      return Label(
        id: id ?? 0,
        name: name ?? '',
        resourceUrl: resourceUrl?.toString() ?? '',
        entityType: entityType?.toString() ?? '',
      );
    } catch (e) {
      print("ERROR parsing Label: $e");
      rethrow;
    }
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
