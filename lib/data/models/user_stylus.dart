import 'package:freezed_annotation/freezed_annotation.dart';
import 'stylus_base.dart';

part 'user_stylus.freezed.dart';
part 'user_stylus.g.dart';

/// UserStylus model - represents a user's instance of a stylus
/// Links to a StylusBase template and adds user-specific tracking data
@freezed
class UserStylus with _$UserStylus {
  const factory UserStylus({
    required String id, // UUID
    required String userId, // UUID
    required String stylusId, // UUID - references StylusBase
    StylusBase? stylus, // Full stylus details
    DateTime? purchaseDate,
    DateTime? installDate,
    @JsonKey(name: 'hoursUsed') double? hoursUsed,
    String? notes,
    @Default(true) bool isActive,
    @Default(false) bool isPrimary,
  }) = _UserStylus;

  factory UserStylus.fromJson(Map<String, dynamic> json) =>
      _$UserStylusFromJson(json);
}
