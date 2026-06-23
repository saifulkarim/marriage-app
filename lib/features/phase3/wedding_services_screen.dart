import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getmarried/core/providers/app_providers.dart';

class WeddingServicesScreen extends ConsumerStatefulWidget {
  const WeddingServicesScreen({super.key});

  @override
  ConsumerState<WeddingServicesScreen> createState() => _WeddingServicesScreenState();
}

class _WeddingServicesScreenState extends ConsumerState<WeddingServicesScreen> {
  List<dynamic> _categories = [];
  List<dynamic> _services = [];
  String? _selectedCategory;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final repo = ref.read(phase3RepositoryProvider);
      _categories = await repo.weddingCategories();
      _services = await repo.weddingServices(category: _selectedCategory);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wedding Services')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_categories.isNotEmpty)
                  SizedBox(
                    height: 48,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      children: [
                        FilterChip(
                          label: const Text('All'),
                          selected: _selectedCategory == null,
                          onSelected: (_) { setState(() => _selectedCategory = null); _load(); },
                        ),
                        ..._categories.map((c) => FilterChip(
                          label: Text(c.toString()),
                          selected: _selectedCategory == c.toString(),
                          onSelected: (_) { setState(() => _selectedCategory = c.toString()); _load(); },
                        )),
                      ],
                    ),
                  ),
                Expanded(
                  child: _services.isEmpty
                      ? const Center(child: Text('No services found'))
                      : ListView.builder(
                          itemCount: _services.length,
                          itemBuilder: (context, i) {
                            final s = _services[i] as Map<String, dynamic>;
                            return Card(
                              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              child: ListTile(
                                title: Text(s['title']?.toString() ?? ''),
                                subtitle: Text('${s['provider_name'] ?? ''}\n${s['district'] ?? ''}\nFrom ৳ ${s['price_from'] ?? ''}'),
                                isThreeLine: true,
                                trailing: s['contact_phone'] != null ? Icon(Icons.phone, color: Theme.of(context).colorScheme.primary) : null,
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
