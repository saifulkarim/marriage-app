import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getmarried/core/providers/app_providers.dart';
import 'package:getmarried/features/complaints/complaint_detail_screen.dart';

class ComplaintsScreen extends ConsumerStatefulWidget {
  const ComplaintsScreen({super.key});

  @override
  ConsumerState<ComplaintsScreen> createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends ConsumerState<ComplaintsScreen> {
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
      _items = await ref.read(complaintRepositoryProvider).list();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Support Reports')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? const Center(child: Text('No reports submitted'))
              : ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, i) {
                    final c = _items[i] as Map<String, dynamic>;
                    return ListTile(
                      title: Text(c['complain_no']?.toString() ?? ''),
                      subtitle: Text('Biodata: ${c['biodata_no'] ?? ''}'),
                      trailing: Text(_statusLabel(c['status'])),
                      onTap: () => Navigator.push(context, MaterialPageRoute(
                        builder: (_) => ComplaintDetailScreen(slug: c['slug']?.toString() ?? ''),
                      )),
                    );
                  },
                ),
    );
  }

  String _statusLabel(dynamic s) => switch (s) { 1 => 'In Progress', 2 => 'Complete', 3 => 'Cancelled', _ => 'Pending' };
}
