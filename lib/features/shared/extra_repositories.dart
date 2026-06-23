import 'package:dio/dio.dart';
import 'package:getmarried/core/api/api_client.dart';

class ChatRepository {
  ChatRepository(this._api);
  final ApiClient _api;

  Future<List<dynamic>> rooms() async {
    final r = await _api.get('/chats');
    return extractList(r['data']);
  }

  Future<Map<String, dynamic>> room(int id) async {
    final r = await _api.get('/chats/$id');
    return extractMap(r['data']);
  }

  Future<List<dynamic>> messages(int id, {int afterId = 0}) async {
    final query = afterId > 0 ? {'after_id': afterId} : null;
    final r = await _api.get('/chats/$id/messages', query: query);
    return extractList(r['data']);
  }

  Future<void> sendMessage(int id, {String? message, String? filePath}) async {
    if (filePath != null) {
      await _api.postMultipart('/chats/$id/messages', FormData.fromMap({
        if (message != null) 'message': message,
        'attachment': await MultipartFile.fromFile(filePath),
      }));
    } else {
      await _api.post('/chats/$id/messages', body: {'message': message});
    }
  }
}

class MeetingRepository {
  MeetingRepository(this._api);
  final ApiClient _api;

  Future<Map<String, dynamic>> list() async {
    final r = await _api.get('/meetings');
    return extractMap(r['data']);
  }

  Future<void> request(String biodataSlug, {required int type, required String date}) async {
    await _api.post('/meetings/$biodataSlug', body: {'meeting_type': type, 'proposed_date': date});
  }

  Future<void> accept(String slug) => _api.post('/meetings/$slug/accept');
  Future<void> reject(String slug) => _api.post('/meetings/$slug/reject');
  Future<void> complete(String slug) => _api.post('/meetings/$slug/complete');
}

class ComplaintRepository {
  ComplaintRepository(this._api);
  final ApiClient _api;

  Future<List<dynamic>> list() async {
    final r = await _api.get('/complaints');
    return extractList(r['data']);
  }

  Future<Map<String, dynamic>> detail(String slug) async {
    final r = await _api.get('/complaints/$slug');
    return extractMap(r['data']);
  }

  Future<void> create({
    required String biodataSlug,
    required int reason,
    required String contactNo,
    String? details,
    String? attachmentPath,
  }) async {
    if (attachmentPath != null) {
      await _api.postMultipart('/complaints', FormData.fromMap({
        'biodata_slug': biodataSlug,
        'reason': reason,
        'contact_no': contactNo,
        if (details != null) 'details': details,
        'attachment': await MultipartFile.fromFile(attachmentPath),
      }));
    } else {
      await _api.post('/complaints', body: {
        'biodata_slug': biodataSlug,
        'reason': reason,
        'contact_no': contactNo,
        if (details != null) 'details': details,
      });
    }
  }

  Future<void> sendMessage(String slug, String message, {String? attachmentPath}) async {
    if (attachmentPath != null) {
      await _api.postMultipart('/complaints/$slug/messages', FormData.fromMap({
        'message': message,
        'attachment': await MultipartFile.fromFile(attachmentPath),
      }));
    } else {
      await _api.post('/complaints/$slug/messages', body: {'message': message});
    }
  }
}

class NotificationRepository {
  NotificationRepository(this._api);
  final ApiClient _api;

  Future<List<dynamic>> list() async {
    final r = await _api.get('/notifications');
    return extractList(r['data']);
  }

  Future<int> unreadCount() async {
    final r = await _api.get('/notifications/unread-count');
    return (r['data'] as Map?)?['count'] as int? ?? 0;
  }

  Future<void> markRead(int id) => _api.post('/notifications/$id/read');
  Future<void> markAllRead() => _api.post('/notifications/read-all');
}

class PhotoAccessRepository {
  PhotoAccessRepository(this._api);
  final ApiClient _api;

  Future<Map<String, dynamic>> list() async {
    final r = await _api.get('/photo-access');
    return extractMap(r['data']);
  }

  Future<void> request(String slug, {String? message}) async {
    final body = message != null ? {'message': message} : null;
    await _api.post('/photo-access/$slug', body: body);
  }

  Future<void> respond(int id, String action) async {
    await _api.post('/photo-access/$id/$action');
  }
}

class Phase3Repository {
  Phase3Repository(this._api);
  final ApiClient _api;

  Future<Map<String, dynamic>> videoStatus() async {
    final r = await _api.get('/video-biodata');
    return extractMap(r['data']);
  }

  Future<void> uploadVideo(String path) async {
    await _api.postMultipart('/video-biodata/upload', FormData.fromMap({
      'video': await MultipartFile.fromFile(path),
    }));
  }

  Future<List<dynamic>> consultants() async {
    final r = await _api.get('/consultants');
    return extractList(r['data']);
  }

  Future<Map<String, dynamic>> consultantDetail(int id) async {
    final r = await _api.get('/consultants/$id');
    return extractMap(r['data']);
  }

  Future<void> bookConsultant(int id, {required String scheduledAt, String? notes}) async {
    await _api.post('/consultants/$id/book', body: {
      'scheduled_at': scheduledAt,
      if (notes != null) 'notes': notes,
    });
  }

  Future<List<dynamic>> myBookings() async {
    final r = await _api.get('/consultants/bookings');
    return extractList(r['data']);
  }

  Future<List<dynamic>> weddingCategories() async {
    final r = await _api.get('/wedding-services/categories');
    return extractList(r['data']);
  }

  Future<List<dynamic>> weddingServices({String? category}) async {
    final query = category != null ? {'category': category} : null;
    final r = await _api.get('/wedding-services', query: query);
    return extractList(r['data']);
  }
}
