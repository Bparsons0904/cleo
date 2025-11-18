// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_me_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserMeResponse _$UserMeResponseFromJson(Map<String, dynamic> json) {
  return _UserMeResponse.fromJson(json);
}

/// @nodoc
mixin _$UserMeResponse {
  User get user => throw _privateConstructorUsedError;
  List<FolderNew> get folders => throw _privateConstructorUsedError;
  List<UserRelease> get releases => throw _privateConstructorUsedError;
  List<UserStylus> get styluses => throw _privateConstructorUsedError;
  List<PlayHistoryNew> get playHistory => throw _privateConstructorUsedError;
  DailyRecommendation? get dailyRecommendation =>
      throw _privateConstructorUsedError;
  Streak? get streak => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserMeResponseCopyWith<UserMeResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserMeResponseCopyWith<$Res> {
  factory $UserMeResponseCopyWith(
          UserMeResponse value, $Res Function(UserMeResponse) then) =
      _$UserMeResponseCopyWithImpl<$Res, UserMeResponse>;
  @useResult
  $Res call(
      {User user,
      List<FolderNew> folders,
      List<UserRelease> releases,
      List<UserStylus> styluses,
      List<PlayHistoryNew> playHistory,
      DailyRecommendation? dailyRecommendation,
      Streak? streak});

  $UserCopyWith<$Res> get user;
  $DailyRecommendationCopyWith<$Res>? get dailyRecommendation;
  $StreakCopyWith<$Res>? get streak;
}

/// @nodoc
class _$UserMeResponseCopyWithImpl<$Res, $Val extends UserMeResponse>
    implements $UserMeResponseCopyWith<$Res> {
  _$UserMeResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? folders = null,
    Object? releases = null,
    Object? styluses = null,
    Object? playHistory = null,
    Object? dailyRecommendation = freezed,
    Object? streak = freezed,
  }) {
    return _then(_value.copyWith(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
      folders: null == folders
          ? _value.folders
          : folders // ignore: cast_nullable_to_non_nullable
              as List<FolderNew>,
      releases: null == releases
          ? _value.releases
          : releases // ignore: cast_nullable_to_non_nullable
              as List<UserRelease>,
      styluses: null == styluses
          ? _value.styluses
          : styluses // ignore: cast_nullable_to_non_nullable
              as List<UserStylus>,
      playHistory: null == playHistory
          ? _value.playHistory
          : playHistory // ignore: cast_nullable_to_non_nullable
              as List<PlayHistoryNew>,
      dailyRecommendation: freezed == dailyRecommendation
          ? _value.dailyRecommendation
          : dailyRecommendation // ignore: cast_nullable_to_non_nullable
              as DailyRecommendation?,
      streak: freezed == streak
          ? _value.streak
          : streak // ignore: cast_nullable_to_non_nullable
              as Streak?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res> get user {
    return $UserCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $DailyRecommendationCopyWith<$Res>? get dailyRecommendation {
    if (_value.dailyRecommendation == null) {
      return null;
    }

    return $DailyRecommendationCopyWith<$Res>(_value.dailyRecommendation!,
        (value) {
      return _then(_value.copyWith(dailyRecommendation: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $StreakCopyWith<$Res>? get streak {
    if (_value.streak == null) {
      return null;
    }

    return $StreakCopyWith<$Res>(_value.streak!, (value) {
      return _then(_value.copyWith(streak: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserMeResponseImplCopyWith<$Res>
    implements $UserMeResponseCopyWith<$Res> {
  factory _$$UserMeResponseImplCopyWith(_$UserMeResponseImpl value,
          $Res Function(_$UserMeResponseImpl) then) =
      __$$UserMeResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {User user,
      List<FolderNew> folders,
      List<UserRelease> releases,
      List<UserStylus> styluses,
      List<PlayHistoryNew> playHistory,
      DailyRecommendation? dailyRecommendation,
      Streak? streak});

  @override
  $UserCopyWith<$Res> get user;
  @override
  $DailyRecommendationCopyWith<$Res>? get dailyRecommendation;
  @override
  $StreakCopyWith<$Res>? get streak;
}

/// @nodoc
class __$$UserMeResponseImplCopyWithImpl<$Res>
    extends _$UserMeResponseCopyWithImpl<$Res, _$UserMeResponseImpl>
    implements _$$UserMeResponseImplCopyWith<$Res> {
  __$$UserMeResponseImplCopyWithImpl(
      _$UserMeResponseImpl _value, $Res Function(_$UserMeResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? folders = null,
    Object? releases = null,
    Object? styluses = null,
    Object? playHistory = null,
    Object? dailyRecommendation = freezed,
    Object? streak = freezed,
  }) {
    return _then(_$UserMeResponseImpl(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
      folders: null == folders
          ? _value._folders
          : folders // ignore: cast_nullable_to_non_nullable
              as List<FolderNew>,
      releases: null == releases
          ? _value._releases
          : releases // ignore: cast_nullable_to_non_nullable
              as List<UserRelease>,
      styluses: null == styluses
          ? _value._styluses
          : styluses // ignore: cast_nullable_to_non_nullable
              as List<UserStylus>,
      playHistory: null == playHistory
          ? _value._playHistory
          : playHistory // ignore: cast_nullable_to_non_nullable
              as List<PlayHistoryNew>,
      dailyRecommendation: freezed == dailyRecommendation
          ? _value.dailyRecommendation
          : dailyRecommendation // ignore: cast_nullable_to_non_nullable
              as DailyRecommendation?,
      streak: freezed == streak
          ? _value.streak
          : streak // ignore: cast_nullable_to_non_nullable
              as Streak?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserMeResponseImpl implements _UserMeResponse {
  const _$UserMeResponseImpl(
      {required this.user,
      final List<FolderNew> folders = const [],
      final List<UserRelease> releases = const [],
      final List<UserStylus> styluses = const [],
      final List<PlayHistoryNew> playHistory = const [],
      this.dailyRecommendation,
      this.streak})
      : _folders = folders,
        _releases = releases,
        _styluses = styluses,
        _playHistory = playHistory;

  factory _$UserMeResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserMeResponseImplFromJson(json);

  @override
  final User user;
  final List<FolderNew> _folders;
  @override
  @JsonKey()
  List<FolderNew> get folders {
    if (_folders is EqualUnmodifiableListView) return _folders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_folders);
  }

  final List<UserRelease> _releases;
  @override
  @JsonKey()
  List<UserRelease> get releases {
    if (_releases is EqualUnmodifiableListView) return _releases;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_releases);
  }

  final List<UserStylus> _styluses;
  @override
  @JsonKey()
  List<UserStylus> get styluses {
    if (_styluses is EqualUnmodifiableListView) return _styluses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_styluses);
  }

  final List<PlayHistoryNew> _playHistory;
  @override
  @JsonKey()
  List<PlayHistoryNew> get playHistory {
    if (_playHistory is EqualUnmodifiableListView) return _playHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_playHistory);
  }

  @override
  final DailyRecommendation? dailyRecommendation;
  @override
  final Streak? streak;

  @override
  String toString() {
    return 'UserMeResponse(user: $user, folders: $folders, releases: $releases, styluses: $styluses, playHistory: $playHistory, dailyRecommendation: $dailyRecommendation, streak: $streak)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserMeResponseImpl &&
            (identical(other.user, user) || other.user == user) &&
            const DeepCollectionEquality().equals(other._folders, _folders) &&
            const DeepCollectionEquality().equals(other._releases, _releases) &&
            const DeepCollectionEquality().equals(other._styluses, _styluses) &&
            const DeepCollectionEquality()
                .equals(other._playHistory, _playHistory) &&
            (identical(other.dailyRecommendation, dailyRecommendation) ||
                other.dailyRecommendation == dailyRecommendation) &&
            (identical(other.streak, streak) || other.streak == streak));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      user,
      const DeepCollectionEquality().hash(_folders),
      const DeepCollectionEquality().hash(_releases),
      const DeepCollectionEquality().hash(_styluses),
      const DeepCollectionEquality().hash(_playHistory),
      dailyRecommendation,
      streak);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserMeResponseImplCopyWith<_$UserMeResponseImpl> get copyWith =>
      __$$UserMeResponseImplCopyWithImpl<_$UserMeResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserMeResponseImplToJson(
      this,
    );
  }
}

abstract class _UserMeResponse implements UserMeResponse {
  const factory _UserMeResponse(
      {required final User user,
      final List<FolderNew> folders,
      final List<UserRelease> releases,
      final List<UserStylus> styluses,
      final List<PlayHistoryNew> playHistory,
      final DailyRecommendation? dailyRecommendation,
      final Streak? streak}) = _$UserMeResponseImpl;

  factory _UserMeResponse.fromJson(Map<String, dynamic> json) =
      _$UserMeResponseImpl.fromJson;

  @override
  User get user;
  @override
  List<FolderNew> get folders;
  @override
  List<UserRelease> get releases;
  @override
  List<UserStylus> get styluses;
  @override
  List<PlayHistoryNew> get playHistory;
  @override
  DailyRecommendation? get dailyRecommendation;
  @override
  Streak? get streak;
  @override
  @JsonKey(ignore: true)
  _$$UserMeResponseImplCopyWith<_$UserMeResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
