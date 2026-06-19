import 'package:getmarried/core/api/api_client.dart';

class MetaRepository {
  MetaRepository(this._api);

  final ApiClient _api;

  Future<List<dynamic>> districts() async {
    final r = await _api.get('/meta/districts');
    return extractList(r['data']);
  }

  Future<List<dynamic>> upazilas(int districtId) async {
    final r = await _api.get('/meta/upazilas/$districtId');
    return extractList(r['data']);
  }

  Future<List<dynamic>> biodataTypes() async {
    final r = await _api.get('/meta/biodata-types');
    return extractList(r['data']);
  }

  Future<List<dynamic>> maritalConditions() async {
    final r = await _api.get('/meta/marital-conditions');
    return extractList(r['data']);
  }

  Future<List<dynamic>> countries() async {
    final r = await _api.get('/meta/countries');
    return extractList(r['data']);
  }

  Future<Map<String, dynamic>> questionSetsBundle() async {
    final r = await _api.get('/meta/question-sets');
    return extractMap(r['data']);
  }

  Future<Map<String, dynamic>> packages() async {
    final r = await _api.get('/meta/packages');
    return extractMap(r['data']);
  }
}
