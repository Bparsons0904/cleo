// lib/data/models/edit_item.dart
class EditItem {
  final int id;
  final String type; // 'play' or 'cleaning'
  final DateTime date;
  final String? notes;
  final String? stylus;
  final int? stylusId;
  final int releaseId;

  EditItem({
    required this.id,
    required this.type,
    required this.date,
    this.notes,
    this.stylus,
    this.stylusId,
    required this.releaseId,
  });

  factory EditItem.fromJson(Map<String, dynamic> json) {
    return EditItem(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      date: DateTime.parse(json['date']),
      notes: json['notes'] ?? '',
      stylus: json['stylus'] ?? '',
      stylusId: json['stylus_id'] ?? 0,
      releaseId: json['release_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'date': date.toIso8601String(),
      'notes': notes,
      'stylus': stylus,
      'stylus_id': stylusId,
      'release_id': releaseId,
    };
  }
}
