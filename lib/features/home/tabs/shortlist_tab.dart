import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getmarried/core/providers/app_providers.dart';
import 'package:getmarried/features/profile/biodata_detail_screen.dart';

class ShortlistTab extends ConsumerStatefulWidget {
  const ShortlistTab({super.key});

  @override
  ConsumerState<ShortlistTab> createState() => _ShortlistTabState();
}

class _ShortlistTabState extends ConsumerState<ShortlistTab> {
  List<dynamic> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final items = await ref.read(interactionRepositoryProvider).shortlist();
      setState(() => _items = items);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_items.isEmpty) return const Center(child: Text('Shortlist is empty'));

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index] as Map<String, dynamic>;
          final slug = item['slug']?.toString() ?? '';
          return ListTile(
            title: Text(item['biodata_no']?.toString() ?? ''),
            subtitle: Text(item['district_name']?.toString() ?? ''),
            trailing: const Icon(Icons.chevron_right),
            onTap: slug.isEmpty
                ? null
                : () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => BiodataDetailScreen(slug: slug)),
                    ),
          );
        },
      ),
    );
  }
}
