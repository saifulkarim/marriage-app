import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getmarried/core/providers/app_providers.dart';
import 'package:getmarried/features/profile/biodata_detail_screen.dart';

class UnlockedScreen extends ConsumerStatefulWidget {
  const UnlockedScreen({super.key});

  @override
  ConsumerState<UnlockedScreen> createState() => _UnlockedScreenState();
}

class _UnlockedScreenState extends ConsumerState<UnlockedScreen> {
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
      _items = await ref.read(profileRepositoryProvider).unlockedBiodatas();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Unlocked Contacts')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? const Center(child: Text('No unlocked biodatas yet'))
              : ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, i) {
                    final item = _items[i] as Map<String, dynamic>;
                    final slug = item['slug']?.toString() ?? '';
                    return ListTile(
                      title: Text(item['biodata_no']?.toString() ?? ''),
                      subtitle: Text(item['district_name']?.toString() ?? ''),
                      onTap: slug.isEmpty ? null : () => Navigator.push(context, MaterialPageRoute(builder: (_) => BiodataDetailScreen(slug: slug))),
                    );
                  },
                ),
    );
  }
}
