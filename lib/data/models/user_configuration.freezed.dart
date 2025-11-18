// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_configuration.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserConfiguration _$UserConfigurationFromJson(Map<String, dynamic> json) {
  return _UserConfiguration.fromJson(json);
}

/// @nodoc
mixin _$UserConfiguration {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String? get discogsToken => throw _privateConstructorUsedError;
  String? get discogsUsername => throw _privateConstructorUsedError;
  int? get selectedFolderId => throw _privateConstructorUsedError;

  /// Number of days to consider a record as "recently played" (1-365)
  int get recentlyPlayedThresholdDays => throw _privateConstructorUsedError;

  /// Number of plays before a cleaning is recommended (1-50)
  int get cleaningFrequencyPlays => throw _privateConstructorUsedError;

  /// Number of days before a record is considered "neglected" (1-730)
  int get neglectedRecordsThresholdDays => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserConfigurationCopyWith<UserConfiguration> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserConfigurationCopyWith<$Res> {
  factory $UserConfigurationCopyWith(
          UserConfiguration value, $Res Function(UserConfiguration) then) =
      _$UserConfigurationCopyWithImpl<$Res, UserConfiguration>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String? discogsToken,
      String? discogsUsername,
      int? selectedFolderId,
      int recentlyPlayedThresholdDays,
      int cleaningFrequencyPlays,
      int neglectedRecordsThresholdDays});
}

/// @nodoc
class _$UserConfigurationCopyWithImpl<$Res, $Val extends UserConfiguration>
    implements $UserConfigurationCopyWith<$Res> {
  _$UserConfigurationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? discogsToken = freezed,
    Object? discogsUsername = freezed,
    Object? selectedFolderId = freezed,
    Object? recentlyPlayedThresholdDays = null,
    Object? cleaningFrequencyPlays = null,
    Object? neglectedRecordsThresholdDays = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      discogsToken: freezed == discogsToken
          ? _value.discogsToken
          : discogsToken // ignore: cast_nullable_to_non_nullable
              as String?,
      discogsUsername: freezed == discogsUsername
          ? _value.discogsUsername
          : discogsUsername // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedFolderId: freezed == selectedFolderId
          ? _value.selectedFolderId
          : selectedFolderId // ignore: cast_nullable_to_non_nullable
              as int?,
      recentlyPlayedThresholdDays: null == recentlyPlayedThresholdDays
          ? _value.recentlyPlayedThresholdDays
          : recentlyPlayedThresholdDays // ignore: cast_nullable_to_non_nullable
              as int,
      cleaningFrequencyPlays: null == cleaningFrequencyPlays
          ? _value.cleaningFrequencyPlays
          : cleaningFrequencyPlays // ignore: cast_nullable_to_non_nullable
              as int,
      neglectedRecordsThresholdDays: null == neglectedRecordsThresholdDays
          ? _value.neglectedRecordsThresholdDays
          : neglectedRecordsThresholdDays // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserConfigurationImplCopyWith<$Res>
    implements $UserConfigurationCopyWith<$Res> {
  factory _$$UserConfigurationImplCopyWith(_$UserConfigurationImpl value,
          $Res Function(_$UserConfigurationImpl) then) =
      __$$UserConfigurationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String? discogsToken,
      String? discogsUsername,
      int? selectedFolderId,
      int recentlyPlayedThresholdDays,
      int cleaningFrequencyPlays,
      int neglectedRecordsThresholdDays});
}

