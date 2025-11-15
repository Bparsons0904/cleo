import 'package:logger/logger.dart';
import '../services/api_client.dart';

/// Repository for Discogs sync operations
class SyncRepository {
  final ApiClient _apiClient;
  final Logger _logger = Logger();

  SyncRepository(this._apiClient);

  /// Initiate Discogs collection sync
  ///
  /// This triggers a background sync of the user's Discogs collection.
  /// The actual sync happens asynchronously on the server.
  /// Use WebSocket to receive progress updates.
  Future<void> syncCollection() async {
    try {
      _logger.i('🔄 Initiating Discogs collection sync');

      final response = await _apiClient.post('/sync/syncCollection');

      if (response.statusCode == 200 || response.statusCode == 202) {
        _logger.i('✅ Collection sync initiated');
        return;
      }

      if (response.statusCode == 409) {
        _logger.w('⚠️ Sync already in progress');
        throw Exception('A sync is already in progress');
      }

      throw Exception('Failed to initiate sync: ${response.statusCode}');
    } catch (e, stackTrace) {
      _logger.e(
        '❌ Error initiating collection sync',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
