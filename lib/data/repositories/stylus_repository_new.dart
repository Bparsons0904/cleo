import 'package:logger/logger.dart';
import '../services/api_client.dart';
import '../models/stylus_base.dart';
import '../models/user_stylus.dart';

/// Repository for stylus operations with Waugzee API
class StylusRepositoryNew {
  final ApiClient _apiClient;
  final Logger _logger = Logger();

  StylusRepositoryNew(this._apiClient);

  /// Get all available stylus templates (global)
  ///
  /// These are base stylus models that users can create instances from
  Future<List<StylusBase>> getAvailableStyluses() async {
    try {
      _logger.i('📥 Fetching available styluses');

      final response = await _apiClient.get('/styluses/available');

      if (response.statusCode == 200 && response.data != null) {
        final styluses = (response.data as List)
            .map((json) => StylusBase.fromJson(json))
            .toList();
        _logger.i('✅ Fetched ${styluses.length} available styluses');
        return styluses;
      }

      throw Exception('Failed to fetch available styluses: ${response.statusCode}');
    } catch (e, stackTrace) {
      _logger.e(
        '❌ Error fetching available styluses',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Create a custom stylus template
  ///
  /// [brand] - Stylus brand name
  /// [model] - Stylus model name
  /// [type] - Stylus tip type
  /// [cartridgeType] - Optional cartridge type
  /// [recommendedReplaceHours] - Optional recommended replacement hours
  Future<StylusBase> createCustomStylus({
    required String brand,
    required String model,
    required String type,
    String? cartridgeType,
    int? recommendedReplaceHours,
  }) async {
    try {
      _logger.i('➕ Creating custom stylus: $brand $model');

      final data = {
        'brand': brand,
        'model': model,
        'type': type,
        if (cartridgeType != null) 'cartridgeType': cartridgeType,
        if (recommendedReplaceHours != null)
          'recommendedReplaceHours': recommendedReplaceHours,
      };

      final response = await _apiClient.post('/styluses/custom', data: data);

      if (response.statusCode == 201 && response.data != null) {
        final stylus = StylusBase.fromJson(response.data);
        _logger.i('✅ Custom stylus created: ${stylus.id}');
        return stylus;
      }

      throw Exception('Failed to create custom stylus: ${response.statusCode}');
    } catch (e, stackTrace) {
      _logger.e(
        '❌ Error creating custom stylus',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Get user's stylus instances
  ///
  /// Returns all styluses owned by the current user
  /// Note: This is typically returned as part of /api/users/me
  Future<List<UserStylus>> getUserStyluses() async {
    try {
      _logger.i('📥 Fetching user styluses');

      final response = await _apiClient.get('/styluses');

      if (response.statusCode == 200 && response.data != null) {
        final styluses = (response.data as List)
            .map((json) => UserStylus.fromJson(json))
            .toList();
        _logger.i('✅ Fetched ${styluses.length} user styluses');
        return styluses;
      }

      throw Exception('Failed to fetch user styluses: ${response.statusCode}');
    } catch (e, stackTrace) {
      _logger.e(
        '❌ Error fetching user styluses',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Create a user stylus instance
  ///
  /// [stylusId] - UUID of the base stylus template
  /// [purchaseDate] - Optional purchase date
  /// [installDate] - Optional install date
  /// [hoursUsed] - Optional hours used
  /// [notes] - Optional notes
  /// [isActive] - Whether this stylus is currently active
  /// [isPrimary] - Whether this is the primary/default stylus
  Future<UserStylus> createUserStylus({
    required String stylusId,
    DateTime? purchaseDate,
    DateTime? installDate,
    double? hoursUsed,
    String? notes,
    bool isActive = true,
    bool isPrimary = false,
  }) async {
    try {
      _logger.i('➕ Creating user stylus instance');

      final data = {
        'stylusId': stylusId,
        if (purchaseDate != null) 'purchaseDate': purchaseDate.toIso8601String(),
        if (installDate != null) 'installDate': installDate.toIso8601String(),
        if (hoursUsed != null) 'hoursUsed': hoursUsed,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
        'isActive': isActive,
        'isPrimary': isPrimary,
      };

      final response = await _apiClient.post('/styluses', data: data);

      if (response.statusCode == 201 && response.data != null) {
        final userStylus = UserStylus.fromJson(response.data);
        _logger.i('✅ User stylus created: ${userStylus.id}');
        return userStylus;
      }

      throw Exception('Failed to create user stylus: ${response.statusCode}');
    } catch (e, stackTrace) {
      _logger.e(
        '❌ Error creating user stylus',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Update a user stylus instance
  ///
  /// [id] - UUID of the user stylus to update
  Future<UserStylus> updateUserStylus({
    required String id,
    DateTime? purchaseDate,
    DateTime? installDate,
    double? hoursUsed,
    String? notes,
    bool? isActive,
    bool? isPrimary,
  }) async {
    try {
      _logger.i('📝 Updating user stylus: $id');

      final data = <String, dynamic>{};
      if (purchaseDate != null) {
        data['purchaseDate'] = purchaseDate.toIso8601String();
      }
      if (installDate != null) {
        data['installDate'] = installDate.toIso8601String();
      }
      if (hoursUsed != null) data['hoursUsed'] = hoursUsed;
      if (notes != null) data['notes'] = notes;
      if (isActive != null) data['isActive'] = isActive;
      if (isPrimary != null) data['isPrimary'] = isPrimary;

      final response = await _apiClient.put('/styluses/$id', data: data);

      if (response.statusCode == 200 && response.data != null) {
        final userStylus = UserStylus.fromJson(response.data);
        _logger.i('✅ User stylus updated: $id');
        return userStylus;
      }

      throw Exception('Failed to update user stylus: ${response.statusCode}');
    } catch (e, stackTrace) {
      _logger.e(
        '❌ Error updating user stylus',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Delete a user stylus instance
  ///
  /// [id] - UUID of the user stylus to delete
  Future<void> deleteUserStylus(String id) async {
    try {
      _logger.i('🗑️ Deleting user stylus: $id');

      final response = await _apiClient.delete('/styluses/$id');

      if (response.statusCode == 204 || response.statusCode == 200) {
        _logger.i('✅ User stylus deleted: $id');
        return;
      }

      throw Exception('Failed to delete user stylus: ${response.statusCode}');
    } catch (e, stackTrace) {
      _logger.e(
        '❌ Error deleting user stylus',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
