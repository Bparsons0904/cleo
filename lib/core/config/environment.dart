/// Environment configuration for the Cleo app
/// Manages different environments (local, production) and their settings

enum Environment {
  local,
  production,
}

class EnvironmentConfig {
  static final EnvironmentConfig _instance = EnvironmentConfig._internal();
  factory EnvironmentConfig() => _instance;
  EnvironmentConfig._internal();

  Environment _environment = Environment.local;

  // API Configuration
  static const String _localApiUrl = 'http://localhost:3021/api';
  static const String _prodApiUrl = 'https://www.waugzee.com/api';

  static const String _localWsUrl = 'ws://localhost:3021/ws';
  static const String _prodWsUrl = 'wss://www.waugzee.com/ws';

  // OAuth/Zitadel Configuration
  static const String zitadelIssuer = 'https://auth.waugze.com';
  static const String zitadelDiscoveryUrl = '$zitadelIssuer/.well-known/openid-configuration';

  // OAuth Client ID from Zitadel
  static const String clientId = String.fromEnvironment(
    'ZITADEL_CLIENT_ID',
    defaultValue: '346748216215076868',
  );

  // OAuth Configuration
  static const String redirectScheme = 'cleo';
  static const String redirectUrl = '$redirectScheme://auth/callback';
  static const String postLogoutRedirectUrl = '$redirectScheme://auth/logout';

  static const List<String> scopes = [
    'openid',
    'profile',
    'email',
    'offline_access', // For refresh token
    'urn:zitadel:iam:org:project:roles',
  ];

  // Getters
  Environment get environment => _environment;

  String get apiBaseUrl {
    return _environment == Environment.local ? _localApiUrl : _prodApiUrl;
  }

  String get wsUrl {
    return _environment == Environment.local ? _localWsUrl : _prodWsUrl;
  }

  bool get isProduction => _environment == Environment.production;
  bool get isLocal => _environment == Environment.local;

  // Initialize environment
  void initialize({required Environment environment}) {
    _environment = environment;
    print('🔧 Environment: ${_environment.name}');
    print('🌐 API URL: $apiBaseUrl');
    print('🔌 WebSocket URL: $wsUrl');
    print('🔐 OAuth Issuer: $zitadelIssuer');
    print('📱 Redirect URL: $redirectUrl');
  }

  // Toggle environment (for debug builds)
  void toggleEnvironment() {
    _environment = _environment == Environment.local
        ? Environment.production
        : Environment.local;
    print('🔄 Environment switched to: ${_environment.name}');
    print('🌐 API URL: $apiBaseUrl');
    print('🔌 WebSocket URL: $wsUrl');
  }

  // Get environment from string
  static Environment fromString(String env) {
    switch (env.toLowerCase()) {
      case 'production':
      case 'prod':
        return Environment.production;
      case 'local':
      case 'development':
      case 'dev':
      default:
        return Environment.local;
    }
  }
}
