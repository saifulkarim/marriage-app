import 'package:getmarried/core/api/api_client.dart';

class BillingRepository {
  BillingRepository(this._api);

  final ApiClient _api;

  Future<Map<String, dynamic>> credits() async {
    final r = await _api.get('/billing/credits');
    return extractMap(r['data']);
  }

  Future<Map<String, dynamic>> subscription() async {
    final r = await _api.get('/billing/subscription');
    return extractMap(r['data']);
  }

  Future<String> purchaseCredits(int pack, {String gateway = 'ssl_commerz'}) async {
    final r = await _api.post('/billing/credits/purchase/$pack', body: {'gateway': gateway});
    return _paymentUrl(r['data']);
  }

  Future<String> purchaseSubscription(String plan, {String gateway = 'ssl_commerz'}) async {
    final r = await _api.post('/billing/subscription/purchase/$plan', body: {'gateway': gateway});
    return _paymentUrl(r['data']);
  }

  Future<Map<String, dynamic>> requestUnlock(String interestSlug) async {
    final r = await _api.post('/billing/unlock/$interestSlug');
    return extractMap(r['data']);
  }

  String _paymentUrl(dynamic data) {
    if (data is Map) {
      return data['payment_url']?.toString() ?? '';
    }
    return '';
  }
}
