import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_release.dart';

part 'cleaning_history_new.freezed.dart';
part 'cleaning_history_new.g.dart';

/// CleaningHistory model for Waugzee API
/// Represents a single cleaning session of a user's vinyl record
@freezed
class CleaningHistoryNew with _$CleaningHistoryNew {
  const factory CleaningHistoryNew({
    required String id, // UUID
    required String userId, // UUID
    required String userReleaseId, // UUID
    UserRelease? userRelease, // Full release details
    required DateTime cleanedAt, // RFC3339 format
    @Default('') String notes, // Max 1000 characters
    @Default(false) bool isDeepClean,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CleaningHistoryNew;

  factory CleaningHistoryNew.fromJson(Map<String, dynamic> json) =>
      _$CleaningHistoryNewFromJson(json);
}
