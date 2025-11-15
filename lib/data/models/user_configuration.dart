import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_configuration.freezed.dart';
part 'user_configuration.g.dart';

/// User configuration/preferences model from Waugzee API
@freezed
class UserConfiguration with _$UserConfiguration {
  const factory UserConfiguration({
    required String id,
    required String userId,
    String? discogsToken,
    String? discogsUsername,
    int? selectedFolderId,
    /// Number of days to consider a record as "recently played" (1-365)
    @Default(180) int recentlyPlayedThresholdDays,
    /// Number of plays before a cleaning is recommended (1-50)
    @Default(5) int cleaningFrequencyPlays,
    /// Number of days before a record is considered "neglected" (1-730)
    @Default(365) int neglectedRecordsThresholdDays,
  }) = _UserConfiguration;

  factory UserConfiguration.fromJson(Map<String, dynamic> json) =>
      _$UserConfigurationFromJson(json);
}
