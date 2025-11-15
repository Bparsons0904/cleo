import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_recommendation.freezed.dart';
part 'daily_recommendation.g.dart';

/// Daily recommendation algorithm type
enum RecommendationAlgorithm {
  @JsonValue('smart')
  smart,
  @JsonValue('random')
  random,
}

/// Daily recommendation model from Waugzee API
/// Represents a single record recommended for the user to listen to today
@freezed
class DailyRecommendation with _$DailyRecommendation {
  const factory DailyRecommendation({
    required String id,
    required String userId,
    required String userReleaseId,
    // Note: userRelease will be populated with full Release details
    Map<String, dynamic>? userRelease,
    required DateTime date,
    DateTime? listenedAt,
    @Default(RecommendationAlgorithm.smart) RecommendationAlgorithm algorithm,
  }) = _DailyRecommendation;

  factory DailyRecommendation.fromJson(Map<String, dynamic> json) =>
      _$DailyRecommendationFromJson(json);
}
