// lib/data/repositories/play_history_repository.dart
import 'package:dio/dio.dart';
import '../models/play_history.dart';
import '../services/api_client.dart';

class PlayHistoryRepository {
  final ApiClient _apiClient;

  PlayHistoryRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<PlayHistory> logPlay({
    required int releaseId,
    int? stylusId,
    required DateTime playedAt,
    String? notes,
  }) async {
    try {
      final response = await _apiClient.post('/plays', data: {
        'releaseId': releaseId,
        'stylusId': stylusId,
        'playedAt': playedAt.toIso8601String(),
        'notes': notes,
      });
      
      return PlayHistory.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<int, int>> getPlayCounts() async {
    try {
      final response = await _apiClient.get('/plays/counts');
      
      // Convert from JSON to Map<int, int>
      final Map<String, dynamic> data = response.data;
      return data.map((key, value) => MapEntry(int.parse(key), value as int));
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<PlayHistory>> getRecentPlays() async {
    try {
      final response = await _apiClient.get('/plays/recent');
      
      final List<dynamic> results = response.data;
      return results.map((json) => PlayHistory.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    if (e.response?.statusCode == 401) {
      return Exception('Authentication required. Please log in again.');
    } else if (e.response?.statusCode == 404) {
      return Exception('Resource not found.');
    } else {
      return Exception('An error occurred: ${e.message}');
    }
  }
}
