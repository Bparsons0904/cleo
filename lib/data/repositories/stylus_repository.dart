// lib/data/repositories/stylus_repository.dart
import 'package:dio/dio.dart';
import '../models/stylus.dart';
import '../services/api_client.dart';

class StylusRepository {
  final ApiClient _apiClient;

  StylusRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<List<Stylus>> getStyluses() async {
    try {
      final response = await _apiClient.get('/styluses');
      
      final List<dynamic> results = response.data;
      return results.map((json) => Stylus.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Stylus> createStylus(Map<String, dynamic> stylusData) async {
    try {
      final response = await _apiClient.post('/styluses', data: stylusData);
      return Stylus.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Stylus> updateStylus(int id, Map<String, dynamic> stylusData) async {
    try {
      final response = await _apiClient.put('/styluses/$id', data: stylusData);
      return Stylus.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<bool> deleteStylus(int id) async {
    try {
      await _apiClient.delete('/styluses/$id');
      return true;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    if (e.response?.statusCode == 401) {
      return Exception('Authentication required. Please log in again.');
    } else if (e.response?.statusCode == 404) {
      return Exception('Stylus not found.');
    } else {
      return Exception('An error occurred: ${e.message}');
    }
  }
}
