import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getmarried/core/api/api_client.dart';
import 'package:getmarried/core/providers/app_providers.dart';
import 'package:getmarried/features/profile/biodata_detail_screen.dart';

class SearchTab extends ConsumerStatefulWidget {
  const SearchTab({super.key});

  @override
  ConsumerState<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends ConsumerState<SearchTab> {
  List<dynamic> _results = [];
  bool _loading = false;
  String? _error;
  final _biodataNoController = TextEditingController();

  @override
  void dispose() {
    _biodataNoController.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final results = await ref.read(interactionRepositoryProvider).search(
        filters: {'per_page': 20},
      );
      setState(() => _results = results);
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _searchByNumber() async {
    final no = _biodataNoController.text.trim();
    if (no.isEmpty) return;
    try {
      final biodata = await ref.read(profileRepositoryProvider).searchByNumber(no);
      final slug = biodata['slug']?.toString();
      if (slug != null && mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => BiodataDetailScreen(slug: slug)),
        );
      }
    } on ApiException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  void initState() {
    super.initState();
    _search();
  }

  void _openDetail(String slug) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => BiodataDetailScreen(slug: slug)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _biodataNoController,
                  decoration: const InputDecoration(
                    hintText: 'Biodata No (e.g. G102)',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(onPressed: _searchByNumber, child: const Text('Go')),
            ],
          ),
        ),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(_error!),
                          const SizedBox(height: 12),
                          FilledButton(onPressed: _search, child: const Text('Retry')),
                        ],
                      ),
                    )
                  : _results.isEmpty
                      ? const Center(child: Text('No biodata found'))
                      : RefreshIndicator(
                          onRefresh: _search,
                          child: ListView.builder(
                            itemCount: _results.length,
                            itemBuilder: (context, index) {
                              final item = _results[index] as Map<String, dynamic>;
                              final slug = item['slug']?.toString() ?? '';
                              return ListTile(
                                leading: CircleAvatar(
                                  child: Text(item['biodata_no']?.toString().substring(0, 1) ?? '?'),
                                ),
                                title: Text(item['biodata_no']?.toString() ?? 'Unknown'),
                                subtitle: Text(
                                  '${item['district_name'] ?? item['district_name_bn'] ?? ''} • ${item['birth_date'] ?? ''}',
                                ),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: slug.isEmpty ? null : () => _openDetail(slug),
                              );
                            },
                          ),
                        ),
        ),
      ],
    );
  }
}
