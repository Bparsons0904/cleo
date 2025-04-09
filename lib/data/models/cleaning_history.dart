// lib/data/models/cleaning_history.dart - optimized version
import 'models.dart';

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
    try {
      print('Parsing CleaningHistory: ${json['id']}');
      
      return CleaningHistory(
        id: json['id'] ?? 0,
        releaseId: json['releaseId'] ?? 0,
        cleanedAt: _parseDateTime(json['cleanedAt']),
        notes: json['notes'],
        createdAt: _parseDateTime(json['createdAt']),
        updatedAt: _parseDateTime(json['updatedAt']),
        release: json['release'] != null ? Release.fromJson(json['release']) : null,
      );
    } catch (e) {
      print('ERROR in CleaningHistory.fromJson: $e');
      // Return a minimal valid object to avoid null errors
      return CleaningHistory(
        id: json['id'] ?? 0,
        releaseId: json['releaseId'] ?? 0,
        cleanedAt: DateTime.now(),
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
      print('Error parsing date in CleaningHistory: $e');
      return DateTime.now();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'releaseId': releaseId,
      'cleanedAt': cleanedAt.toIso8601String(),
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
