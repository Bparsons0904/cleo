import 'package:logger/logger.dart';
import '../services/api_client.dart';

/// Repository for daily recommendation operations
class RecommendationRepository {
  final ApiClient _apiClient;
  final Logger _logger = Logger();

  RecommendationRepository(this._apiClient);

  /// Mark a daily recommendation as listened
  ///
  /// [id] - UUID of the daily recommendation
  ///
  /// This updates the recommendation to mark it as listened to.
  /// Typically called when the user plays the recommended record.
  Future<void> markAsListened(String id) async {
    try {
      _logger.i('✅ Marking recommendation as listened: $id');

      final response = await _apiClient.post('/recommendations/$id/listen');

      if (response.statusCode == 200 || response.statusCode == 204) {
        _logger.i('✅ Recommendation marked as listened');
        return;
      }

      throw Exception(
        'Failed to mark recommendation as listened: ${response.statusCode}',
      );
    } catch (e, stackTrace) {
      _logger.e(
        '❌ Error marking recommendation as listened',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
