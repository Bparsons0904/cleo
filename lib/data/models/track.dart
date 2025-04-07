class Track {
  final int id;
  final int releaseId;
  final String position;
  final String title;
  final String durationText;
  final int durationSeconds;
  final DateTime createdAt;
  final DateTime updatedAt;

  Track({
    required this.id,
    required this.releaseId,
    required this.position,
    required this.title,
    required this.durationText,
    required this.durationSeconds,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['id'] ?? 0,
      releaseId: json['releaseId'] ?? 0,
      position: json['position'] ?? '',
      title: json['title'] ?? '',
      durationText: json['durationText'] ?? '',
      durationSeconds: json['durationSeconds'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime(1),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime(1),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'releaseId': releaseId,
      'position': position,
      'title': title,
      'durationText': durationText,
      'durationSeconds': durationSeconds,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
