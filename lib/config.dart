// lib/config.dart
enum Environment {
  development,
  production,
}

class AppConfig {
  static final AppConfig _instance = AppConfig._internal();
  factory AppConfig() => _instance;
  AppConfig._internal();

  Environment _environment = Environment.development;
  
  // Base URLs for different environments
  final String _devBaseUrl = 'http://192.168.86.200:38180/api';
  final String _prodBaseUrl = 'http://192.168.86.200:38080/api';

  // Getters
  String get baseUrl => _environment == Environment.development 
      ? _devBaseUrl 
      : _prodBaseUrl;

  Environment get environment => _environment;

  // Initialize the config
  void initialize({required Environment environment}) {
    _environment = environment;
    print('🔧 App configured for ${_environment == Environment.development ? "DEVELOPMENT" : "PRODUCTION"}');
    print('🌐 API Base URL: $baseUrl');
  }

  // Check if in development mode
  bool get isDevelopment => _environment == Environment.development;
}
