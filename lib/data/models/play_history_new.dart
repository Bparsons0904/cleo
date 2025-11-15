import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_release.dart';
import 'user_stylus.dart';

part 'play_history_new.freezed.dart';
part 'play_history_new.g.dart';

/// PlayHistory model for Waugzee API
/// Represents a single play session of a user's vinyl record
@freezed
class PlayHistoryNew with _$PlayHistoryNew {
  const factory PlayHistoryNew({
    required String id, // UUID
    required String userId, // UUID
    required String userReleaseId, // UUID
    UserRelease? userRelease, // Full release details
    String? userStylusId, // UUID (nullable)
    UserStylus? userStylus, // Full stylus details
    required DateTime playedAt, // RFC3339 format
    @Default('') String notes, // Max 1000 characters
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _PlayHistoryNew;

  factory PlayHistoryNew.fromJson(Map<String, dynamic> json) =>
      _$PlayHistoryNewFromJson(json);
}
