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

  /// Google OAuth Web client ID (Android serverClientId). Create in Google Cloud Console.
  static const String googleServerClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
    defaultValue: '',
  );

  /// Google OAuth iOS client ID. Add the reversed client ID to iOS URL schemes when using native config.
  static const String googleIosClientId = String.fromEnvironment(
    'GOOGLE_IOS_CLIENT_ID',
    defaultValue: '',
  );

  static bool get isGoogleSignInConfigured =>
      googleServerClientId.isNotEmpty || googleIosClientId.isNotEmpty;
}
