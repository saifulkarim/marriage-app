import 'dart:io';

import 'package:dio/dio.dart';
import 'package:getmarried/core/api/api_client.dart';
import 'package:path_provider/path_provider.dart';

class ProfileRepository {
  ProfileRepository(this._api);

  final ApiClient _api;

  Future<Map<String, dynamic>> dashboard() async {
    final r = await _api.get('/profile');
    return extractMap(r['data']);
  }

  Future<Map<String, dynamic>> biodataDetail(String slug) async {
    final r = await _api.get('/biodata/$slug');
    return extractMap(r['data']);
  }

  Future<void> saveGeneral(Map<String, dynamic> data) async {
    await _api.put('/profile/general', body: data);
  }

  Future<void> saveAddress(Map<String, dynamic> data) async {
    await _api.put('/profile/address', body: data);
  }

  Future<void> saveAnswers(List<Map<String, dynamic>> answers) async {
    await _api.put('/profile/answers', body: {'answers': answers});
  }

  Future<void> saveContact({
    required String candidateName,
    required String guardiansMobile,
    required String relationWithGuardian,
    required String email,
    String? contactNo,
    required bool showImage,
    String? imagePath,
  }) async {
    final form = FormData.fromMap({
      'candidate_name': candidateName,
      'gurdians_mobile_no': guardiansMobile,
      'relation_with_gurdian': relationWithGuardian,
      'email': email,
      if (contactNo != null) 'contact_no': contactNo,
      'show_image': showImage ? '1' : '0',
      if (imagePath != null)
        'image': await MultipartFile.fromFile(imagePath, filename: 'photo.jpg'),
    });
    await _api.putMultipart('/profile/contact', form);
  }

  Future<Map<String, dynamic>> searchByNumber(String number) async {
    final r = await _api.get('/profile/search-no/$number');
    return extractMap(r['data']);
  }

  Future<Map<String, dynamic>> preferences() async {
    final r = await _api.get('/profile/preferences');
    return extractMap(r['data']);
  }

  Future<void> savePreferences(Map<String, dynamic> data) async {
    await _api.put('/profile/preferences', body: data);
  }

  Future<void> saveExpatriate(Map<String, dynamic> data) async {
    await _api.put('/profile/expatriate', body: data);
  }

  Future<Map<String, dynamic>> verificationStatus() async {
    final r = await _api.get('/profile/verification');
    return extractMap(r['data']);
  }

  Future<void> submitVerification({String? nidPath, String? selfiePath}) async {
    final form = FormData.fromMap({
      if (nidPath != null) 'nid_file': await MultipartFile.fromFile(nidPath),
      if (selfiePath != null) 'selfie_file': await MultipartFile.fromFile(selfiePath),
    });
    await _api.postMultipart('/profile/verification', form);
  }

  Future<List<dynamic>> unlockedBiodatas() async {
    final r = await _api.get('/profile/unlocked');
    return extractList(r['data']);
  }

  Future<Map<String, dynamic>> viewContact(String slug) async {
    final r = await _api.get('/biodata/$slug/contact');
    return extractMap(r['data']);
  }

  Future<Map<String, dynamic>> completeUnlock(String interestSlug) async {
    final r = await _api.post('/interests/$interestSlug/unlock-complete');
    return extractMap(r['data']);
  }

  Future<void> deleteBiodataRequest() async {
    await _api.post('/profile/delete-request');
  }

  Future<void> cancelDeleteRequest() async {
    await _api.post('/profile/cancel-delete-request');
  }

  Future<String> downloadBiodataPdf(String slug, {String? locale}) async {
    final file = await _api.download(
      '/biodata/$slug/pdf',
      query: locale != null ? {'locale': locale} : null,
    );
    final dir = await getApplicationDocumentsDirectory();
    final safeName = file.filename.replaceAll(RegExp(r'[^\w.\-]'), '_');
    final path = '${dir.path}/$safeName';
    await File(path).writeAsBytes(file.bytes);
    return path;
  }
}
