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
      releaseId: json['releaseId'] ?? 0,
      artistId: json['artistId'] ?? 0,
      joinRelation: json['joinRelation'] ?? '',
      anv: json['anv'] ?? '',
      tracks: json['tracks'] ?? '',
      role: json['role'] ?? '',
      artist: json['artist'] != null ? Artist.fromJson(json['artist']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'releaseId': releaseId,
      'artistId': artistId,
      'joinRelation': joinRelation,
      'anv': anv,
      'tracks': tracks,
      'role': role,
      'artist': artist?.toJson(),
    };
  }
}
