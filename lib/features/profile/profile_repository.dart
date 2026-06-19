import 'package:dio/dio.dart';
import 'package:getmarried/core/api/api_client.dart';

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
}
