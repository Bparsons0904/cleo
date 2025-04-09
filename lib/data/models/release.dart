// lib/data/models/release.dart - optimized version
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

  // fromJson factory constructor with improved parsing
  factory Release.fromJson(Map<String, dynamic> json) {
    try {
      // Parse play history with robust error handling
      List<PlayHistory> playHistoryList = [];
      if (json['playHistory'] != null) {
        try {
          playHistoryList = (json['playHistory'] as List)
              .map((play) => PlayHistory.fromJson(play))
              .toList();
        } catch (e) {
          print('Error parsing playHistory in Release: $e');
        }
      }
      
      // Parse cleaning history with robust error handling
      List<CleaningHistory> cleaningHistoryList = [];
      if (json['cleaningHistory'] != null) {
        try {
          cleaningHistoryList = (json['cleaningHistory'] as List)
              .map((cleaning) => CleaningHistory.fromJson(cleaning))
              .toList();
        } catch (e) {
          print('Error parsing cleaningHistory in Release: $e');
        }
      }
      
      return Release(
        id: json['id'] ?? 0,
        instanceId: json['instanceId'] ?? 0,
        folderId: json['folderId'] ?? 0,
        rating: json['rating'] ?? 0,
        title: json['title'] ?? '',
        year: json['year'],
        resourceUrl: json['resourceUrl'] ?? '',
        thumb: json['thumb'] ?? '',
        coverImage: json['coverImage'] ?? '',
        playDuration: json['playDuration'],
        playDurationEstimated: json['playDurationEstimated'] ?? false,
        createdAt: _parseDateTime(json['createdAt']),
        updatedAt: _parseDateTime(json['updatedAt']),
        artists: _parseList<ReleaseArtist>(json['artists'], ReleaseArtist.fromJson),
        labels: _parseList<ReleaseLabel>(json['labels'], ReleaseLabel.fromJson),
        formats: _parseList<Format>(json['formats'], Format.fromJson),
        genres: _parseList<Genre>(json['genres'], Genre.fromJson),
        styles: _parseList<Style>(json['styles'], Style.fromJson),
        notes: _parseList<ReleaseNote>(json['notes'], ReleaseNote.fromJson),
        playHistory: playHistoryList,
        cleaningHistory: cleaningHistoryList,
        tracks: _parseList<Track>(json['tracks'], Track.fromJson),
      );
    } catch (e) {
      print('Error parsing Release: $e');
      // Return a minimal valid Release to avoid null errors
      return Release(
        id: json['id'] ?? 0,
        instanceId: 0,
        folderId: 0,
        rating: 0,
        title: json['title'] ?? 'Unknown',
        resourceUrl: '',
        thumb: '',
        coverImage: '',
        playDurationEstimated: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        artists: [],
        labels: [],
        formats: [],
        genres: [],
        styles: [],
        notes: [],
        playHistory: [],
        cleaningHistory: [],
        tracks: [],
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
      print('Error parsing date: $e');
      return DateTime.now();
    }
  }
  
  // Helper method to safely parse lists
  static List<T> _parseList<T>(dynamic jsonList, T Function(Map<String, dynamic>) fromJson) {
    if (jsonList == null) {
      return [];
    }
    
    try {
      return (jsonList as List)
          .map((item) {
            try {
              return fromJson(item);
            } catch (e) {
              print('Error parsing list item: $e');
              return null;
            }
          })
          .whereType<T>() // Filter out nulls
          .toList();
    } catch (e) {
      print('Error parsing list: $e');
      return [];
    }
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'instanceId': instanceId,
      'folderId': folderId,
      'rating': rating,
      'title': title,
      'year': year,
      'resourceUrl': resourceUrl,
      'thumb': thumb,
      'coverImage': coverImage,
      'playDuration': playDuration,
      'playDurationEstimated': playDurationEstimated,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'artists': artists.map((a) => a.toJson()).toList(),
      'labels': labels.map((l) => l.toJson()).toList(),
      'formats': formats.map((f) => f.toJson()).toList(),
      'genres': genres.map((g) => g.toJson()).toList(),
      'styles': styles.map((s) => s.toJson()).toList(),
      'notes': notes.map((n) => n.toJson()).toList(),
      'playHistory': playHistory.map((p) => p.toJson()).toList(),
      'cleaningHistory': cleaningHistory.map((c) => c.toJson()).toList(),
      'tracks': tracks.map((t) => t.toJson()).toList(),
    };
  }
}
