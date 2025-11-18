// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cleaning_history_new.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CleaningHistoryNew _$CleaningHistoryNewFromJson(Map<String, dynamic> json) {
  return _CleaningHistoryNew.fromJson(json);
}

/// @nodoc
mixin _$CleaningHistoryNew {
  String get id => throw _privateConstructorUsedError; // UUID
  String get userId => throw _privateConstructorUsedError; // UUID
  String get userReleaseId => throw _privateConstructorUsedError; // UUID
  UserRelease? get userRelease =>
      throw _privateConstructorUsedError; // Full release details
  DateTime get cleanedAt =>
      throw _privateConstructorUsedError; // RFC3339 format
  String get notes => throw _privateConstructorUsedError; // Max 1000 characters
  bool get isDeepClean => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CleaningHistoryNewCopyWith<CleaningHistoryNew> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CleaningHistoryNewCopyWith<$Res> {
  factory $CleaningHistoryNewCopyWith(
          CleaningHistoryNew value, $Res Function(CleaningHistoryNew) then) =
      _$CleaningHistoryNewCopyWithImpl<$Res, CleaningHistoryNew>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String userReleaseId,
      UserRelease? userRelease,
      DateTime cleanedAt,
      String notes,
      bool isDeepClean,
      DateTime createdAt,
      DateTime updatedAt});

  $UserReleaseCopyWith<$Res>? get userRelease;
}

/// @nodoc
class _$CleaningHistoryNewCopyWithImpl<$Res, $Val extends CleaningHistoryNew>
    implements $CleaningHistoryNewCopyWith<$Res> {
  _$CleaningHistoryNewCopyWithImpl(this._value, this._then);

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
    Object? cleanedAt = null,
    Object? notes = null,
    Object? isDeepClean = null,
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
      cleanedAt: null == cleanedAt
          ? _value.cleanedAt
          : cleanedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      isDeepClean: null == isDeepClean
          ? _value.isDeepClean
          : isDeepClean // ignore: cast_nullable_to_non_nullable
              as bool,
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
}

/// @nodoc
abstract class _$$CleaningHistoryNewImplCopyWith<$Res>
    implements $CleaningHistoryNewCopyWith<$Res> {
  factory _$$CleaningHistoryNewImplCopyWith(_$CleaningHistoryNewImpl value,
          $Res Function(_$CleaningHistoryNewImpl) then) =
      __$$CleaningHistoryNewImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String userReleaseId,
      UserRelease? userRelease,
      DateTime cleanedAt,
      String notes,
      bool isDeepClean,
      DateTime createdAt,
      DateTime updatedAt});

  @override
  $UserReleaseCopyWith<$Res>? get userRelease;
}

/// @nodoc
class __$$CleaningHistoryNewImplCopyWithImpl<$Res>
    extends _$CleaningHistoryNewCopyWithImpl<$Res, _$CleaningHistoryNewImpl>
    implements _$$CleaningHistoryNewImplCopyWith<$Res> {
  __$$CleaningHistoryNewImplCopyWithImpl(_$CleaningHistoryNewImpl _value,
      $Res Function(_$CleaningHistoryNewImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? userReleaseId = null,
    Object? userRelease = freezed,
    Object? cleanedAt = null,
    Object? notes = null,
    Object? isDeepClean = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$CleaningHistoryNewImpl(
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
      cleanedAt: null == cleanedAt
          ? _value.cleanedAt
          : cleanedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      isDeepClean: null == isDeepClean
          ? _value.isDeepClean
          : isDeepClean // ignore: cast_nullable_to_non_nullable
              as bool,
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
class _$CleaningHistoryNewImpl implements _CleaningHistoryNew {
  const _$CleaningHistoryNewImpl(
      {required this.id,
      required this.userId,
      required this.userReleaseId,
      this.userRelease,
      required this.cleanedAt,
      this.notes = '',
      this.isDeepClean = false,
      required this.createdAt,
      required this.updatedAt});

  factory _$CleaningHistoryNewImpl.fromJson(Map<String, dynamic> json) =>
      _$$CleaningHistoryNewImplFromJson(json);

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
  final DateTime cleanedAt;
// RFC3339 format
  @override
  @JsonKey()
  final String notes;
// Max 1000 characters
  @override
  @JsonKey()
  final bool isDeepClean;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'CleaningHistoryNew(id: $id, userId: $userId, userReleaseId: $userReleaseId, userRelease: $userRelease, cleanedAt: $cleanedAt, notes: $notes, isDeepClean: $isDeepClean, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CleaningHistoryNewImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userReleaseId, userReleaseId) ||
                other.userReleaseId == userReleaseId) &&
            (identical(other.userRelease, userRelease) ||
                other.userRelease == userRelease) &&
            (identical(other.cleanedAt, cleanedAt) ||
                other.cleanedAt == cleanedAt) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.isDeepClean, isDeepClean) ||
                other.isDeepClean == isDeepClean) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, userReleaseId,
      userRelease, cleanedAt, notes, isDeepClean, createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CleaningHistoryNewImplCopyWith<_$CleaningHistoryNewImpl> get copyWith =>
      __$$CleaningHistoryNewImplCopyWithImpl<_$CleaningHistoryNewImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CleaningHistoryNewImplToJson(
      this,
    );
  }
}

abstract class _CleaningHistoryNew implements CleaningHistoryNew {
  const factory _CleaningHistoryNew(
      {required final String id,
      required final String userId,
      required final String userReleaseId,
      final UserRelease? userRelease,
      required final DateTime cleanedAt,
      final String notes,
      final bool isDeepClean,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$CleaningHistoryNewImpl;

  factory _CleaningHistoryNew.fromJson(Map<String, dynamic> json) =
      _$CleaningHistoryNewImpl.fromJson;

  @override
  String get id;
  @override // UUID
  String get userId;
  @override // UUID
  String get userReleaseId;
  @override // UUID
  UserRelease? get userRelease;
  @override // Full release details
  DateTime get cleanedAt;
  @override // RFC3339 format
  String get notes;
  @override // Max 1000 characters
  bool get isDeepClean;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$CleaningHistoryNewImplCopyWith<_$CleaningHistoryNewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
