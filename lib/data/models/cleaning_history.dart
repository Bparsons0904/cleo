// lib/data/models/cleaning_history.dart
class CleaningHistory {
  final int id;
  final int releaseId;
  final DateTime cleanedAt;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // Optional relationship property
  final Release? release;

  CleaningHistory({
    required this.id,
    required this.releaseId,
    required this.cleanedAt,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.release,
  });

  factory CleaningHistory.fromJson(Map<String, dynamic> json) {
    return CleaningHistory(
      id: json['id'],
      releaseId: json['release_id'],
      cleanedAt: DateTime.parse(json['cleaned_at']),
      notes: json['notes'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      release: json['release'] != null
          ? Release.fromJson(json['release'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'release_id': releaseId,
      'cleaned_at': cleanedAt.toIso8601String(),
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
