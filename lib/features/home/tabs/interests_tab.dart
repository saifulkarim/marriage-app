import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getmarried/core/api/api_client.dart';
import 'package:getmarried/core/locale/l10n_extension.dart';
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
    final l10n = context.l10n;

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: [Tab(text: l10n.sent), Tab(text: l10n.received)],
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
    if (items.isEmpty) return Center(child: Text(context.l10n.noInterestsYet));

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
              title: Text(biodata?['biodata_no']?.toString() ?? item['status_label']?.toString() ?? context.l10n.interest),
              subtitle: Text(item['status_label']?.toString() ?? ''),
              onTap: biodataSlug.isEmpty
                  ? null
                  : () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => BiodataDetailScreen(slug: biodataSlug)),
                      ),
              trailing: _actions(slug, biodataSlug, item['status'] as int? ?? 0, isReceived),
            ),
          );
        },
      ),
    );
  }

  Widget? _actions(String interestSlug, String biodataSlug, int status, bool isReceived) {
    if (interestSlug.isEmpty) return null;
    final repo = ref.read(interactionRepositoryProvider);

    if (isReceived && status == 0) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.green),
            onPressed: () => _action(() => repo.acceptInterest(interestSlug)),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: () => _action(() => repo.rejectInterest(interestSlug)),
          ),
        ],
      );
    }

    if (!isReceived && status == 0) {
      return IconButton(
        icon: const Icon(Icons.undo),
        onPressed: () => _action(() => repo.withdrawInterest(interestSlug)),
      );
    }

    if (status == 1 && biodataSlug.isNotEmpty) {
      return IconButton(
        icon: const Icon(Icons.lock_open),
        tooltip: context.l10n.unlockContact,
        onPressed: () => _unlockContact(interestSlug, biodataSlug),
      );
    }

    return null;
  }

  Future<void> _unlockContact(String interestSlug, String biodataSlug) async {
    try {
      final billing = ref.read(billingRepositoryProvider);
      final profile = ref.read(profileRepositoryProvider);
      final result = await billing.requestUnlock(interestSlug);
      final unlockStatus = result['status']?.toString() ?? result['unlock']?['status']?.toString() ?? '';

      if (unlockStatus == 'pending_guardian') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.waitingGuardian)),
          );
        }
        return;
      }

      if (unlockStatus == 'completed') {
        await _showContact(biodataSlug);
        return;
      }

      final contact = await profile.completeUnlock(interestSlug);
      if (mounted) _showContactDialog(contact);
      await _load();
    } on ApiException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<void> _showContact(String biodataSlug) async {
    try {
      final contact = await ref.read(profileRepositoryProvider).viewContact(biodataSlug);
      if (mounted) _showContactDialog(contact);
    } on ApiException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  void _showContactDialog(Map<String, dynamic> contact) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.contactInfo),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (contact['name'] != null) Text('Name: ${contact['name']}'),
            if (contact['contact_no'] != null) Text('Phone: ${contact['contact_no']}'),
            if (contact['email'] != null) Text('Email: ${contact['email']}'),
            if (contact['gurdians_mobile_no'] != null) Text('Guardian: ${contact['gurdians_mobile_no']}'),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: Text(context.l10n.close))],
      ),
    );
  }
}
