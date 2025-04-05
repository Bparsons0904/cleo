// lib/data/models/release_artist.dart
import 'models.dart';

class ReleaseArtist {
  final int releaseId;
  final int artistId;
  final String joinRelation;
  final String anv;
  final String tracks;
  final String role;
  final Artist? artist;

  ReleaseArtist({
    required this.releaseId,
    required this.artistId,
    required this.joinRelation,
    required this.anv,
    required this.tracks,
    required this.role,
    this.artist,
  });

  factory ReleaseArtist.fromJson(Map<String, dynamic> json) {
    return ReleaseArtist(
      releaseId: json['release_id'],
      artistId: json['artist_id'],
      joinRelation: json['join_relation'] ?? '',
      anv: json['anv'] ?? '',
      tracks: json['tracks'] ?? '',
      role: json['role'] ?? '',
      artist: json['artist'] != null ? Artist.fromJson(json['artist']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'release_id': releaseId,
      'artist_id': artistId,
      'join_relation': joinRelation,
      'anv': anv,
      'tracks': tracks,
      'role': role,
    };
  }
}
