import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getmarried/core/api/api_client.dart';
import 'package:getmarried/core/providers/app_providers.dart';

class MeetingsScreen extends ConsumerStatefulWidget {
  const MeetingsScreen({super.key});

  @override
  ConsumerState<MeetingsScreen> createState() => _MeetingsScreenState();
}

class _MeetingsScreenState extends ConsumerState<MeetingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tab;
  Map<String, dynamic>? _data;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      _data = await ref.read(meetingRepositoryProvider).list();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  List<dynamic> _items(String key) {
    final section = _data?[key];
    if (section is Map && section['data'] is List) return section['data'] as List;
    return [];
  }

  Future<void> _action(String slug, Future<void> Function() fn) async {
    try {
      await fn();
      _load();
    } on ApiException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return Scaffold(appBar: AppBar(), body: const Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meetings'),
        bottom: TabBar(controller: _tab, tabs: const [Tab(text: 'Received'), Tab(text: 'Sent')]),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _list(_items('received'), isReceived: true),
          _list(_items('sent'), isReceived: false),
        ],
      ),
    );
  }

  Widget _list(List<dynamic> items, {required bool isReceived}) {
    if (items.isEmpty) return const Center(child: Text('No meetings'));
    final repo = ref.read(meetingRepositoryProvider);
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, i) {
        final m = items[i] as Map<String, dynamic>;
        final slug = m['slug']?.toString() ?? '';
        final status = m['status'] as int? ?? 0;
        return ListTile(
          title: Text(m['candidate_name']?.toString() ?? m['biodata_no']?.toString() ?? 'Meeting'),
          subtitle: Text('${m['proposed_date']} • Status: $status'),
          trailing: isReceived && status == 0
              ? Row(mainAxisSize: MainAxisSize.min, children: [
                  IconButton(icon: const Icon(Icons.check, color: Colors.green), onPressed: () => _action(slug, () => repo.accept(slug))),
                  IconButton(icon: const Icon(Icons.close, color: Colors.red), onPressed: () => _action(slug, () => repo.reject(slug))),
                ])
              : null,
        );
      },
    );
  }
}
