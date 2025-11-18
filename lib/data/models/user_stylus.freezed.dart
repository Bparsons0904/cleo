// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_stylus.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserStylus _$UserStylusFromJson(Map<String, dynamic> json) {
  return _UserStylus.fromJson(json);
}

/// @nodoc
mixin _$UserStylus {
  String get id => throw _privateConstructorUsedError; // UUID
  String get userId => throw _privateConstructorUsedError; // UUID
  String get stylusId =>
      throw _privateConstructorUsedError; // UUID - references StylusBase
  StylusBase? get stylus =>
      throw _privateConstructorUsedError; // Full stylus details
  DateTime? get purchaseDate => throw _privateConstructorUsedError;
  DateTime? get installDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'hoursUsed')
  double? get hoursUsed => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get isPrimary => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserStylusCopyWith<UserStylus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserStylusCopyWith<$Res> {
  factory $UserStylusCopyWith(
          UserStylus value, $Res Function(UserStylus) then) =
      _$UserStylusCopyWithImpl<$Res, UserStylus>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String stylusId,
      StylusBase? stylus,
      DateTime? purchaseDate,
      DateTime? installDate,
      @JsonKey(name: 'hoursUsed') double? hoursUsed,
      String? notes,
      bool isActive,
      bool isPrimary});

  $StylusBaseCopyWith<$Res>? get stylus;
}

