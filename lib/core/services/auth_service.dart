import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import '../config/environment.dart';

/// Authentication service that handles OAuth 2.0 PKCE flow with Zitadel
class AuthService {
  final FlutterAppAuth _appAuth = const FlutterAppAuth();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final Logger _logger = Logger();

  // Storage keys
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _idTokenKey = 'id_token';
  static const String _tokenExpiryKey = 'token_expiry';

  /// Check if user is currently authenticated
  Future<bool> isAuthenticated() async {
    final accessToken = await getAccessToken();
    if (accessToken == null) return false;

    // Check if token is expired
    final expiryStr = await _secureStorage.read(key: _tokenExpiryKey);
    if (expiryStr == null) return false;

    final expiry = DateTime.parse(expiryStr);
    return DateTime.now().isBefore(expiry);
  }

  /// Get the current access token
  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: _accessTokenKey);
  }

  /// Get the current refresh token
  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: _refreshTokenKey);
  }

  /// Get the current ID token
  Future<String?> getIdToken() async {
    return await _secureStorage.read(key: _idTokenKey);
  }

  /// Initiate OAuth 2.0 PKCE login flow
  Future<bool> login() async {
    try {
      _logger.i('🔐 Initiating OAuth login flow');
      _logger.d('Issuer: ${EnvironmentConfig.zitadelIssuer}');
      _logger.d('Client ID: ${EnvironmentConfig.clientId}');
      _logger.d('Redirect URL: ${EnvironmentConfig.redirectUrl}');

      final AuthorizationTokenResponse? result =
          await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          EnvironmentConfig.clientId,
          EnvironmentConfig.redirectUrl,
          discoveryUrl: EnvironmentConfig.zitadelDiscoveryUrl,
          scopes: EnvironmentConfig.scopes,
          promptValues: ['login'], // Force login prompt
        ),
      );

      if (result != null) {
        await _storeTokens(result);
        _logger.i('✅ Login successful');
        return true;
      }

      _logger.w('⚠️ Login cancelled or failed');
      return false;
    } catch (e, stackTrace) {
      _logger.e('❌ Login error', error: e, stackTrace: stackTrace);
      return false;
    }
  }

  /// Refresh the access token using refresh token
  Future<bool> refreshToken() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null) {
        _logger.w('⚠️ No refresh token available');
        return false;
      }

      _logger.i('🔄 Refreshing access token');

      final TokenResponse? result = await _appAuth.token(
        TokenRequest(
          EnvironmentConfig.clientId,
          EnvironmentConfig.redirectUrl,
          discoveryUrl: EnvironmentConfig.zitadelDiscoveryUrl,
          refreshToken: refreshToken,
          scopes: EnvironmentConfig.scopes,
        ),
      );

      if (result != null) {
        await _storeTokens(result);
        _logger.i('✅ Token refresh successful');
        return true;
      }

      _logger.w('⚠️ Token refresh failed');
      return false;
    } catch (e, stackTrace) {
      _logger.e('❌ Token refresh error', error: e, stackTrace: stackTrace);
      return false;
    }
  }

  /// Logout user and clear all stored tokens
  Future<void> logout() async {
    try {
      _logger.i('🚪 Logging out');

      // Clear all tokens from secure storage
      await _secureStorage.delete(key: _accessTokenKey);
      await _secureStorage.delete(key: _refreshTokenKey);
      await _secureStorage.delete(key: _idTokenKey);
      await _secureStorage.delete(key: _tokenExpiryKey);

      _logger.i('✅ Logout successful - tokens cleared');
    } catch (e, stackTrace) {
      _logger.e('❌ Logout error', error: e, stackTrace: stackTrace);
    }
  }

  /// Get the end session URL for complete logout (including Zitadel session)
  Future<String?> getEndSessionUrl() async {
    try {
      final idToken = await getIdToken();
      if (idToken == null) return null;

      final EndSessionRequest request = EndSessionRequest(
        idTokenHint: idToken,
        postLogoutRedirectUrl: EnvironmentConfig.postLogoutRedirectUrl,
        discoveryUrl: EnvironmentConfig.zitadelDiscoveryUrl,
      );

      final EndSessionResponse? response = await _appAuth.endSession(request);
      return response?.state;
    } catch (e, stackTrace) {
      _logger.e('❌ End session error', error: e, stackTrace: stackTrace);
      return null;
    }
  }

  /// Store tokens securely
  Future<void> _storeTokens(TokenResponse response) async {
    if (response.accessToken != null) {
      await _secureStorage.write(
        key: _accessTokenKey,
        value: response.accessToken!,
      );
    }

    if (response.refreshToken != null) {
      await _secureStorage.write(
        key: _refreshTokenKey,
        value: response.refreshToken!,
      );
    }

    if (response.idToken != null) {
      await _secureStorage.write(
        key: _idTokenKey,
        value: response.idToken!,
      );
    }

    if (response.accessTokenExpirationDateTime != null) {
      await _secureStorage.write(
        key: _tokenExpiryKey,
        value: response.accessTokenExpirationDateTime!.toIso8601String(),
      );
    }

    _logger.d('💾 Tokens stored securely');
  }

  /// Check if access token is expired or will expire soon (within 5 minutes)
  Future<bool> isTokenExpired() async {
    final expiryStr = await _secureStorage.read(key: _tokenExpiryKey);
    if (expiryStr == null) return true;

    final expiry = DateTime.parse(expiryStr);
    final now = DateTime.now();

    // Consider token expired if it expires within 5 minutes
    final buffer = const Duration(minutes: 5);
    return now.isAfter(expiry.subtract(buffer));
  }

  /// Ensure we have a valid token, refreshing if necessary
  Future<String?> getValidAccessToken() async {
    if (await isTokenExpired()) {
      final refreshed = await refreshToken();
      if (!refreshed) return null;
    }

    return await getAccessToken();
  }
}
