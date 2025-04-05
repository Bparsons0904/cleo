// lib/data/models/auth_payload.dart
import 'folder.dart';
import 'play_history.dart';
import 'release.dart';
import 'stylus.dart';

class AuthPayload {
  final String token;
  final DateTime? lastSync;
  final bool syncingData;
  final List<Release> releases;
  final List<Stylus> styluses;
  final List<PlayHistory> playHistory;
  final List<Folder> folders;

  AuthPayload({
    required this.token,
    this.lastSync,
    required this.syncingData,
    required this.releases,
    required this.styluses,
    required this.playHistory,
    required this.folders,
  });

  factory AuthPayload.fromJson(Map<String, dynamic> json) {
    return AuthPayload(
      token: json['token'],
      lastSync: json['lastSync'] != null 
          ? DateTime.parse(json['lastSync']) 
          : null,
      syncingData: json['syncingData'] ?? false,
      releases: (json['releases'] as List?)
          ?.map((release) => Release.fromJson(release))
          .toList() ?? [],
      styluses: (json['stylus'] as List?)
          ?.map((stylus) => Stylus.fromJson(stylus))
          .toList() ?? [],
      playHistory: (json['playHistory'] as List?)
          ?.map((play) => PlayHistory.fromJson(play))
          .toList() ?? [],
      folders: (json['folders'] as List?)
          ?.map((folder) => Folder.fromJson(folder))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'lastSync': lastSync?.toIso8601String(),
      'syncingData': syncingData,
      'releases': releases.map((r) => r.toJson()).toList(),
      'stylus': styluses.map((s) => s.toJson()).toList(),
      'playHistory': playHistory.map((p) => p.toJson()).toList(),
      'folders': folders.map((f) => f.toJson()).toList(),
    };
  }
}
