import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getmarried/core/api/api_client.dart';
import 'package:getmarried/core/providers/app_providers.dart';

class PhotoAccessScreen extends ConsumerStatefulWidget {
  const PhotoAccessScreen({super.key});

  @override
  ConsumerState<PhotoAccessScreen> createState() => _PhotoAccessScreenState();
}

class _PhotoAccessScreenState extends ConsumerState<PhotoAccessScreen> with SingleTickerProviderStateMixin {
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
      _data = await ref.read(photoAccessRepositoryProvider).list();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  List<dynamic> _items(String key) {
    final section = _data?[key];
    if (section is Map && section['data'] is List) return section['data'] as List;
    return [];
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return Scaffold(appBar: AppBar(), body: const Center(child: CircularProgressIndicator()));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Access'),
        bottom: TabBar(controller: _tab, tabs: const [Tab(text: 'Incoming'), Tab(text: 'Outgoing')]),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _list(_items('incoming'), incoming: true),
          _list(_items('outgoing'), incoming: false),
        ],
      ),
    );
  }

  Widget _list(List<dynamic> items, {required bool incoming}) {
    if (items.isEmpty) return const Center(child: Text('No requests'));
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, i) {
        final item = items[i] as Map<String, dynamic>;
        return ListTile(
          title: Text(item['biodata']?['biodata_no']?.toString() ?? item['requester']?['name']?.toString() ?? 'Request'),
          subtitle: Text(item['status']?.toString() ?? ''),
          trailing: incoming && item['status'] == 'pending'
              ? Row(mainAxisSize: MainAxisSize.min, children: [
                  IconButton(icon: const Icon(Icons.check), onPressed: () => _respond(item['id'] as int, 'approved')),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => _respond(item['id'] as int, 'rejected')),
                ])
              : null,
        );
      },
    );
  }

  Future<void> _respond(int id, String action) async {
    try {
      await ref.read(photoAccessRepositoryProvider).respond(id, action);
      _load();
    } on ApiException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }
}
