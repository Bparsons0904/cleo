// lib/data/models/stylus.dart
class Stylus {
  final int id;
  final String name;
  final String? manufacturer;
  final int? expectedLifespan;
  final DateTime? purchaseDate;
  final bool active;
  final bool primary;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool owned;
  final bool baseModel;

  Stylus({
    required this.id,
    required this.name,
    this.manufacturer,
    this.expectedLifespan,
    this.purchaseDate,
    required this.active,
    required this.primary,
    required this.createdAt,
    required this.updatedAt,
    required this.owned,
    required this.baseModel,
  });

  factory Stylus.fromJson(Map<String, dynamic> json) {
    // Add debug printing
    print("Parsing Stylus: ${json['name']}");
    print("Raw expectedLifespan: ${json['expectedLifespan']}");
    print("Raw purchaseDate: ${json['purchaseDate']}");

    return Stylus(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      manufacturer: json['manufacturer'], // Already nullable
      expectedLifespan: json['expectedLifespan'], // Note: camelCase key
      purchaseDate:
          json['purchaseDate'] != null
              ? DateTime.parse(json['purchaseDate'])
              : null,
      active: json['active'] ?? false,
      primary: json['primary'] ?? false,
      createdAt: _parseDateTime(json['createdAt']),
      updatedAt: _parseDateTime(json['updatedAt']),
      owned: json['owned'] ?? true,
      baseModel: json['baseModel'] ?? false,
    );
  }

  // Helper method for safely parsing DateTime
  static DateTime _parseDateTime(dynamic dateValue) {
    if (dateValue == null) {
      return DateTime.now();
    }

    try {
      return DateTime.parse(dateValue.toString());
    } catch (e) {
      print("Error parsing date: $e");
      return DateTime.now();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'manufacturer': manufacturer,
      'expectedLifespan': expectedLifespan,
      'purchaseDate': purchaseDate?.toIso8601String(),
      'active': active,
      'primary': primary,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'owned': owned,
      'baseModel': baseModel,
    };
  }
}
