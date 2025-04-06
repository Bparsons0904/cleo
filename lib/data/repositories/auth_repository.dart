// lib/data/repositories/auth_repository.dart
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_payload.dart';
import '../services/api_client.dart';

class AuthRepository {
 final ApiClient _apiClient;
  static const String _tokenKey = 'auth_token';

  AuthRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  // Method to check if user has a stored token
  Future<bool> hasToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_tokenKey) && prefs.getString(_tokenKey)!.isNotEmpty;
  }

  // Method to get the stored token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Method to check auth status and get user data
  Future<AuthPayload> getAuthStatus() async {
    print('📡 Checking auth status at endpoint: /auth');
    try {
      final response = await _apiClient.get('/auth');
      print('🔑 Auth status response received: ${response.statusCode}');
      print('Response data: ${response.data}');
      
      // If we got here, we have a token in the response
      final authPayload = AuthPayload.fromJson(response.data);
      
      // Save the token if it's in the response
      if (authPayload.token.isNotEmpty) {
        print('🔑 Token found in response, saving it');
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_tokenKey, authPayload.token);
      }
      
      return authPayload;
    } on DioException catch (e) {
      print('🚫 Error checking auth status: ${e.message}');
      print('Error type: ${e.type}');
      if (e.response != null) {
        print('Error status: ${e.response?.statusCode}');
        print('Error data: ${e.response?.data}');
      }
      
      if (e.response?.statusCode == 401) {
        print('🚫 Unauthorized, clearing token');
        await logout();
      }
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
