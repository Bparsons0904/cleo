// lib/data/repositories/auth_repository.dart
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_payload.dart';
import '../services/api_client.dart';

class AuthRepository {
  final ApiClient _apiClient;
  static const String _tokenKey = 'auth_token';

  AuthRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  // Method to get the stored token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Method to check auth status and get user data
  // In AuthRepository class
  Future<AuthPayload> getAuthStatus() async {
    print('📡 Checking auth status at endpoint: /auth');
    try {
      final response = await _apiClient.get('/auth');
      print('🔑 Auth status response received: ${response.statusCode}');

      try {
        print('Attempting to parse AuthPayload');
        final authPayload = AuthPayload.fromJson(response.data);
        print('Successfully parsed AuthPayload');

        // Don't save token locally anymore
        return authPayload;
      } catch (e, stackTrace) {
        print('❌ Error parsing AuthPayload: $e');
        print('Stack trace: $stackTrace');

        // Create a minimal payload with empty collections
        return AuthPayload(
          token: '', // Empty token since we don't need it
          syncingData: false,
          releases: [],
          styluses: [],
          playHistory: [],
          folders: [],
        );
      }
    } on DioException catch (e) {
      print('🚫 Error checking auth status: ${e.message}');
      rethrow;
    }
  }

  Future<bool> saveToken(String token) async {
    try {
      await _apiClient.post('/auth/token', data: {'token': token});
      return true;
    } on DioException catch (e) {
      throw _handleError(e);
    }
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
