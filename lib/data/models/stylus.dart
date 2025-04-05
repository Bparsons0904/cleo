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
    return Stylus(
      id: json['id'],
      name: json['name'],
      manufacturer: json['manufacturer'],
      expectedLifespan: json['expected_lifespan'],
      purchaseDate: json['purchase_date'] != null
          ? DateTime.parse(json['purchase_date'])
          : null,
      active: json['active'],
      primary: json['primary'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      owned: json['owned'],
      baseModel: json['base_model'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'manufacturer': manufacturer,
      'expected_lifespan': expectedLifespan,
      'purchase_date': purchaseDate?.toIso8601String(),
      'active': active,
      'primary': primary,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'owned': owned,
      'base_model': baseModel,
    };
  }
}
