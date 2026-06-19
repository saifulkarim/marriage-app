import 'package:getmarried/core/api/api_client.dart';

class InteractionRepository {
  InteractionRepository(this._api);

  final ApiClient _api;

  Future<Map<String, dynamic>> interests() async {
    final r = await _api.get('/interests');
    return extractMap(r['data']);
  }

  Future<void> sendInterest(String slug) async {
    await _api.post('/interests/$slug');
  }

  Future<void> acceptInterest(String slug) async {
    await _api.post('/interests/$slug/accept');
  }

  Future<void> rejectInterest(String slug) async {
    await _api.post('/interests/$slug/reject');
  }

  Future<void> withdrawInterest(String slug) async {
    await _api.post('/interests/$slug/withdraw');
  }

  Future<List<dynamic>> shortlist() async {
    final r = await _api.get('/shortlist');
    return extractList(r['data']);
  }

  Future<void> addShortlist(String slug) async {
    await _api.post('/shortlist/$slug');
  }

  Future<void> addIgnore(String slug) async {
    await _api.post('/ignore/$slug');
  }

  Future<List<dynamic>> search({Map<String, dynamic>? filters}) async {
    final r = await _api.get('/search', query: filters);
    return extractList(r['data']);
  }

  Future<List<dynamic>> topMatches({int limit = 20}) async {
    final r = await _api.get('/matches/top', query: {'limit': limit});
    return extractList(r['data']);
  }
}
