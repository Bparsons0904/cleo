// lib/data/repositories/auth_repository.dart
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_payload.dart';
import '../services/api_client.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<AuthPayload> getAuthStatus() async {
    try {
      final response = await _apiClient.get('/auth');
      return AuthPayload.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<bool> saveToken(String token) async {
    try {
      await _apiClient.post('/auth/token', data: {'token': token});
      
      // Store token locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      
      return true;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Exception _handleError(DioException e) {
    if (e.response?.statusCode == 401) {
      return Exception('Invalid token. Please try again.');
    } else if (e.response?.statusCode == 404) {
      return Exception('Service not found. Please check your connection.');
    } else {
      return Exception('An unexpected error occurred: ${e.message}');
    }
  }
}
