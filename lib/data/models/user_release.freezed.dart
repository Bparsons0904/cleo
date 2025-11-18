// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_release.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserRelease _$UserReleaseFromJson(Map<String, dynamic> json) {
  return _UserRelease.fromJson(json);
}

/// @nodoc
mixin _$UserRelease {
  String get id => throw _privateConstructorUsedError; // UUID
  String get userId => throw _privateConstructorUsedError; // UUID
  int get releaseId => throw _privateConstructorUsedError; // Discogs release ID
  Release? get release =>
      throw _privateConstructorUsedError; // Full release details
  int get instanceId =>
      throw _privateConstructorUsedError; // Discogs instance ID
  int get folderId => throw _privateConstructorUsedError; // Discogs folder ID
  int get rating => throw _privateConstructorUsedError;
  Map<String, dynamic>? get notes =>
      throw _privateConstructorUsedError; // JSONB
  DateTime? get dateAdded => throw _privateConstructorUsedError;
  bool get active => throw _privateConstructorUsedError;
  List<PlayHistory> get playHistory => throw _privateConstructorUsedError;
  List<CleaningHistory> get cleaningHistory =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserReleaseCopyWith<UserRelease> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserReleaseCopyWith<$Res> {
  factory $UserReleaseCopyWith(
          UserRelease value, $Res Function(UserRelease) then) =
      _$UserReleaseCopyWithImpl<$Res, UserRelease>;
  @useResult
  $Res call(
      {String id,
      String userId,
      int releaseId,
      Release? release,
      int instanceId,
      int folderId,
      int rating,
      Map<String, dynamic>? notes,
      DateTime? dateAdded,
      bool active,
      List<PlayHistory> playHistory,
      List<CleaningHistory> cleaningHistory});
}

/// @nodoc
class _$UserReleaseCopyWithImpl<$Res, $Val extends UserRelease>
    implements $UserReleaseCopyWith<$Res> {
  _$UserReleaseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? releaseId = null,
    Object? release = freezed,
    Object? instanceId = null,
    Object? folderId = null,
    Object? rating = null,
    Object? notes = freezed,
    Object? dateAdded = freezed,
    Object? active = null,
    Object? playHistory = null,
    Object? cleaningHistory = null,
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
      releaseId: null == releaseId
          ? _value.releaseId
          : releaseId // ignore: cast_nullable_to_non_nullable
              as int,
      release: freezed == release
          ? _value.release
          : release // ignore: cast_nullable_to_non_nullable
              as Release?,
      instanceId: null == instanceId
          ? _value.instanceId
          : instanceId // ignore: cast_nullable_to_non_nullable
              as int,
      folderId: null == folderId
          ? _value.folderId
          : folderId // ignore: cast_nullable_to_non_nullable
              as int,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as int,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      dateAdded: freezed == dateAdded
          ? _value.dateAdded
          : dateAdded // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      active: null == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool,
      playHistory: null == playHistory
          ? _value.playHistory
          : playHistory // ignore: cast_nullable_to_non_nullable
              as List<PlayHistory>,
      cleaningHistory: null == cleaningHistory
          ? _value.cleaningHistory
          : cleaningHistory // ignore: cast_nullable_to_non_nullable
              as List<CleaningHistory>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserReleaseImplCopyWith<$Res>
    implements $UserReleaseCopyWith<$Res> {
  factory _$$UserReleaseImplCopyWith(
          _$UserReleaseImpl value, $Res Function(_$UserReleaseImpl) then) =
      __$$UserReleaseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      int releaseId,
      Release? release,
      int instanceId,
      int folderId,
      int rating,
      Map<String, dynamic>? notes,
      DateTime? dateAdded,
      bool active,
      List<PlayHistory> playHistory,
      List<CleaningHistory> cleaningHistory});
}

