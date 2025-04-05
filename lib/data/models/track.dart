// lib/data/models/track.dart
class Track {
  final int id;
  final int releaseId;
  final String position;
  final String title;
  final String durationText;
  final int durationSeconds;

  Track({
    required this.id,
    required this.releaseId,
    required this.position,
    required this.title,
    required this.durationText,
    required this.durationSeconds,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['id'],
      releaseId: json['release_id'],
      position: json['position'],
      title: json['title'],
      durationText: json['duration_text'] ?? '',
      durationSeconds: json['duration_seconds'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'release_id': releaseId,
      'position': position,
      'title': title,
      'duration_text': durationText,
      'duration_seconds': durationSeconds,
    };
  }
}
