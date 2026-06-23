import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getmarried/core/api/api_client.dart';
import 'package:getmarried/core/providers/app_providers.dart';
import 'package:getmarried/core/theme/app_colors.dart';
import 'package:getmarried/features/billing/payment_webview_screen.dart';

class BillingScreen extends ConsumerStatefulWidget {
  const BillingScreen({super.key});

  @override
  ConsumerState<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends ConsumerState<BillingScreen> {
  Map<String, dynamic>? _credits;
  Map<String, dynamic>? _subscription;
  List<dynamic> _plans = [];
  bool _loading = true;
  int _selectedPlan = 1;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final billing = ref.read(billingRepositoryProvider);
      final meta = ref.read(metaRepositoryProvider);
      final credits = await billing.credits();
      final sub = await billing.subscription();
      final packages = await meta.packages();
      setState(() {
        _credits = credits;
        _subscription = sub;
        _plans = packages['subscription_plans'] as List? ?? [];
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _buyCredits(int pack) async {
    try {
      final url = await ref.read(billingRepositoryProvider).purchaseCredits(pack);
      if (url.isEmpty) throw ApiException('Payment URL not available');
      if (!mounted) return;
      final ok = await Navigator.of(context).push<bool>(
        MaterialPageRoute(builder: (_) => PaymentWebViewScreen(paymentUrl: url, title: 'Buy Credits')),
      );
      if (ok == true) _load();
    } on ApiException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<void> _buyPlan(String slug) async {
    try {
      final url = await ref.read(billingRepositoryProvider).purchaseSubscription(slug);
      if (url.isEmpty) throw ApiException('Payment URL not available');
      if (!mounted) return;
      final ok = await Navigator.of(context).push<bool>(
        MaterialPageRoute(builder: (_) => PaymentWebViewScreen(paymentUrl: url, title: 'Subscription')),
      );
      if (ok == true) _load();
    } on ApiException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: AppColors.primary)));
    }

    final balance = _credits?['balance'] ?? 0;
    final packs = _credits?['packs'] as List? ?? [];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Unlock Contact Details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Unlock Contact Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                      SizedBox(height: 4),
                      Text('View phone number, email & chat without limits', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                Icon(Icons.lock, size: 48, color: AppColors.primary.withValues(alpha: 0.5)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _UnlockFeature(Icons.phone, 'Phone'),
              _UnlockFeature(Icons.email_outlined, 'Email'),
              _UnlockFeature(Icons.chat_bubble_outline, 'Chat'),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Credit Balance', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
            child: Row(
              children: [
                const Icon(Icons.account_balance_wallet, color: AppColors.primary),
                const SizedBox(width: 12),
                Text('$balance Credits', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ...packs.map((pack) {
            final p = pack as Map<String, dynamic>;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
              child: Row(
                children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('${p['connections']} Connections', style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text('৳ ${p['price']}', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                  ])),
                  FilledButton(onPressed: () => _buyCredits(p['connections'] as int), child: const Text('Buy')),
                ],
              ),
            );
          }),
          const SizedBox(height: 24),
          const Text('Choose a Plan', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _plans.length,
              itemBuilder: (context, i) {
                final p = _plans[i] as Map<String, dynamic>;
                final popular = i == _selectedPlan;
                return GestureDetector(
                  onTap: () => setState(() => _selectedPlan = i),
                  child: Container(
                    width: 140,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: popular ? AppColors.primary : AppColors.border, width: popular ? 2 : 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (popular)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                            child: const Text('POPULAR', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
                          ),
                        const Spacer(),
                        Text(p['name']?.toString() ?? '', style: const TextStyle(fontWeight: FontWeight.w700)),
                        Text('৳ ${p['price']}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.primary)),
                        Text('${p['duration_days']} days', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: popular
                              ? FilledButton(onPressed: () => _buyPlan(p['slug']?.toString() ?? ''), child: const Text('Select', style: TextStyle(fontSize: 12)))
                              : OutlinedButton(onPressed: () => _buyPlan(p['slug']?.toString() ?? ''), child: const Text('Select', style: TextStyle(fontSize: 12))),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFECFDF5), borderRadius: BorderRadius.circular(12)),
            child: const Row(
              children: [
                Icon(Icons.shield_outlined, color: AppColors.success),
                SizedBox(width: 10),
                Expanded(child: Text('Secure Payment. SSL encrypted checkout.', style: TextStyle(fontSize: 12))),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text('Current plan: ${_subscription?['current_plan'] ?? 'free'}', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _UnlockFeature extends StatelessWidget {
  const _UnlockFeature(this.icon, this.label);
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }
}