/// @nodoc
class __$$UserReleaseImplCopyWithImpl<$Res>
    extends _$UserReleaseCopyWithImpl<$Res, _$UserReleaseImpl>
    implements _$$UserReleaseImplCopyWith<$Res> {
  __$$UserReleaseImplCopyWithImpl(
      _$UserReleaseImpl _value, $Res Function(_$UserReleaseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? releaseId = null,
    Object? release = freezed,
    Object? instanceId = null,
    Object? folderId = null,
    Object? rating = null,
    Object? notes = freezed,
    Object? dateAdded = freezed,
    Object? active = null,
    Object? playHistory = null,
    Object? cleaningHistory = null,
  }) {
    return _then(_$UserReleaseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      releaseId: null == releaseId
          ? _value.releaseId
          : releaseId // ignore: cast_nullable_to_non_nullable
              as int,
      release: freezed == release
          ? _value.release
          : release // ignore: cast_nullable_to_non_nullable
              as Release?,
      instanceId: null == instanceId
          ? _value.instanceId
          : instanceId // ignore: cast_nullable_to_non_nullable
              as int,
      folderId: null == folderId
          ? _value.folderId
          : folderId // ignore: cast_nullable_to_non_nullable
              as int,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as int,
      notes: freezed == notes
          ? _value._notes
          : notes // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      dateAdded: freezed == dateAdded
          ? _value.dateAdded
          : dateAdded // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      active: null == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool,
      playHistory: null == playHistory
          ? _value._playHistory
          : playHistory // ignore: cast_nullable_to_non_nullable
              as List<PlayHistory>,
      cleaningHistory: null == cleaningHistory
          ? _value._cleaningHistory
          : cleaningHistory // ignore: cast_nullable_to_non_nullable
              as List<CleaningHistory>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserReleaseImpl implements _UserRelease {
  const _$UserReleaseImpl(
      {required this.id,
      required this.userId,
      required this.releaseId,
      this.release,
      required this.instanceId,
      required this.folderId,
      this.rating = 0,
      final Map<String, dynamic>? notes,
      this.dateAdded,
      this.active = true,
      final List<PlayHistory> playHistory = const [],
      final List<CleaningHistory> cleaningHistory = const []})
      : _notes = notes,
        _playHistory = playHistory,
        _cleaningHistory = cleaningHistory;

  factory _$UserReleaseImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserReleaseImplFromJson(json);

  @override
  final String id;
// UUID
  @override
  final String userId;
// UUID
  @override
  final int releaseId;
// Discogs release ID
  @override
  final Release? release;
// Full release details
  @override
  final int instanceId;
// Discogs instance ID
  @override
  final int folderId;
// Discogs folder ID
  @override
  @JsonKey()
  final int rating;
  final Map<String, dynamic>? _notes;
  @override
  Map<String, dynamic>? get notes {
    final value = _notes;
    if (value == null) return null;
    if (_notes is EqualUnmodifiableMapView) return _notes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

// JSONB
  @override
  final DateTime? dateAdded;
  @override
  @JsonKey()
  final bool active;
  final List<PlayHistory> _playHistory;
  @override
  @JsonKey()
  List<PlayHistory> get playHistory {
    if (_playHistory is EqualUnmodifiableListView) return _playHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_playHistory);
  }

  final List<CleaningHistory> _cleaningHistory;
  @override
  @JsonKey()
  List<CleaningHistory> get cleaningHistory {
    if (_cleaningHistory is EqualUnmodifiableListView) return _cleaningHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cleaningHistory);
  }

  @override
  String toString() {
    return 'UserRelease(id: $id, userId: $userId, releaseId: $releaseId, release: $release, instanceId: $instanceId, folderId: $folderId, rating: $rating, notes: $notes, dateAdded: $dateAdded, active: $active, playHistory: $playHistory, cleaningHistory: $cleaningHistory)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserReleaseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.releaseId, releaseId) ||
                other.releaseId == releaseId) &&
            (identical(other.release, release) || other.release == release) &&
            (identical(other.instanceId, instanceId) ||
                other.instanceId == instanceId) &&
            (identical(other.folderId, folderId) ||
                other.folderId == folderId) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            const DeepCollectionEquality().equals(other._notes, _notes) &&
            (identical(other.dateAdded, dateAdded) ||
                other.dateAdded == dateAdded) &&
            (identical(other.active, active) || other.active == active) &&
            const DeepCollectionEquality()
                .equals(other._playHistory, _playHistory) &&
            const DeepCollectionEquality()
                .equals(other._cleaningHistory, _cleaningHistory));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      releaseId,
      release,
      instanceId,
      folderId,
      rating,
      const DeepCollectionEquality().hash(_notes),
      dateAdded,
      active,
      const DeepCollectionEquality().hash(_playHistory),
      const DeepCollectionEquality().hash(_cleaningHistory));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserReleaseImplCopyWith<_$UserReleaseImpl> get copyWith =>
      __$$UserReleaseImplCopyWithImpl<_$UserReleaseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserReleaseImplToJson(
      this,
    );
  }
}

abstract class _UserRelease implements UserRelease {
  const factory _UserRelease(
      {required final String id,
      required final String userId,
      required final int releaseId,
      final Release? release,
      required final int instanceId,
      required final int folderId,
      final int rating,
      final Map<String, dynamic>? notes,
      final DateTime? dateAdded,
      final bool active,
      final List<PlayHistory> playHistory,
      final List<CleaningHistory> cleaningHistory}) = _$UserReleaseImpl;

  factory _UserRelease.fromJson(Map<String, dynamic> json) =
      _$UserReleaseImpl.fromJson;

  @override
  String get id;
  @override // UUID
  String get userId;
  @override // UUID
  int get releaseId;
  @override // Discogs release ID
  Release? get release;
  @override // Full release details
  int get instanceId;
  @override // Discogs instance ID
  int get folderId;
  @override // Discogs folder ID
  int get rating;
  @override
  Map<String, dynamic>? get notes;
  @override // JSONB
  DateTime? get dateAdded;
  @override
  bool get active;
  @override
  List<PlayHistory> get playHistory;
  @override
  List<CleaningHistory> get cleaningHistory;
  @override
  @JsonKey(ignore: true)
  _$$UserReleaseImplCopyWith<_$UserReleaseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
