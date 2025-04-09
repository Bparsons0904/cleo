// lib/data/repositories/cleaning_history_repository.dart
import 'package:dio/dio.dart';
import '../models/cleaning_history.dart';
import '../services/api_client.dart';

class CleaningHistoryRepository {
  final ApiClient _apiClient;

  CleaningHistoryRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<CleaningHistory> logCleaning({
    required int releaseId,
    required DateTime cleanedAt,
    String? notes,
  }) async {
    try {
      final response = await _apiClient.post('/cleanings', data: {
        'releaseId': releaseId,
        'cleanedAt': cleanedAt.toUtc().toIso8601String(),
        'notes': notes,
      });
      
      return CleaningHistory.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<int, int>> getCleaningCounts() async {
    try {
      final response = await _apiClient.get('/cleanings/counts');
      
      // Convert from JSON to Map<int, int>
      final Map<String, dynamic> data = response.data;
      return data.map((key, value) => MapEntry(int.parse(key), value as int));
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
