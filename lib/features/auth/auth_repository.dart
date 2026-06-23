import 'package:getmarried/core/api/api_client.dart';
import 'package:getmarried/core/auth/token_storage.dart';

class AuthRepository {
  AuthRepository(this._api, this._tokenStorage);

  final ApiClient _api;
  final TokenStorage _tokenStorage;

  Future<Map<String, dynamic>> login({
    required String identifier,
    required String password,
  }) async {
    final response = await _api.post('/auth/login', body: {
      'identifier': identifier,
      'password': password,
      'device_name': 'flutter-app',
    });
    final data = response['data'] as Map<String, dynamic>;
    await _tokenStorage.saveToken(data['token'] as String);
    return data;
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String identifier,
    required String password,
    String? address,
  }) async {
    final response = await _api.post('/auth/register', body: {
      'name': name,
      'identifier': identifier,
      'password': password,
      if (address != null && address.isNotEmpty) 'address': address,
    });
    final data = response['data'] as Map<String, dynamic>;
    await _tokenStorage.saveToken(data['token'] as String);
    return data;
  }

  Future<void> verifyOtp(String code) async {
    await _api.post('/auth/verify-otp', body: {'code': code});
  }

  Future<void> resendOtp() async {
    await _api.post('/auth/resend-otp');
  }

  Future<void> forgotPassword(String identifier) async {
    await _api.post('/auth/forgot-password', body: {'identifier': identifier});
  }

  Future<void> resetPassword({
    required String identifier,
    required String code,
    required String password,
  }) async {
    await _api.post('/auth/reset-password', body: {
      'identifier': identifier,
      'code': code,
      'password': password,
    });
  }

  Future<void> logout() async {
    try {
      await _api.post('/auth/logout');
    } finally {
      await _tokenStorage.clearToken();
    }
  }

  Future<bool> hasSession() async {
    final token = await _tokenStorage.getToken();
    return token != null && token.isNotEmpty;
  }

  Future<Map<String, dynamic>> me() async {
    final response = await _api.get('/auth/me');
    return response['data'] as Map<String, dynamic>;
  }

  Future<void> updateLocale(String locale) async {
    await _api.put('/auth/locale', body: {'locale': locale});
  }

  Future<bool> needsVerification() async {
    final user = await me();
    return user['email_verified'] != true;
  }

  Future<Map<String, dynamic>> googleLogin({
    required String providerId,
    required String email,
    required String name,
  }) async {
    final response = await _api.post('/auth/google', body: {
      'provider_id': providerId,
      'email': email,
      'name': name,
      'device_name': 'flutter-app',
    });
    final data = response['data'] as Map<String, dynamic>;
    await _tokenStorage.saveToken(data['token'] as String);
    return data;
  }

  Future<void> changePassword({
    required String password,
    required String passwordConfirmation,
  }) async {
    await _api.post('/auth/change-password', body: {
      'password': password,
      'password_confirmation': passwordConfirmation,
    });
  }
}
