// lib/data/models/auth_payload.dart
import 'folder.dart';
import 'play_history.dart';
import 'release.dart';
import 'stylus.dart';

// lib/data/models/auth_payload.dart
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
    print("Parsing AuthPayload");
    
    // Parse releases with error handling
    List<Release> parsedReleases = [];
    if (json['releases'] is List) {
      try {
        parsedReleases = (json['releases'] as List)
            .map((release) => Release.fromJson(release))
            .toList();
        print("Successfully parsed ${parsedReleases.length} releases");
      } catch (e) {
        print("Error parsing releases: $e");
      }
    }
    
    // Parse styluses with error handling
    List<Stylus> parsedStyluses = [];
    if (json['stylus'] is List) {
      try {
        parsedStyluses = (json['stylus'] as List)
            .map((stylus) {
              try {
                return Stylus.fromJson(stylus);
              } catch (e) {
                print("Error parsing individual stylus: $e");
                return null;
              }
            })
            .whereType<Stylus>()  // Filter out nulls
            .toList();
        print("Successfully parsed ${parsedStyluses.length} styluses");
      } catch (e) {
        print("Error parsing styluses: $e");
      }
    }
    
    // Parse play history with error handling
    List<PlayHistory> parsedPlayHistory = [];
    if (json['playHistory'] is List) {
      try {
        parsedPlayHistory = (json['playHistory'] as List)
            .map((play) => PlayHistory.fromJson(play))
            .toList();
        print("Successfully parsed ${parsedPlayHistory.length} play history entries");
      } catch (e) {
        print("Error parsing play history: $e");
      }
    }
    
    // Parse folders with error handling
    List<Folder> parsedFolders = [];
    if (json['folders'] is List) {
      try {
        parsedFolders = (json['folders'] as List)
            .map((folder) => Folder.fromJson(folder))
            .toList();
        print("Successfully parsed ${parsedFolders.length} folders");
      } catch (e) {
        print("Error parsing folders: $e");
      }
    }
    
    return AuthPayload(
      token: json['token'] ?? '',
      lastSync: json['lastSync'] != null 
          ? DateTime.parse(json['lastSync']) 
          : null,
      syncingData: json['syncingData'] ?? false,
      releases: parsedReleases,
      styluses: parsedStyluses,
      playHistory: parsedPlayHistory,
      folders: parsedFolders,
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
