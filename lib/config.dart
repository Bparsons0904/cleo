// lib/config.dart - Updated with more flexibility
enum Environment {
  development,
  production,
}

class AppConfig {
  static final AppConfig _instance = AppConfig._internal();
  factory AppConfig() => _instance;
  AppConfig._internal();

  Environment _environment = Environment.development;
  
  // Base URLs that can be overridden
  String _devBaseUrl = 'http://192.168.86.200:38180/api';
  String _prodBaseUrl = 'http://192.168.86.200:38080/api';

  // Getters
  String get baseUrl => _environment == Environment.development 
      ? _devBaseUrl 
      : _prodBaseUrl;

  Environment get environment => _environment;

  // Initialize the config
  void initialize({
    required Environment environment,
    String? devBaseUrl,
    String? prodBaseUrl,
  }) {
    _environment = environment;
    
    // Override URLs if provided
    if (devBaseUrl != null) {
      _devBaseUrl = devBaseUrl;
    }
    
    if (prodBaseUrl != null) {
      _prodBaseUrl = prodBaseUrl;
    }
    
    print('🔧 App configured for ${_environment == Environment.development ? "DEVELOPMENT" : "PRODUCTION"}');
    print('🌐 API Base URL: $baseUrl');
  }

  // Check if in development mode
  bool get isDevelopment => _environment == Environment.development;
  
  // Toggle environment (useful for debug builds)
  void toggleEnvironment() {
    _environment = _environment == Environment.development 
        ? Environment.production 
        : Environment.development;
    print('🔄 Environment switched to: ${_environment == Environment.development ? "DEVELOPMENT" : "PRODUCTION"}');
    print('🌐 API Base URL: $baseUrl');
  }
}
