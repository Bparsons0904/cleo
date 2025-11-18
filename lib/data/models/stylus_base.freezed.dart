// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stylus_base.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StylusBase _$StylusBaseFromJson(Map<String, dynamic> json) {
  return _StylusBase.fromJson(json);
}

/// @nodoc
mixin _$StylusBase {
  String get id => throw _privateConstructorUsedError; // UUID
  String get brand => throw _privateConstructorUsedError;
  String get model => throw _privateConstructorUsedError;
  StylusType get type => throw _privateConstructorUsedError;
  CartridgeType? get cartridgeType => throw _privateConstructorUsedError;
  int? get recommendedReplaceHours => throw _privateConstructorUsedError;
  String? get userGeneratedId =>
      throw _privateConstructorUsedError; // UUID of user who created (for custom styluses)
  bool get isVerified => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StylusBaseCopyWith<StylusBase> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StylusBaseCopyWith<$Res> {
  factory $StylusBaseCopyWith(
          StylusBase value, $Res Function(StylusBase) then) =
      _$StylusBaseCopyWithImpl<$Res, StylusBase>;
  @useResult
  $Res call(
      {String id,
      String brand,
      String model,
      StylusType type,
      CartridgeType? cartridgeType,
      int? recommendedReplaceHours,
      String? userGeneratedId,
      bool isVerified});
}

/// @nodoc
class _$StylusBaseCopyWithImpl<$Res, $Val extends StylusBase>
    implements $StylusBaseCopyWith<$Res> {
  _$StylusBaseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? brand = null,
    Object? model = null,
    Object? type = null,
    Object? cartridgeType = freezed,
    Object? recommendedReplaceHours = freezed,
    Object? userGeneratedId = freezed,
    Object? isVerified = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      brand: null == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String,
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as StylusType,
      cartridgeType: freezed == cartridgeType
          ? _value.cartridgeType
          : cartridgeType // ignore: cast_nullable_to_non_nullable
              as CartridgeType?,
      recommendedReplaceHours: freezed == recommendedReplaceHours
          ? _value.recommendedReplaceHours
          : recommendedReplaceHours // ignore: cast_nullable_to_non_nullable
              as int?,
      userGeneratedId: freezed == userGeneratedId
          ? _value.userGeneratedId
          : userGeneratedId // ignore: cast_nullable_to_non_nullable
              as String?,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StylusBaseImplCopyWith<$Res>
    implements $StylusBaseCopyWith<$Res> {
  factory _$$StylusBaseImplCopyWith(
          _$StylusBaseImpl value, $Res Function(_$StylusBaseImpl) then) =
      __$$StylusBaseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String brand,
      String model,
      StylusType type,
      CartridgeType? cartridgeType,
      int? recommendedReplaceHours,
      String? userGeneratedId,
      bool isVerified});
}

/// @nodoc
class __$$StylusBaseImplCopyWithImpl<$Res>
    extends _$StylusBaseCopyWithImpl<$Res, _$StylusBaseImpl>
    implements _$$StylusBaseImplCopyWith<$Res> {
  __$$StylusBaseImplCopyWithImpl(
      _$StylusBaseImpl _value, $Res Function(_$StylusBaseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? brand = null,
    Object? model = null,
    Object? type = null,
    Object? cartridgeType = freezed,
    Object? recommendedReplaceHours = freezed,
    Object? userGeneratedId = freezed,
    Object? isVerified = null,
  }) {
    return _then(_$StylusBaseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      brand: null == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String,
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as StylusType,
      cartridgeType: freezed == cartridgeType
          ? _value.cartridgeType
          : cartridgeType // ignore: cast_nullable_to_non_nullable
              as CartridgeType?,
      recommendedReplaceHours: freezed == recommendedReplaceHours
          ? _value.recommendedReplaceHours
          : recommendedReplaceHours // ignore: cast_nullable_to_non_nullable
              as int?,
      userGeneratedId: freezed == userGeneratedId
          ? _value.userGeneratedId
          : userGeneratedId // ignore: cast_nullable_to_non_nullable
              as String?,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StylusBaseImpl implements _StylusBase {
  const _$StylusBaseImpl(
      {required this.id,
      required this.brand,
      required this.model,
      required this.type,
      this.cartridgeType,
      this.recommendedReplaceHours = 1000,
      this.userGeneratedId,
      this.isVerified = false});

  factory _$StylusBaseImpl.fromJson(Map<String, dynamic> json) =>
      _$$StylusBaseImplFromJson(json);

  @override
  final String id;
// UUID
  @override
  final String brand;
  @override
  final String model;
  @override
  final StylusType type;
  @override
  final CartridgeType? cartridgeType;
  @override
  @JsonKey()
  final int? recommendedReplaceHours;
  @override
  final String? userGeneratedId;
// UUID of user who created (for custom styluses)
  @override
  @JsonKey()
  final bool isVerified;

  @override
  String toString() {
    return 'StylusBase(id: $id, brand: $brand, model: $model, type: $type, cartridgeType: $cartridgeType, recommendedReplaceHours: $recommendedReplaceHours, userGeneratedId: $userGeneratedId, isVerified: $isVerified)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StylusBaseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.cartridgeType, cartridgeType) ||
                other.cartridgeType == cartridgeType) &&
            (identical(
                    other.recommendedReplaceHours, recommendedReplaceHours) ||
                other.recommendedReplaceHours == recommendedReplaceHours) &&
            (identical(other.userGeneratedId, userGeneratedId) ||
                other.userGeneratedId == userGeneratedId) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, brand, model, type,
      cartridgeType, recommendedReplaceHours, userGeneratedId, isVerified);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StylusBaseImplCopyWith<_$StylusBaseImpl> get copyWith =>
      __$$StylusBaseImplCopyWithImpl<_$StylusBaseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StylusBaseImplToJson(
      this,
    );
  }
}

abstract class _StylusBase implements StylusBase {
  const factory _StylusBase(
      {required final String id,
      required final String brand,
      required final String model,
      required final StylusType type,
      final CartridgeType? cartridgeType,
      final int? recommendedReplaceHours,
      final String? userGeneratedId,
      final bool isVerified}) = _$StylusBaseImpl;

  factory _StylusBase.fromJson(Map<String, dynamic> json) =
      _$StylusBaseImpl.fromJson;

  @override
  String get id;
  @override // UUID
  String get brand;
  @override
  String get model;
  @override
  StylusType get type;
  @override
  CartridgeType? get cartridgeType;
  @override
  int? get recommendedReplaceHours;
  @override
  String? get userGeneratedId;
  @override // UUID of user who created (for custom styluses)
  bool get isVerified;
  @override
  @JsonKey(ignore: true)
  _$$StylusBaseImplCopyWith<_$StylusBaseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
