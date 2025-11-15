import 'package:freezed_annotation/freezed_annotation.dart';
import 'stylus_type.dart';

part 'stylus_base.freezed.dart';
part 'stylus_base.g.dart';

/// Base Stylus model - represents global stylus templates
/// These are available to all users as templates for creating UserStylus entries
@freezed
class StylusBase with _$StylusBase {
  const factory StylusBase({
    required String id, // UUID
    required String brand,
    required String model,
    required StylusType type,
    CartridgeType? cartridgeType,
    @Default(1000) int? recommendedReplaceHours,
    String? userGeneratedId, // UUID of user who created (for custom styluses)
    @Default(false) bool isVerified,
  }) = _StylusBase;

  factory StylusBase.fromJson(Map<String, dynamic> json) =>
      _$StylusBaseFromJson(json);
}
