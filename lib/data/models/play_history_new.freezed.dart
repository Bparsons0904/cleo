// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'play_history_new.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PlayHistoryNew _$PlayHistoryNewFromJson(Map<String, dynamic> json) {
  return _PlayHistoryNew.fromJson(json);
}

/// @nodoc
mixin _$PlayHistoryNew {
  String get id => throw _privateConstructorUsedError; // UUID
  String get userId => throw _privateConstructorUsedError; // UUID
  String get userReleaseId => throw _privateConstructorUsedError; // UUID
  UserRelease? get userRelease =>
      throw _privateConstructorUsedError; // Full release details
  String? get userStylusId =>
      throw _privateConstructorUsedError; // UUID (nullable)
  UserStylus? get userStylus =>
      throw _privateConstructorUsedError; // Full stylus details
  DateTime get playedAt => throw _privateConstructorUsedError; // RFC3339 format
  String get notes => throw _privateConstructorUsedError; // Max 1000 characters
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlayHistoryNewCopyWith<PlayHistoryNew> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayHistoryNewCopyWith<$Res> {
  factory $PlayHistoryNewCopyWith(
          PlayHistoryNew value, $Res Function(PlayHistoryNew) then) =
      _$PlayHistoryNewCopyWithImpl<$Res, PlayHistoryNew>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String userReleaseId,
      UserRelease? userRelease,
      String? userStylusId,
      UserStylus? userStylus,
      DateTime playedAt,
      String notes,
      DateTime createdAt,
      DateTime updatedAt});

  $UserReleaseCopyWith<$Res>? get userRelease;
  $UserStylusCopyWith<$Res>? get userStylus;
}

