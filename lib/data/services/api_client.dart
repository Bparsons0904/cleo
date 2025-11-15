import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import '../../core/config/environment.dart';
import '../../core/services/auth_service.dart';

/// API client for communicating with Waugzee backend
/// Handles JWT token injection, automatic refresh, and error handling
class ApiClient {
  late final Dio _dio;
  final AuthService _authService;
  final Logger _logger = Logger();

  ApiClient(this._authService) {
    _dio = Dio(
      BaseOptions(
        baseUrl: EnvironmentConfig().apiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        responseType: ResponseType.json,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add auth interceptor (must be first to inject tokens)
    _dio.interceptors.add(_createAuthInterceptor());

    // Add logging interceptor in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(_createLoggingInterceptor());
    }

    // Add error handler interceptor
    _dio.interceptors.add(_createErrorInterceptor());
  }

  /// Creates interceptor for JWT token injection and refresh
  InterceptorsWrapper _createAuthInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Skip auth for public endpoints
        if (_isPublicEndpoint(options.path)) {
          return handler.next(options);
        }

        // Get valid token (will refresh if needed)
        final token = await _authService.getValidAccessToken();

        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
          _logger.d('🔑 Added auth token to request');
        } else {
          _logger.w('⚠️ No auth token available');
        }

        handler.next(options);
      },
      onError: (error, handler) async {
        // Handle 401 Unauthorized - token might be expired
        if (error.response?.statusCode == 401) {
          _logger.w('🔒 Received 401 - attempting token refresh');

          // Try to refresh the token
          final refreshed = await _authService.refreshToken();

          if (refreshed) {
            // Retry the failed request with new token
            final token = await _authService.getAccessToken();
            if (token != null) {
              _logger.i('✅ Token refreshed - retrying request');

              // Clone the failed request with new token
              final requestOptions = error.requestOptions;
              requestOptions.headers['Authorization'] = 'Bearer $token';

              try {
                // Retry the request
                final response = await _dio.fetch(requestOptions);
                return handler.resolve(response);
              } catch (e) {
                _logger.e('❌ Retry failed after token refresh', error: e);
                return handler.next(error);
              }
            }
          }

          _logger.e('❌ Token refresh failed - user needs to login again');
          // Token refresh failed - user needs to login again
          // You might want to trigger a logout/redirect to login here
        }

        handler.next(error);
      },
    );
  }

  /// Creates logging interceptor for debugging
  InterceptorsWrapper _createLoggingInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        _logger.d(
          '🌐 ${options.method} ${options.baseUrl}${options.path}',
        );
        if (options.queryParameters.isNotEmpty) {
          _logger.d('Query params: ${options.queryParameters}');
        }
        if (options.data != null) {
          _logger.d('Request body: ${options.data}');
        }
        handler.next(options);
      },
      onResponse: (response, handler) {
        _logger.d(
          '✅ ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.path}',
        );
        _logger.d('Response: ${response.data}');
        handler.next(response);
      },
      onError: (error, handler) {
        _logger.e(
          '❌ ${error.response?.statusCode} ${error.requestOptions.method} ${error.requestOptions.path}',
        );
        _logger.e('Error: ${error.message}');
        if (error.response?.data != null) {
          _logger.e('Error data: ${error.response?.data}');
        }
        handler.next(error);
      },
    );
  }

  /// Creates error handling interceptor
  InterceptorsWrapper _createErrorInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) {
        // Handle common error scenarios
        if (error.response != null) {
          final statusCode = error.response!.statusCode;
          final data = error.response!.data;

          String errorMessage = 'An error occurred';

          // Extract error message from response
          if (data is Map<String, dynamic> && data.containsKey('error')) {
            errorMessage = data['error'].toString();
          }

          switch (statusCode) {
            case 400:
              _logger.w('⚠️ Bad Request: $errorMessage');
              break;
            case 401:
              _logger.w('🔒 Unauthorized: $errorMessage');
              break;
            case 403:
              _logger.w('🚫 Forbidden: $errorMessage');
              break;
            case 404:
              _logger.w('🔍 Not Found: $errorMessage');
              break;
            case 429:
              _logger.w('🚦 Rate Limited: $errorMessage');
              break;
            case 500:
            case 502:
            case 503:
              _logger.e('💥 Server Error: $errorMessage');
              break;
          }
        } else {
          // Network error or timeout
          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout) {
            _logger.e('⏱️ Request timeout');
          } else if (error.type == DioExceptionType.connectionError) {
            _logger.e('🌐 Connection error - check network');
          } else {
            _logger.e('❌ Unknown error: ${error.message}');
          }
        }

        handler.next(error);
      },
    );
  }

  /// Check if endpoint is public (doesn't require authentication)
  bool _isPublicEndpoint(String path) {
    const publicPaths = [
      '/health',
      '/api/auth/config',
      '/api/auth/callback',
    ];

    return publicPaths.any((p) => path.contains(p));
  }

  /// GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// Update base URL (useful for switching environments)
  void updateBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
    _logger.i('🔄 Base URL updated to: $baseUrl');
  }
}
