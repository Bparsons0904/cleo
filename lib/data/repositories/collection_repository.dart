// lib/data/repositories/collection_repository.dart
import 'package:dio/dio.dart';
import '../models/release.dart';
import '../services/api_client.dart';

class CollectionRepository {
  final ApiClient _apiClient;

  CollectionRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<List<Release>> getCollection({int? folderId}) async {
    try {
      final response = await _apiClient.get(
        '/collection',
        queryParameters: folderId != null ? {'folderId': folderId} : null,
      );
      
      final List<dynamic> results = response.data;
      return results.map((json) => Release.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<bool> syncCollection() async {
    try {
      await _apiClient.get('/collection/resync');
      return true;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    if (e.response?.statusCode == 401) {
      return Exception('Authentication required. Please log in again.');
    } else if (e.response?.statusCode == 404) {
      return Exception('Collection not found.');
    } else {
      return Exception('An error occurred: ${e.message}');
    }
  }
}
