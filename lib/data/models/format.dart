// lib/data/models/format.dart
class Format {
  final String name;
  final String description;
  final List<String> descriptions;
  final int qty;

  Format({
    required this.name,
    required this.description,
    required this.descriptions,
    required this.qty,
  });

  factory Format.fromJson(Map<String, dynamic> json) {
    return Format(
      name: json['name'],
      description: json['description'] ?? '',
      descriptions: (json['descriptions'] as List?)
          ?.map((desc) => desc.toString())
          .toList() ?? [],
      qty: json['qty'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'descriptions': descriptions,
      'qty': qty,
    };
  }
}
