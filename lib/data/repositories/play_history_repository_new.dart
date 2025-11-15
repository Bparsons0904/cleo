import 'package:logger/logger.dart';
import '../services/api_client.dart';
import '../models/play_history_new.dart';

/// Repository for play history operations with Waugzee API
class PlayHistoryRepositoryNew {
  final ApiClient _apiClient;
  final Logger _logger = Logger();

  PlayHistoryRepositoryNew(this._apiClient);

  /// Create a new play history entry
  ///
  /// [userReleaseId] - UUID of the user's release
  /// [playedAt] - When the record was played
  /// [userStylusId] - Optional UUID of the stylus used
  /// [notes] - Optional notes (max 1000 characters)
  Future<PlayHistoryNew> createPlay({
    required String userReleaseId,
    required DateTime playedAt,
    String? userStylusId,
    String? notes,
  }) async {
    try {
      _logger.i('📝 Creating play history entry');

      final data = {
        'userReleaseId': userReleaseId,
        'playedAt': playedAt.toIso8601String(),
        if (userStylusId != null) 'userStylusId': userStylusId,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
      };

      final response = await _apiClient.post('/plays', data: data);

      if (response.statusCode == 201 && response.data != null) {
        final playHistory = PlayHistoryNew.fromJson(response.data);
        _logger.i('✅ Play history created: ${playHistory.id}');
        return playHistory;
      }

      throw Exception('Failed to create play history: ${response.statusCode}');
    } catch (e, stackTrace) {
      _logger.e(
        '❌ Error creating play history',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Update an existing play history entry
  ///
  /// [id] - UUID of the play history entry
  /// [playedAt] - Updated play date/time
  /// [userStylusId] - Updated stylus UUID
  /// [notes] - Updated notes
  Future<PlayHistoryNew> updatePlay({
    required String id,
    DateTime? playedAt,
    String? userStylusId,
    String? notes,
  }) async {
    try {
      _logger.i('📝 Updating play history: $id');

      final data = <String, dynamic>{};
      if (playedAt != null) data['playedAt'] = playedAt.toIso8601String();
      if (userStylusId != null) data['userStylusId'] = userStylusId;
      if (notes != null) data['notes'] = notes;

      final response = await _apiClient.put('/plays/$id', data: data);

      if (response.statusCode == 200 && response.data != null) {
        final playHistory = PlayHistoryNew.fromJson(response.data);
        _logger.i('✅ Play history updated: $id');
        return playHistory;
      }

      throw Exception('Failed to update play history: ${response.statusCode}');
    } catch (e, stackTrace) {
      _logger.e(
        '❌ Error updating play history',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Delete a play history entry
  ///
  /// [id] - UUID of the play history entry to delete
  Future<void> deletePlay(String id) async {
    try {
      _logger.i('🗑️ Deleting play history: $id');

      final response = await _apiClient.delete('/plays/$id');

      if (response.statusCode == 204 || response.statusCode == 200) {
        _logger.i('✅ Play history deleted: $id');
        return;
      }

      throw Exception('Failed to delete play history: ${response.statusCode}');
    } catch (e, stackTrace) {
      _logger.e(
        '❌ Error deleting play history',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
