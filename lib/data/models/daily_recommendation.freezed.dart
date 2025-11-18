// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_recommendation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DailyRecommendation _$DailyRecommendationFromJson(Map<String, dynamic> json) {
  return _DailyRecommendation.fromJson(json);
}

/// @nodoc
mixin _$DailyRecommendation {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get userReleaseId =>
      throw _privateConstructorUsedError; // Note: userRelease will be populated with full Release details
  Map<String, dynamic>? get userRelease => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  DateTime? get listenedAt => throw _privateConstructorUsedError;
  RecommendationAlgorithm get algorithm => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DailyRecommendationCopyWith<DailyRecommendation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyRecommendationCopyWith<$Res> {
  factory $DailyRecommendationCopyWith(
          DailyRecommendation value, $Res Function(DailyRecommendation) then) =
      _$DailyRecommendationCopyWithImpl<$Res, DailyRecommendation>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String userReleaseId,
      Map<String, dynamic>? userRelease,
      DateTime date,
      DateTime? listenedAt,
      RecommendationAlgorithm algorithm});
}

/// @nodoc
class _$DailyRecommendationCopyWithImpl<$Res, $Val extends DailyRecommendation>
    implements $DailyRecommendationCopyWith<$Res> {
  _$DailyRecommendationCopyWithImpl(this._value, this._then);

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
    Object? date = null,
    Object? listenedAt = freezed,
    Object? algorithm = null,
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
              as Map<String, dynamic>?,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      listenedAt: freezed == listenedAt
          ? _value.listenedAt
          : listenedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      algorithm: null == algorithm
          ? _value.algorithm
          : algorithm // ignore: cast_nullable_to_non_nullable
              as RecommendationAlgorithm,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DailyRecommendationImplCopyWith<$Res>
    implements $DailyRecommendationCopyWith<$Res> {
  factory _$$DailyRecommendationImplCopyWith(_$DailyRecommendationImpl value,
          $Res Function(_$DailyRecommendationImpl) then) =
      __$$DailyRecommendationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String userReleaseId,
      Map<String, dynamic>? userRelease,
      DateTime date,
      DateTime? listenedAt,
      RecommendationAlgorithm algorithm});
}

/// @nodoc
class __$$DailyRecommendationImplCopyWithImpl<$Res>
    extends _$DailyRecommendationCopyWithImpl<$Res, _$DailyRecommendationImpl>
    implements _$$DailyRecommendationImplCopyWith<$Res> {
  __$$DailyRecommendationImplCopyWithImpl(_$DailyRecommendationImpl _value,
      $Res Function(_$DailyRecommendationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? userReleaseId = null,
    Object? userRelease = freezed,
    Object? date = null,
    Object? listenedAt = freezed,
    Object? algorithm = null,
  }) {
    return _then(_$DailyRecommendationImpl(
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
          ? _value._userRelease
          : userRelease // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      listenedAt: freezed == listenedAt
          ? _value.listenedAt
          : listenedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      algorithm: null == algorithm
          ? _value.algorithm
          : algorithm // ignore: cast_nullable_to_non_nullable
              as RecommendationAlgorithm,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyRecommendationImpl implements _DailyRecommendation {
  const _$DailyRecommendationImpl(
      {required this.id,
      required this.userId,
      required this.userReleaseId,
      final Map<String, dynamic>? userRelease,
      required this.date,
      this.listenedAt,
      this.algorithm = RecommendationAlgorithm.smart})
      : _userRelease = userRelease;

  factory _$DailyRecommendationImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyRecommendationImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String userReleaseId;
// Note: userRelease will be populated with full Release details
  final Map<String, dynamic>? _userRelease;
// Note: userRelease will be populated with full Release details
  @override
  Map<String, dynamic>? get userRelease {
    final value = _userRelease;
    if (value == null) return null;
    if (_userRelease is EqualUnmodifiableMapView) return _userRelease;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final DateTime date;
  @override
  final DateTime? listenedAt;
  @override
  @JsonKey()
  final RecommendationAlgorithm algorithm;

  @override
  String toString() {
    return 'DailyRecommendation(id: $id, userId: $userId, userReleaseId: $userReleaseId, userRelease: $userRelease, date: $date, listenedAt: $listenedAt, algorithm: $algorithm)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyRecommendationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userReleaseId, userReleaseId) ||
                other.userReleaseId == userReleaseId) &&
            const DeepCollectionEquality()
                .equals(other._userRelease, _userRelease) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.listenedAt, listenedAt) ||
                other.listenedAt == listenedAt) &&
            (identical(other.algorithm, algorithm) ||
                other.algorithm == algorithm));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      userReleaseId,
      const DeepCollectionEquality().hash(_userRelease),
      date,
      listenedAt,
      algorithm);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyRecommendationImplCopyWith<_$DailyRecommendationImpl> get copyWith =>
      __$$DailyRecommendationImplCopyWithImpl<_$DailyRecommendationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyRecommendationImplToJson(
      this,
    );
  }
}

abstract class _DailyRecommendation implements DailyRecommendation {
  const factory _DailyRecommendation(
      {required final String id,
      required final String userId,
      required final String userReleaseId,
      final Map<String, dynamic>? userRelease,
      required final DateTime date,
      final DateTime? listenedAt,
      final RecommendationAlgorithm algorithm}) = _$DailyRecommendationImpl;

  factory _DailyRecommendation.fromJson(Map<String, dynamic> json) =
      _$DailyRecommendationImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get userReleaseId;
  @override // Note: userRelease will be populated with full Release details
  Map<String, dynamic>? get userRelease;
  @override
  DateTime get date;
  @override
  DateTime? get listenedAt;
  @override
  RecommendationAlgorithm get algorithm;
  @override
  @JsonKey(ignore: true)
  _$$DailyRecommendationImplCopyWith<_$DailyRecommendationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
