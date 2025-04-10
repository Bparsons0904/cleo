// lib/data/repositories/stylus_repository.dart
import 'package:dio/dio.dart';
import '../models/models.dart';
import '../services/api_client.dart';

class StylusRepository {
  final ApiClient _apiClient;

  StylusRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  /// Creates a new stylus
  Future<void> createStylus(Map<String, dynamic> stylusData) async {
    try {
      // Make API call to create stylus
      await _apiClient.post('/styluses', data: stylusData);

      // No need to return anything - the auth payload will be updated by the API
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Updates an existing stylus
  Future<void> updateStylus(int id, Map<String, dynamic> stylusData) async {
    try {
      // Make API call to update stylus
      await _apiClient.put('/styluses/$id', data: stylusData);

      // No need to return anything - the auth payload will be updated by the API
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Deletes a stylus
  Future<void> deleteStylus(int id) async {
    try {
      // Make API call to delete stylus
      await _apiClient.delete('/styluses/$id');

      // No need to return anything - the auth payload will be updated by the API
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    if (e.response?.statusCode == 401) {
      return Exception('Authentication required. Please log in again.');
    } else if (e.response?.statusCode == 404) {
      return Exception('Stylus not found.');
    } else if (e.response?.statusCode == 405) {
      return Exception(
        'Method not allowed. Check the API endpoint: ${e.requestOptions.path}',
      );
    } else {
      return Exception('An error occurred: ${e.message}');
    }
  }
}
