// lib/data/models/play_history.dart - optimized version
import 'models.dart';

class PlayHistory {
  final int id;
  final int releaseId;
  final int? stylusId;
  final DateTime playedAt;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // Optional relationship properties
  final Release? release;
  final Stylus? stylus;

  PlayHistory({
    required this.id,
    required this.releaseId,
    this.stylusId,
    required this.playedAt,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.release,
    this.stylus,
  });

  factory PlayHistory.fromJson(Map<String, dynamic> json) {
    try {
      print('Parsing PlayHistory: ${json['id']}');
      
      return PlayHistory(
        id: json['id'] ?? 0,
        releaseId: json['releaseId'] ?? 0,
        stylusId: json['stylusId'],
        playedAt: _parseDateTime(json['playedAt']),
        notes: json['notes'],
        createdAt: _parseDateTime(json['createdAt']),
        updatedAt: _parseDateTime(json['updatedAt']),
        release: json['release'] != null ? Release.fromJson(json['release']) : null,
        stylus: json['stylus'] != null ? Stylus.fromJson(json['stylus']) : null,
      );
    } catch (e) {
      print('ERROR in PlayHistory.fromJson: $e');
      // Return a minimal valid object to avoid null errors
      return PlayHistory(
        id: json['id'] ?? 0,
        releaseId: json['releaseId'] ?? 0,
        playedAt: DateTime.now(),
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
      print('Error parsing date in PlayHistory: $e');
      return DateTime.now();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'releaseId': releaseId,
      'stylusId': stylusId,
      'playedAt': playedAt.toIso8601String(),
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
