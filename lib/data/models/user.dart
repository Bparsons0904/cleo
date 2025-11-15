import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_configuration.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// User model representing authenticated user data from Waugzee API
@freezed
class User with _$User {
  const factory User({
    required String id,
    String? firstName,
    String? lastName,
    required String fullName,
    String? displayName,
    String? email,
    @Default(false) bool isAdmin,
    @Default(true) bool isActive,
    DateTime? lastLoginAt,
    @Default(false) bool profileVerified,
    UserConfiguration? configuration,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
