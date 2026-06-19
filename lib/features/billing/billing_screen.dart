import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getmarried/core/api/api_client.dart';
import 'package:getmarried/core/providers/app_providers.dart';
import 'package:getmarried/features/billing/payment_webview_screen.dart';

class BillingScreen extends ConsumerStatefulWidget {
  const BillingScreen({super.key});

  @override
  ConsumerState<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends ConsumerState<BillingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic>? _credits;
  Map<String, dynamic>? _subscription;
  List<dynamic> _plans = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final balance = _credits?['balance'] ?? 0;
    final packs = _credits?['packs'] as List? ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Billing'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Credits'), Tab(text: 'Subscription')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: ListTile(
                  title: const Text('Credit Balance'),
                  trailing: Text('$balance', style: Theme.of(context).textTheme.titleLarge),
                ),
              ),
              const SizedBox(height: 16),
              ...packs.map((pack) {
                final p = pack as Map<String, dynamic>;
                return Card(
                  child: ListTile(
                    title: Text('${p['connections']} Connections'),
                    subtitle: Text('৳ ${p['price']}'),
                    trailing: FilledButton(
                      onPressed: () => _buyCredits(p['connections'] as int),
                      child: const Text('Buy'),
                    ),
                  ),
                );
              }),
            ],
          ),
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: ListTile(
                  title: const Text('Current Plan'),
                  subtitle: Text(_subscription?['current_plan']?.toString() ?? 'free'),
                  trailing: Text(_subscription?['expires_at']?.toString() ?? ''),
                ),
              ),
              const SizedBox(height: 16),
              ..._plans.map((plan) {
                final p = plan as Map<String, dynamic>;
                return Card(
                  child: ListTile(
                    title: Text(p['name']?.toString() ?? p['slug']?.toString() ?? ''),
                    subtitle: Text('৳ ${p['price']} / ${p['duration_days']} days'),
                    trailing: FilledButton(
                      onPressed: () => _buyPlan(p['slug']?.toString() ?? ''),
                      child: const Text('Subscribe'),
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}
