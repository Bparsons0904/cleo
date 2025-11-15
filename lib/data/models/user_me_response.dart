import 'package:freezed_annotation/freezed_annotation.dart';
import 'user.dart';
import 'folder_new.dart';
import 'user_release.dart';
import 'user_stylus.dart';
import 'play_history_new.dart';
import 'daily_recommendation.dart';
import 'streak.dart';

part 'user_me_response.freezed.dart';
part 'user_me_response.g.dart';

/// Response model for GET /api/users/me endpoint
/// This is the primary data payload containing all user data
@freezed
class UserMeResponse with _$UserMeResponse {
  const factory UserMeResponse({
    required User user,
    @Default([]) List<FolderNew> folders,
    @Default([]) List<UserRelease> releases,
    @Default([]) List<UserStylus> styluses,
    @Default([]) List<PlayHistoryNew> playHistory,
    DailyRecommendation? dailyRecommendation,
    Streak? streak,
  }) = _UserMeResponse;

  factory UserMeResponse.fromJson(Map<String, dynamic> json) =>
      _$UserMeResponseFromJson(json);
}
