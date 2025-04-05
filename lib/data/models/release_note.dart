// lib/data/models/release_note.dart
class ReleaseNote {
  final int id;
  final int releaseId;
  final String content;
  final DateTime createdAt;

  ReleaseNote({
    required this.id,
    required this.releaseId,
    required this.content,
    required this.createdAt,
  });

  factory ReleaseNote.fromJson(Map<String, dynamic> json) {
    return ReleaseNote(
      id: json['id'],
      releaseId: json['release_id'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'release_id': releaseId,
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
