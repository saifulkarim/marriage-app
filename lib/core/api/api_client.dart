import 'package:dio/dio.dart';
import 'package:getmarried/core/auth/token_storage.dart';
import 'package:getmarried/core/config/app_config.dart';

class ApiClient {
  ApiClient(this._tokenStorage) {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Accept': 'application/json'},
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _tokenStorage.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
  }

  final TokenStorage _tokenStorage;
  late final Dio _dio;

  Dio get dio => _dio;

  Future<Map<String, dynamic>> get(String path, {Map<String, dynamic>? query}) async {
    try {
      final response = await _dio.get(path, queryParameters: query);
      return _unwrap(response.data);
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  Future<Map<String, dynamic>> post(String path, {dynamic body}) async {
    try {
      final response = await _dio.post(path, data: body);
      return _unwrap(response.data);
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  Future<Map<String, dynamic>> put(String path, {dynamic body}) async {
    try {
      final response = await _dio.put(path, data: body);
      return _unwrap(response.data);
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  Future<Map<String, dynamic>> putMultipart(String path, FormData formData) async {
    try {
      final response = await _dio.put(
        path,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      return _unwrap(response.data);
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  Future<Map<String, dynamic>> delete(String path) async {
    try {
      final response = await _dio.delete(path);
      return _unwrap(response.data);
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  Map<String, dynamic> _unwrap(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data['success'] == false) {
        throw ApiException(
          data['message']?.toString() ?? 'Request failed',
          errors: data['errors'],
        );
      }
      return data;
    }
    throw ApiException('Invalid response format');
  }

  ApiException _fromDio(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      return ApiException(
        data['message']?.toString() ?? e.message ?? 'Network error',
        errors: data['errors'],
        statusCode: e.response?.statusCode,
      );
    }
    return ApiException(e.message ?? 'Network error', statusCode: e.response?.statusCode);
  }
}

class ApiException implements Exception {
  ApiException(this.message, {this.errors, this.statusCode});

  final String message;
  final dynamic errors;
  final int? statusCode;

  @override
  String toString() => message;
}

List<dynamic> extractList(dynamic data) {
  if (data is List) return data;
  if (data is Map && data['data'] is List) return data['data'] as List;
  return [];
}

Map<String, dynamic> extractMap(dynamic data) {
  if (data is Map<String, dynamic>) return data;
  return {};
}
