class AppConfig {
  /// Change this to your Laravel API base URL (no trailing slash).
  /// Android emulator: http://10.0.2.2:8000
  /// iOS simulator: http://127.0.0.1:8000
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:8000',
  );

  static const String apiPrefix = '/api/v1/mobile';
  static String get baseUrl => '$apiBaseUrl$apiPrefix';
}
