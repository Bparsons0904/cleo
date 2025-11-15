import 'package:freezed_annotation/freezed_annotation.dart';

part 'streak.freezed.dart';
part 'streak.g.dart';

/// Streak model representing user's listening streak
@freezed
class Streak with _$Streak {
  const factory Streak({
    @Default(0) int currentStreak,
    @Default(0) int longestStreak,
    DateTime? lastPlayDate,
  }) = _Streak;

  factory Streak.fromJson(Map<String, dynamic> json) => _$StreakFromJson(json);
}
