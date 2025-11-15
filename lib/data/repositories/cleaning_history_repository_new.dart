import 'package:logger/logger.dart';
import '../services/api_client.dart';
import '../models/cleaning_history_new.dart';

/// Repository for cleaning history operations with Waugzee API
class CleaningHistoryRepositoryNew {
  final ApiClient _apiClient;
  final Logger _logger = Logger();

  CleaningHistoryRepositoryNew(this._apiClient);

  /// Create a new cleaning history entry
  ///
  /// [userReleaseId] - UUID of the user's release
  /// [cleanedAt] - When the record was cleaned
  /// [isDeepClean] - Whether this was a deep clean
  /// [notes] - Optional notes (max 1000 characters)
  Future<CleaningHistoryNew> createCleaning({
    required String userReleaseId,
    required DateTime cleanedAt,
    bool isDeepClean = false,
    String? notes,
  }) async {
    try {
      _logger.i('🧼 Creating cleaning history entry');

      final data = {
        'userReleaseId': userReleaseId,
        'cleanedAt': cleanedAt.toIso8601String(),
        'isDeepClean': isDeepClean,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
      };

      final response = await _apiClient.post('/cleanings', data: data);

      if (response.statusCode == 201 && response.data != null) {
        final cleaningHistory = CleaningHistoryNew.fromJson(response.data);
        _logger.i('✅ Cleaning history created: ${cleaningHistory.id}');
        return cleaningHistory;
      }

      throw Exception(
        'Failed to create cleaning history: ${response.statusCode}',
      );
    } catch (e, stackTrace) {
      _logger.e(
        '❌ Error creating cleaning history',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Update an existing cleaning history entry
  ///
  /// [id] - UUID of the cleaning history entry
  /// [cleanedAt] - Updated cleaning date/time
  /// [isDeepClean] - Updated deep clean flag
  /// [notes] - Updated notes
  Future<CleaningHistoryNew> updateCleaning({
    required String id,
    DateTime? cleanedAt,
    bool? isDeepClean,
    String? notes,
  }) async {
    try {
      _logger.i('📝 Updating cleaning history: $id');

      final data = <String, dynamic>{};
      if (cleanedAt != null) data['cleanedAt'] = cleanedAt.toIso8601String();
      if (isDeepClean != null) data['isDeepClean'] = isDeepClean;
      if (notes != null) data['notes'] = notes;

      final response = await _apiClient.put('/cleanings/$id', data: data);

      if (response.statusCode == 200 && response.data != null) {
        final cleaningHistory = CleaningHistoryNew.fromJson(response.data);
        _logger.i('✅ Cleaning history updated: $id');
        return cleaningHistory;
      }

      throw Exception(
        'Failed to update cleaning history: ${response.statusCode}',
      );
    } catch (e, stackTrace) {
      _logger.e(
        '❌ Error updating cleaning history',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Delete a cleaning history entry
  ///
  /// [id] - UUID of the cleaning history entry to delete
  Future<void> deleteCleaning(String id) async {
    try {
      _logger.i('🗑️ Deleting cleaning history: $id');

      final response = await _apiClient.delete('/cleanings/$id');

      if (response.statusCode == 204 || response.statusCode == 200) {
        _logger.i('✅ Cleaning history deleted: $id');
        return;
      }

      throw Exception(
        'Failed to delete cleaning history: ${response.statusCode}',
      );
    } catch (e, stackTrace) {
      _logger.e(
        '❌ Error deleting cleaning history',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Log both play and cleaning in a single transaction
  ///
  /// [userReleaseId] - UUID of the user's release
  /// [playedAt] - When the record was played
  /// [cleanedAt] - When the record was cleaned
  /// [userStylusId] - Optional UUID of the stylus used for play
  /// [isDeepClean] - Whether this was a deep clean
  /// [playNotes] - Optional notes for play (max 1000 characters)
  /// [cleaningNotes] - Optional notes for cleaning (max 1000 characters)
  Future<Map<String, dynamic>> logBoth({
    required String userReleaseId,
    required DateTime playedAt,
    required DateTime cleanedAt,
    String? userStylusId,
    bool isDeepClean = false,
    String? playNotes,
    String? cleaningNotes,
  }) async {
    try {
      _logger.i('📝🧼 Logging both play and cleaning');

      final data = {
        'play': {
          'userReleaseId': userReleaseId,
          'playedAt': playedAt.toIso8601String(),
          if (userStylusId != null) 'userStylusId': userStylusId,
          if (playNotes != null && playNotes.isNotEmpty) 'notes': playNotes,
        },
        'cleaning': {
          'userReleaseId': userReleaseId,
          'cleanedAt': cleanedAt.toIso8601String(),
          'isDeepClean': isDeepClean,
          if (cleaningNotes != null && cleaningNotes.isNotEmpty)
            'notes': cleaningNotes,
        },
      };

      final response = await _apiClient.post('/logBoth', data: data);

      if (response.statusCode == 201 && response.data != null) {
        _logger.i('✅ Successfully logged both play and cleaning');
        return response.data;
      }

      throw Exception('Failed to log both: ${response.statusCode}');
    } catch (e, stackTrace) {
      _logger.e(
        '❌ Error logging both play and cleaning',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
