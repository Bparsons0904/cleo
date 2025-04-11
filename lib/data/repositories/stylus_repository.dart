// lib/data/repositories/stylus_repository.dart
import 'package:dio/dio.dart';
import '../models/models.dart';
import '../services/api_client.dart';

class StylusRepository {
  final ApiClient _apiClient;

  StylusRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  /// Creates a new stylus
  Future<List<Stylus>> createStylus(Map<String, dynamic> stylusData) async {
    try {
      // Make API call to create stylus
      final response = await _apiClient.post('/styluses', data: stylusData);

      // Parse the response which is expected to be a list
      if (response.data is List) {
        // Response is a list of styluses
        return _parseStyluses(response.data);
      } else if (response.data is Map) {
        // Some endpoints might return an object with a styluses field
        final Map<String, dynamic> data = response.data;
        if (data.containsKey('styluses') && data['styluses'] is List) {
          return _parseStyluses(data['styluses']);
        }
      }

      // Fallback - return empty list
      print("Warning: Unexpected response format from create stylus API");
      return [];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Updates an existing stylus
  Future<List<Stylus>> updateStylus(
    int id,
    Map<String, dynamic> stylusData,
  ) async {
    try {
      // Make API call to update stylus
      final response = await _apiClient.put('/styluses/$id', data: stylusData);

      // Parse the response which is expected to be a list
      if (response.data is List) {
        // Response is a list of styluses
        return _parseStyluses(response.data);
      } else if (response.data is Map) {
        // Some endpoints might return an object with a styluses field
        final Map<String, dynamic> data = response.data;
        if (data.containsKey('styluses') && data['styluses'] is List) {
          return _parseStyluses(data['styluses']);
        }
      }

      // Fallback - return empty list
      print("Warning: Unexpected response format from update stylus API");
      return [];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Deletes a stylus
  Future<List<Stylus>> deleteStylus(int id) async {
    try {
      // Make API call to delete stylus
      final response = await _apiClient.delete('/styluses/$id');

      // Parse the response which is expected to be a list
      if (response.data is List) {
        // Response is a list of styluses
        return _parseStyluses(response.data);
      } else if (response.data is Map) {
        // Some endpoints might return an object with a styluses field
        final Map<String, dynamic> data = response.data;
        if (data.containsKey('styluses') && data['styluses'] is List) {
          return _parseStyluses(data['styluses']);
        }
      }

      // Fallback - return empty list
      print("Warning: Unexpected response format from delete stylus API");
      return [];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Helper method to parse a list of styluses from response
  List<Stylus> _parseStyluses(List<dynamic> data) {
    return data.map((item) => Stylus.fromJson(item)).toList();
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
