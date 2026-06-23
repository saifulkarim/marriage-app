import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:getmarried/core/auth/token_storage.dart';
import 'package:getmarried/core/config/app_config.dart';

class ApiClient {
  ApiClient(this._tokenStorage, {String Function()? localeResolver}) {
    _localeResolver = localeResolver;
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
          final locale = _localeResolver?.call() ?? 'bn';
          options.headers['Accept-Language'] = locale;
          handler.next(options);
        },
      ),
    );
  }

  final TokenStorage _tokenStorage;
  late final Dio _dio;
  String Function()? _localeResolver;

  void setLocaleResolver(String Function() resolver) {
    _localeResolver = resolver;
  }

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

  Future<Map<String, dynamic>> postMultipart(String path, FormData formData) async {
    try {
      final response = await _dio.post(
        path,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      return _unwrap(response.data);
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  Future<FileDownload> download(String path, {Map<String, dynamic>? query}) async {
    try {
      final token = await _tokenStorage.getToken();
      final response = await _dio.get<List<int>>(
        path,
        queryParameters: query,
        options: Options(
          responseType: ResponseType.bytes,
          headers: token != null && token.isNotEmpty ? {'Authorization': 'Bearer $token'} : null,
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      final contentType = response.headers.value('content-type') ?? '';
      final bytes = response.data;

      if (response.statusCode != 200 || bytes == null) {
        throw _bytesError(bytes, response.statusCode);
      }

      if (contentType.contains('application/json')) {
        throw _bytesError(bytes, response.statusCode);
      }

      final filename = _filenameFromHeaders(response.headers) ?? 'download.pdf';
      return FileDownload(Uint8List.fromList(bytes), filename);
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  ApiException _bytesError(List<int>? bytes, int? statusCode) {
    if (bytes != null && bytes.isNotEmpty) {
      try {
        final json = jsonDecode(utf8.decode(bytes));
        if (json is Map<String, dynamic>) {
          return ApiException(
            json['message']?.toString() ?? 'Download failed',
            errors: json['errors'],
            statusCode: statusCode,
          );
        }
      } catch (_) {}
    }
    return ApiException('Download failed', statusCode: statusCode);
  }

  String? _filenameFromHeaders(Headers headers) {
    final disposition = headers.value('content-disposition');
    if (disposition == null) return null;
    final match = RegExp(r'filename="?([^";]+)"?').firstMatch(disposition);
    return match?.group(1);
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

class FileDownload {
  FileDownload(this.bytes, this.filename);

  final Uint8List bytes;
  final String filename;
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
