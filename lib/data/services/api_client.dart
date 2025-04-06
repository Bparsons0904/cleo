// lib/data/services/api_client.dart
import 'package:cleo/config.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  late final Dio _dio;
  
  ApiClient() {
    final baseUrl = AppConfig().baseUrl;
    
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(milliseconds: 15000),
        receiveTimeout: const Duration(milliseconds: 15000),
        responseType: ResponseType.json,
      ),
    );

    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onResponse: _onResponse,
        onError: _onError,
      ),
    );

    // In your ApiClient class, modify the interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('🌐 REQUEST[${options.method}] => PATH: ${options.path}');
          print('Headers: ${options.headers}');
          print('Body: ${options.data}');
          return _onRequest(options, handler);
        },
        onResponse: (response, handler) {
          print('✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
          print('Response: ${response.data}');
          return _onResponse(response, handler);
        },
        onError: (error, handler) {
          print('❌ ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}');
          print('Error: ${error.message}');
          if (error.response != null) {
            print('Response data: ${error.response?.data}');
          }
          return _onError(error, handler);
        },
      ),
    );

    // Add logging interceptor in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ));
    }
  }

// In the ApiClient class, let's add more debugging
void _onRequest(
  RequestOptions options,
  RequestInterceptorHandler handler,
) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');

  print('🚀 Making request to: ${options.baseUrl}${options.path}');
  
  if (token != null) {
    options.headers['Authorization'] = 'Bearer $token';
    print('🔐 Token found in storage, adding to request');
  } else {
    print('🔐 No token found in storage');
  }

  handler.next(options);
}

  // Response interceptor (you can process common response patterns here)
  void _onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    // Process successful responses if needed
    handler.next(response);
  }

  // Error interceptor
  void _onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    // Handle common error scenarios
    if (err.response?.statusCode == 401) {
      // Handle unauthorized (token expired)
      // You might want to refresh token or redirect to login
    }

    handler.next(err);
  }

  // GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    print('🔍 Making GET request to: ${_dio.options.baseUrl}$path');
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      print('✅ GET request successful: ${response.statusCode}');
      return response;
    } catch (e) {
      print('❌ GET request failed: $e');
      rethrow;
    }
  }

  // POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _dio.post(path, data: data, queryParameters: queryParameters);
  }

  // PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _dio.put(path, data: data, queryParameters: queryParameters);
  }

  // DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _dio.delete(path, data: data, queryParameters: queryParameters);
  }

}