/// @nodoc
class _$UserStylusCopyWithImpl<$Res, $Val extends UserStylus>
    implements $UserStylusCopyWith<$Res> {
  _$UserStylusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? stylusId = null,
    Object? stylus = freezed,
    Object? purchaseDate = freezed,
    Object? installDate = freezed,
    Object? hoursUsed = freezed,
    Object? notes = freezed,
    Object? isActive = null,
    Object? isPrimary = null,
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
      stylusId: null == stylusId
          ? _value.stylusId
          : stylusId // ignore: cast_nullable_to_non_nullable
              as String,
      stylus: freezed == stylus
          ? _value.stylus
          : stylus // ignore: cast_nullable_to_non_nullable
              as StylusBase?,
      purchaseDate: freezed == purchaseDate
          ? _value.purchaseDate
          : purchaseDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      installDate: freezed == installDate
          ? _value.installDate
          : installDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      hoursUsed: freezed == hoursUsed
          ? _value.hoursUsed
          : hoursUsed // ignore: cast_nullable_to_non_nullable
              as double?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isPrimary: null == isPrimary
          ? _value.isPrimary
          : isPrimary // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $StylusBaseCopyWith<$Res>? get stylus {
    if (_value.stylus == null) {
      return null;
    }

    return $StylusBaseCopyWith<$Res>(_value.stylus!, (value) {
      return _then(_value.copyWith(stylus: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserStylusImplCopyWith<$Res>
    implements $UserStylusCopyWith<$Res> {
  factory _$$UserStylusImplCopyWith(
          _$UserStylusImpl value, $Res Function(_$UserStylusImpl) then) =
      __$$UserStylusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String stylusId,
      StylusBase? stylus,
      DateTime? purchaseDate,
      DateTime? installDate,
      @JsonKey(name: 'hoursUsed') double? hoursUsed,
      String? notes,
      bool isActive,
      bool isPrimary});

  @override
  $StylusBaseCopyWith<$Res>? get stylus;
}

/// @nodoc
class __$$UserStylusImplCopyWithImpl<$Res>
    extends _$UserStylusCopyWithImpl<$Res, _$UserStylusImpl>
    implements _$$UserStylusImplCopyWith<$Res> {
  __$$UserStylusImplCopyWithImpl(
      _$UserStylusImpl _value, $Res Function(_$UserStylusImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? stylusId = null,
    Object? stylus = freezed,
    Object? purchaseDate = freezed,
    Object? installDate = freezed,
    Object? hoursUsed = freezed,
    Object? notes = freezed,
    Object? isActive = null,
    Object? isPrimary = null,
  }) {
    return _then(_$UserStylusImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      stylusId: null == stylusId
          ? _value.stylusId
          : stylusId // ignore: cast_nullable_to_non_nullable
              as String,
      stylus: freezed == stylus
          ? _value.stylus
          : stylus // ignore: cast_nullable_to_non_nullable
              as StylusBase?,
      purchaseDate: freezed == purchaseDate
          ? _value.purchaseDate
          : purchaseDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      installDate: freezed == installDate
          ? _value.installDate
          : installDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      hoursUsed: freezed == hoursUsed
          ? _value.hoursUsed
          : hoursUsed // ignore: cast_nullable_to_non_nullable
              as double?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isPrimary: null == isPrimary
          ? _value.isPrimary
          : isPrimary // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserStylusImpl implements _UserStylus {
  const _$UserStylusImpl(
      {required this.id,
      required this.userId,
      required this.stylusId,
      this.stylus,
      this.purchaseDate,
      this.installDate,
      @JsonKey(name: 'hoursUsed') this.hoursUsed,
      this.notes,
      this.isActive = true,
      this.isPrimary = false});

  factory _$UserStylusImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserStylusImplFromJson(json);

  @override
  final String id;
// UUID
  @override
  final String userId;
// UUID
  @override
  final String stylusId;
// UUID - references StylusBase
  @override
  final StylusBase? stylus;
// Full stylus details
  @override
  final DateTime? purchaseDate;
  @override
  final DateTime? installDate;
  @override
  @JsonKey(name: 'hoursUsed')
  final double? hoursUsed;
  @override
  final String? notes;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final bool isPrimary;

  @override
  String toString() {
    return 'UserStylus(id: $id, userId: $userId, stylusId: $stylusId, stylus: $stylus, purchaseDate: $purchaseDate, installDate: $installDate, hoursUsed: $hoursUsed, notes: $notes, isActive: $isActive, isPrimary: $isPrimary)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserStylusImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.stylusId, stylusId) ||
                other.stylusId == stylusId) &&
            (identical(other.stylus, stylus) || other.stylus == stylus) &&
            (identical(other.purchaseDate, purchaseDate) ||
                other.purchaseDate == purchaseDate) &&
            (identical(other.installDate, installDate) ||
                other.installDate == installDate) &&
            (identical(other.hoursUsed, hoursUsed) ||
                other.hoursUsed == hoursUsed) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isPrimary, isPrimary) ||
                other.isPrimary == isPrimary));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, stylusId, stylus,
      purchaseDate, installDate, hoursUsed, notes, isActive, isPrimary);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserStylusImplCopyWith<_$UserStylusImpl> get copyWith =>
      __$$UserStylusImplCopyWithImpl<_$UserStylusImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserStylusImplToJson(
      this,
    );
  }
}

abstract class _UserStylus implements UserStylus {
  const factory _UserStylus(
      {required final String id,
      required final String userId,
      required final String stylusId,
      final StylusBase? stylus,
      final DateTime? purchaseDate,
      final DateTime? installDate,
      @JsonKey(name: 'hoursUsed') final double? hoursUsed,
      final String? notes,
      final bool isActive,
      final bool isPrimary}) = _$UserStylusImpl;

  factory _UserStylus.fromJson(Map<String, dynamic> json) =
      _$UserStylusImpl.fromJson;

  @override
  String get id;
  @override // UUID
  String get userId;
  @override // UUID
  String get stylusId;
  @override // UUID - references StylusBase
  StylusBase? get stylus;
  @override // Full stylus details
  DateTime? get purchaseDate;
  @override
  DateTime? get installDate;
  @override
  @JsonKey(name: 'hoursUsed')
  double? get hoursUsed;
  @override
  String? get notes;
  @override
  bool get isActive;
  @override
  bool get isPrimary;
  @override
  @JsonKey(ignore: true)
  _$$UserStylusImplCopyWith<_$UserStylusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