/// @nodoc
class __$$UserConfigurationImplCopyWithImpl<$Res>
    extends _$UserConfigurationCopyWithImpl<$Res, _$UserConfigurationImpl>
    implements _$$UserConfigurationImplCopyWith<$Res> {
  __$$UserConfigurationImplCopyWithImpl(_$UserConfigurationImpl _value,
      $Res Function(_$UserConfigurationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? discogsToken = freezed,
    Object? discogsUsername = freezed,
    Object? selectedFolderId = freezed,
    Object? recentlyPlayedThresholdDays = null,
    Object? cleaningFrequencyPlays = null,
    Object? neglectedRecordsThresholdDays = null,
  }) {
    return _then(_$UserConfigurationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      discogsToken: freezed == discogsToken
          ? _value.discogsToken
          : discogsToken // ignore: cast_nullable_to_non_nullable
              as String?,
      discogsUsername: freezed == discogsUsername
          ? _value.discogsUsername
          : discogsUsername // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedFolderId: freezed == selectedFolderId
          ? _value.selectedFolderId
          : selectedFolderId // ignore: cast_nullable_to_non_nullable
              as int?,
      recentlyPlayedThresholdDays: null == recentlyPlayedThresholdDays
          ? _value.recentlyPlayedThresholdDays
          : recentlyPlayedThresholdDays // ignore: cast_nullable_to_non_nullable
              as int,
      cleaningFrequencyPlays: null == cleaningFrequencyPlays
          ? _value.cleaningFrequencyPlays
          : cleaningFrequencyPlays // ignore: cast_nullable_to_non_nullable
              as int,
      neglectedRecordsThresholdDays: null == neglectedRecordsThresholdDays
          ? _value.neglectedRecordsThresholdDays
          : neglectedRecordsThresholdDays // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserConfigurationImpl implements _UserConfiguration {
  const _$UserConfigurationImpl(
      {required this.id,
      required this.userId,
      this.discogsToken,
      this.discogsUsername,
      this.selectedFolderId,
      this.recentlyPlayedThresholdDays = 180,
      this.cleaningFrequencyPlays = 5,
      this.neglectedRecordsThresholdDays = 365});

  factory _$UserConfigurationImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserConfigurationImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String? discogsToken;
  @override
  final String? discogsUsername;
  @override
  final int? selectedFolderId;

  /// Number of days to consider a record as "recently played" (1-365)
  @override
  @JsonKey()
  final int recentlyPlayedThresholdDays;

  /// Number of plays before a cleaning is recommended (1-50)
  @override
  @JsonKey()
  final int cleaningFrequencyPlays;

  /// Number of days before a record is considered "neglected" (1-730)
  @override
  @JsonKey()
  final int neglectedRecordsThresholdDays;

  @override
  String toString() {
    return 'UserConfiguration(id: $id, userId: $userId, discogsToken: $discogsToken, discogsUsername: $discogsUsername, selectedFolderId: $selectedFolderId, recentlyPlayedThresholdDays: $recentlyPlayedThresholdDays, cleaningFrequencyPlays: $cleaningFrequencyPlays, neglectedRecordsThresholdDays: $neglectedRecordsThresholdDays)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserConfigurationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.discogsToken, discogsToken) ||
                other.discogsToken == discogsToken) &&
            (identical(other.discogsUsername, discogsUsername) ||
                other.discogsUsername == discogsUsername) &&
            (identical(other.selectedFolderId, selectedFolderId) ||
                other.selectedFolderId == selectedFolderId) &&
            (identical(other.recentlyPlayedThresholdDays,
                    recentlyPlayedThresholdDays) ||
                other.recentlyPlayedThresholdDays ==
                    recentlyPlayedThresholdDays) &&
            (identical(other.cleaningFrequencyPlays, cleaningFrequencyPlays) ||
                other.cleaningFrequencyPlays == cleaningFrequencyPlays) &&
            (identical(other.neglectedRecordsThresholdDays,
                    neglectedRecordsThresholdDays) ||
                other.neglectedRecordsThresholdDays ==
                    neglectedRecordsThresholdDays));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      discogsToken,
      discogsUsername,
      selectedFolderId,
      recentlyPlayedThresholdDays,
      cleaningFrequencyPlays,
      neglectedRecordsThresholdDays);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserConfigurationImplCopyWith<_$UserConfigurationImpl> get copyWith =>
      __$$UserConfigurationImplCopyWithImpl<_$UserConfigurationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserConfigurationImplToJson(
      this,
    );
  }
}

abstract class _UserConfiguration implements UserConfiguration {
  const factory _UserConfiguration(
      {required final String id,
      required final String userId,
      final String? discogsToken,
      final String? discogsUsername,
      final int? selectedFolderId,
      final int recentlyPlayedThresholdDays,
      final int cleaningFrequencyPlays,
      final int neglectedRecordsThresholdDays}) = _$UserConfigurationImpl;

  factory _UserConfiguration.fromJson(Map<String, dynamic> json) =
      _$UserConfigurationImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String? get discogsToken;
  @override
  String? get discogsUsername;
  @override
  int? get selectedFolderId;
  @override

  /// Number of days to consider a record as "recently played" (1-365)
  int get recentlyPlayedThresholdDays;
  @override

  /// Number of plays before a cleaning is recommended (1-50)
  int get cleaningFrequencyPlays;
  @override

  /// Number of days before a record is considered "neglected" (1-730)
  int get neglectedRecordsThresholdDays;
  @override
  @JsonKey(ignore: true)
  _$$UserConfigurationImplCopyWith<_$UserConfigurationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
