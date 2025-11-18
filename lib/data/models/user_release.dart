import 'package:freezed_annotation/freezed_annotation.dart';
import 'release.dart';
import 'play_history.dart';
import 'cleaning_history.dart';

part 'user_release.freezed.dart';
part 'user_release.g.dart';

/// UserRelease model - represents a user's instance of a release
/// This is the junction between User and Release with user-specific data
@freezed
class UserRelease with _$UserRelease {
  const factory UserRelease({
    required String id, // UUID - primary key
    required String userId, // UUID - foreign key to users
    required int releaseId, // Discogs release ID (int64)
    Release? release, // Full release details (nested)
    required String instanceId, // Unique instance identifier (string)
    String? folderId, // UUID - foreign key to folders (nullable)
    @Default(0) int rating,
    Map<String, dynamic>? notes, // JSONB
    DateTime? dateAdded,
    @Default(true) bool active,
    @Default([]) List<PlayHistory> playHistory,
    @Default([]) List<CleaningHistory> cleaningHistory,
  }) = _UserRelease;

  factory UserRelease.fromJson(Map<String, dynamic> json) =>
      _$UserReleaseFromJson(json);
}