/// @nodoc
class _$PlayHistoryNewCopyWithImpl<$Res, $Val extends PlayHistoryNew>
    implements $PlayHistoryNewCopyWith<$Res> {
  _$PlayHistoryNewCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? userReleaseId = null,
    Object? userRelease = freezed,
    Object? userStylusId = freezed,
    Object? userStylus = freezed,
    Object? playedAt = null,
    Object? notes = null,
    Object? createdAt = null,
    Object? updatedAt = null,
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
      userReleaseId: null == userReleaseId
          ? _value.userReleaseId
          : userReleaseId // ignore: cast_nullable_to_non_nullable
              as String,
      userRelease: freezed == userRelease
          ? _value.userRelease
          : userRelease // ignore: cast_nullable_to_non_nullable
              as UserRelease?,
      userStylusId: freezed == userStylusId
          ? _value.userStylusId
          : userStylusId // ignore: cast_nullable_to_non_nullable
              as String?,
      userStylus: freezed == userStylus
          ? _value.userStylus
          : userStylus // ignore: cast_nullable_to_non_nullable
              as UserStylus?,
      playedAt: null == playedAt
          ? _value.playedAt
          : playedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserReleaseCopyWith<$Res>? get userRelease {
    if (_value.userRelease == null) {
      return null;
    }

    return $UserReleaseCopyWith<$Res>(_value.userRelease!, (value) {
      return _then(_value.copyWith(userRelease: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $UserStylusCopyWith<$Res>? get userStylus {
    if (_value.userStylus == null) {
      return null;
    }

    return $UserStylusCopyWith<$Res>(_value.userStylus!, (value) {
      return _then(_value.copyWith(userStylus: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PlayHistoryNewImplCopyWith<$Res>
    implements $PlayHistoryNewCopyWith<$Res> {
  factory _$$PlayHistoryNewImplCopyWith(_$PlayHistoryNewImpl value,
          $Res Function(_$PlayHistoryNewImpl) then) =
      __$$PlayHistoryNewImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String userReleaseId,
      UserRelease? userRelease,
      String? userStylusId,
      UserStylus? userStylus,
      DateTime playedAt,
      String notes,
      DateTime createdAt,
      DateTime updatedAt});

  @override
  $UserReleaseCopyWith<$Res>? get userRelease;
  @override
  $UserStylusCopyWith<$Res>? get userStylus;
}

/// @nodoc
class __$$PlayHistoryNewImplCopyWithImpl<$Res>
    extends _$PlayHistoryNewCopyWithImpl<$Res, _$PlayHistoryNewImpl>
    implements _$$PlayHistoryNewImplCopyWith<$Res> {
  __$$PlayHistoryNewImplCopyWithImpl(
      _$PlayHistoryNewImpl _value, $Res Function(_$PlayHistoryNewImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? userReleaseId = null,
    Object? userRelease = freezed,
    Object? userStylusId = freezed,
    Object? userStylus = freezed,
    Object? playedAt = null,
    Object? notes = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$PlayHistoryNewImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userReleaseId: null == userReleaseId
          ? _value.userReleaseId
          : userReleaseId // ignore: cast_nullable_to_non_nullable
              as String,
      userRelease: freezed == userRelease
          ? _value.userRelease
          : userRelease // ignore: cast_nullable_to_non_nullable
              as UserRelease?,
      userStylusId: freezed == userStylusId
          ? _value.userStylusId
          : userStylusId // ignore: cast_nullable_to_non_nullable
              as String?,
      userStylus: freezed == userStylus
          ? _value.userStylus
          : userStylus // ignore: cast_nullable_to_non_nullable
              as UserStylus?,
      playedAt: null == playedAt
          ? _value.playedAt
          : playedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlayHistoryNewImpl implements _PlayHistoryNew {
  const _$PlayHistoryNewImpl(
      {required this.id,
      required this.userId,
      required this.userReleaseId,
      this.userRelease,
      this.userStylusId,
      this.userStylus,
      required this.playedAt,
      this.notes = '',
      required this.createdAt,
      required this.updatedAt});

  factory _$PlayHistoryNewImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlayHistoryNewImplFromJson(json);

  @override
  final String id;
// UUID
  @override
  final String userId;
// UUID
  @override
  final String userReleaseId;
// UUID
  @override
  final UserRelease? userRelease;
// Full release details
  @override
  final String? userStylusId;
// UUID (nullable)
  @override
  final UserStylus? userStylus;
// Full stylus details
  @override
  final DateTime playedAt;
// RFC3339 format
  @override
  @JsonKey()
  final String notes;
// Max 1000 characters
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'PlayHistoryNew(id: $id, userId: $userId, userReleaseId: $userReleaseId, userRelease: $userRelease, userStylusId: $userStylusId, userStylus: $userStylus, playedAt: $playedAt, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayHistoryNewImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userReleaseId, userReleaseId) ||
                other.userReleaseId == userReleaseId) &&
            (identical(other.userRelease, userRelease) ||
                other.userRelease == userRelease) &&
            (identical(other.userStylusId, userStylusId) ||
                other.userStylusId == userStylusId) &&
            (identical(other.userStylus, userStylus) ||
                other.userStylus == userStylus) &&
            (identical(other.playedAt, playedAt) ||
                other.playedAt == playedAt) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      userReleaseId,
      userRelease,
      userStylusId,
      userStylus,
      playedAt,
      notes,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayHistoryNewImplCopyWith<_$PlayHistoryNewImpl> get copyWith =>
      __$$PlayHistoryNewImplCopyWithImpl<_$PlayHistoryNewImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlayHistoryNewImplToJson(
      this,
    );
  }
}

abstract class _PlayHistoryNew implements PlayHistoryNew {
  const factory _PlayHistoryNew(
      {required final String id,
      required final String userId,
      required final String userReleaseId,
      final UserRelease? userRelease,
      final String? userStylusId,
      final UserStylus? userStylus,
      required final DateTime playedAt,
      final String notes,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$PlayHistoryNewImpl;

  factory _PlayHistoryNew.fromJson(Map<String, dynamic> json) =
      _$PlayHistoryNewImpl.fromJson;

  @override
  String get id;
  @override // UUID
  String get userId;
  @override // UUID
  String get userReleaseId;
  @override // UUID
  UserRelease? get userRelease;
  @override // Full release details
  String? get userStylusId;
  @override // UUID (nullable)
  UserStylus? get userStylus;
  @override // Full stylus details
  DateTime get playedAt;
  @override // RFC3339 format
  String get notes;
  @override // Max 1000 characters
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$PlayHistoryNewImplCopyWith<_$PlayHistoryNewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
