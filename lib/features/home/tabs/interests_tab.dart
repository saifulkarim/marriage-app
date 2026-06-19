import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getmarried/core/api/api_client.dart';
import 'package:getmarried/core/providers/app_providers.dart';
import 'package:getmarried/features/profile/biodata_detail_screen.dart';

class InterestsTab extends ConsumerStatefulWidget {
  const InterestsTab({super.key});

  @override
  ConsumerState<InterestsTab> createState() => _InterestsTabState();
}

class _InterestsTabState extends ConsumerState<InterestsTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic>? _data;
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
      final data = await ref.read(interactionRepositoryProvider).interests();
      setState(() => _data = data);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  List<dynamic> _items(String key) {
    final section = _data?[key];
    if (section is Map && section['data'] is List) return section['data'] as List;
    return [];
  }

  Future<void> _action(Future<void> Function() fn) async {
    try {
      await fn();
      await _load();
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
    if (_loading) return const Center(child: CircularProgressIndicator());

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Sent'), Tab(text: 'Received')],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildList(_items('sent'), isReceived: false),
              _buildList(_items('received'), isReceived: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildList(List<dynamic> items, {required bool isReceived}) {
    if (items.isEmpty) return const Center(child: Text('No interests yet'));

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index] as Map<String, dynamic>;
          final slug = item['slug']?.toString() ?? '';
          final biodata = item['biodata'] as Map<String, dynamic>?;
          final biodataSlug = biodata?['slug']?.toString() ?? '';

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(biodata?['biodata_no']?.toString() ?? item['status_label']?.toString() ?? 'Interest'),
              subtitle: Text(item['status_label']?.toString() ?? ''),
              onTap: biodataSlug.isEmpty
                  ? null
                  : () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => BiodataDetailScreen(slug: biodataSlug)),
                      ),
              trailing: _actions(slug, item['status'] as int? ?? 0, isReceived),
            ),
          );
        },
      ),
    );
  }

  Widget? _actions(String slug, int status, bool isReceived) {
    if (slug.isEmpty) return null;
    final repo = ref.read(interactionRepositoryProvider);

    if (isReceived && status == 0) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.green),
            onPressed: () => _action(() => repo.acceptInterest(slug)),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: () => _action(() => repo.rejectInterest(slug)),
          ),
        ],
      );
    }

    if (!isReceived && status == 0) {
      return IconButton(
        icon: const Icon(Icons.undo),
        onPressed: () => _action(() => repo.withdrawInterest(slug)),
      );
    }

    if (status == 1) {
      return IconButton(
        icon: const Icon(Icons.lock_open),
        tooltip: 'Request unlock',
        onPressed: () => _action(() => ref.read(billingRepositoryProvider).requestUnlock(slug)),
      );
    }

    return null;
  }
}
