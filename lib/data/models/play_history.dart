// lib/data/models/play_history.dart
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
    return PlayHistory(
      id: json['id'],
      releaseId: json['release_id'],
      stylusId: json['stylus_id'],
      playedAt: DateTime.parse(json['played_at']),
      notes: json['notes'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      release: json['release'] != null
          ? Release.fromJson(json['release'])
          : null,
      stylus: json['stylus'] != null
          ? Stylus.fromJson(json['stylus'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'release_id': releaseId,
      'stylus_id': stylusId,
      'played_at': playedAt.toIso8601String(),
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      // We typically don't include relationships in toJson
      // unless specifically needed for the API
    };
  }
}
