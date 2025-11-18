// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'folder_new.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FolderNew _$FolderNewFromJson(Map<String, dynamic> json) {
  return _FolderNew.fromJson(json);
}

/// @nodoc
mixin _$FolderNew {
  int get id => throw _privateConstructorUsedError; // Discogs folder ID
  String get userId => throw _privateConstructorUsedError; // UUID
  String get name => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  String get resourceUrl => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FolderNewCopyWith<FolderNew> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FolderNewCopyWith<$Res> {
  factory $FolderNewCopyWith(FolderNew value, $Res Function(FolderNew) then) =
      _$FolderNewCopyWithImpl<$Res, FolderNew>;
  @useResult
  $Res call(
      {int id,
      String userId,
      String name,
      int count,
      String resourceUrl,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$FolderNewCopyWithImpl<$Res, $Val extends FolderNew>
    implements $FolderNewCopyWith<$Res> {
  _$FolderNewCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? count = null,
    Object? resourceUrl = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      resourceUrl: null == resourceUrl
          ? _value.resourceUrl
          : resourceUrl // ignore: cast_nullable_to_non_nullable
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
}

/// @nodoc
abstract class _$$FolderNewImplCopyWith<$Res>
    implements $FolderNewCopyWith<$Res> {
  factory _$$FolderNewImplCopyWith(
          _$FolderNewImpl value, $Res Function(_$FolderNewImpl) then) =
      __$$FolderNewImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String userId,
      String name,
      int count,
      String resourceUrl,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$FolderNewImplCopyWithImpl<$Res>
    extends _$FolderNewCopyWithImpl<$Res, _$FolderNewImpl>
    implements _$$FolderNewImplCopyWith<$Res> {
  __$$FolderNewImplCopyWithImpl(
      _$FolderNewImpl _value, $Res Function(_$FolderNewImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? count = null,
    Object? resourceUrl = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$FolderNewImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      resourceUrl: null == resourceUrl
          ? _value.resourceUrl
          : resourceUrl // ignore: cast_nullable_to_non_nullable
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
class _$FolderNewImpl implements _FolderNew {
  const _$FolderNewImpl(
      {required this.id,
      required this.userId,
      required this.name,
      this.count = 0,
      required this.resourceUrl,
      required this.createdAt,
      required this.updatedAt});

  factory _$FolderNewImpl.fromJson(Map<String, dynamic> json) =>
      _$$FolderNewImplFromJson(json);

  @override
  final int id;
// Discogs folder ID
  @override
  final String userId;
// UUID
  @override
  final String name;
  @override
  @JsonKey()
  final int count;
  @override
  final String resourceUrl;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'FolderNew(id: $id, userId: $userId, name: $name, count: $count, resourceUrl: $resourceUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FolderNewImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.resourceUrl, resourceUrl) ||
                other.resourceUrl == resourceUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, userId, name, count, resourceUrl, createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FolderNewImplCopyWith<_$FolderNewImpl> get copyWith =>
      __$$FolderNewImplCopyWithImpl<_$FolderNewImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FolderNewImplToJson(
      this,
    );
  }
}

abstract class _FolderNew implements FolderNew {
  const factory _FolderNew(
      {required final int id,
      required final String userId,
      required final String name,
      final int count,
      required final String resourceUrl,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$FolderNewImpl;

  factory _FolderNew.fromJson(Map<String, dynamic> json) =
      _$FolderNewImpl.fromJson;

  @override
  int get id;
  @override // Discogs folder ID
  String get userId;
  @override // UUID
  String get name;
  @override
  int get count;
  @override
  String get resourceUrl;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$FolderNewImplCopyWith<_$FolderNewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
