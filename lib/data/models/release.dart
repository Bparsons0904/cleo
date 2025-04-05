// lib/data/models/release.dart
import 'models.dart';

class Release {
  final int id;
  final int instanceId;
  final int folderId;
  final int rating;
  final String title;
  final int? year;
  final String resourceUrl;
  final String thumb;
  final String coverImage;
  final int? playDuration;
  final bool playDurationEstimated;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Relationships
  final List<ReleaseArtist> artists;
  final List<ReleaseLabel> labels;
  final List<Format> formats;
  final List<Genre> genres;
  final List<Style> styles;
  final List<ReleaseNote> notes;
  final List<PlayHistory> playHistory;
  final List<CleaningHistory> cleaningHistory;
  final List<Track> tracks;

  Release({
    required this.id,
    required this.instanceId,
    required this.folderId,
    required this.rating,
    required this.title,
    this.year,
    required this.resourceUrl,
    required this.thumb,
    required this.coverImage,
    this.playDuration,
    required this.playDurationEstimated,
    required this.createdAt,
    required this.updatedAt,
    required this.artists,
    required this.labels,
    required this.formats,
    required this.genres,
    required this.styles,
    required this.notes,
    required this.playHistory,
    required this.cleaningHistory,
    required this.tracks,
  });

  // fromJson factory constructor
  factory Release.fromJson(Map<String, dynamic> json) {
    return Release(
      id: json['id'],
      instanceId: json['instance_id'],
      folderId: json['folder_id'],
      rating: json['rating'],
      title: json['title'],
      year: json['year'],
      resourceUrl: json['resource_url'],
      thumb: json['thumb'],
      coverImage: json['cover_image'],
      playDuration: json['play_duration'],
      playDurationEstimated: json['play_duration_estimated'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      artists: (json['artists'] as List?)
          ?.map((artist) => ReleaseArtist.fromJson(artist))
          .toList() ?? [],
      labels: (json['labels'] as List?)
          ?.map((label) => ReleaseLabel.fromJson(label))
          .toList() ?? [],
      formats: (json['formats'] as List?)
          ?.map((format) => Format.fromJson(format))
          .toList() ?? [],
      genres: (json['genres'] as List?)
          ?.map((genre) => Genre.fromJson(genre))
          .toList() ?? [],
      styles: (json['styles'] as List?)
          ?.map((style) => Style.fromJson(style))
          .toList() ?? [],
      notes: (json['notes'] as List?)
          ?.map((note) => ReleaseNote.fromJson(note))
          .toList() ?? [],
      playHistory: (json['play_history'] as List?)
          ?.map((play) => PlayHistory.fromJson(play))
          .toList() ?? [],
      cleaningHistory: (json['cleaning_history'] as List?)
          ?.map((cleaning) => CleaningHistory.fromJson(cleaning))
          .toList() ?? [],
      tracks: (json['tracks'] as List?)
          ?.map((track) => Track.fromJson(track))
          .toList() ?? [],
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'instance_id': instanceId,
      'folder_id': folderId,
      'rating': rating,
      'title': title,
      'year': year,
      'resource_url': resourceUrl,
      'thumb': thumb,
      'cover_image': coverImage,
      'play_duration': playDuration,
      'play_duration_estimated': playDurationEstimated,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'artists': artists.map((a) => a.toJson()).toList(),
      'labels': labels.map((l) => l.toJson()).toList(),
      'formats': formats.map((f) => f.toJson()).toList(),
      'genres': genres.map((g) => g.toJson()).toList(),
      'styles': styles.map((s) => s.toJson()).toList(),
      'notes': notes.map((n) => n.toJson()).toList(),
      'play_history': playHistory.map((p) => p.toJson()).toList(),
      'cleaning_history': cleaningHistory.map((c) => c.toJson()).toList(),
      'tracks': tracks.map((t) => t.toJson()).toList(),
    };
  }
}
