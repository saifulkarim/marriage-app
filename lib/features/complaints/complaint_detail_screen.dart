import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getmarried/core/api/api_client.dart';
import 'package:getmarried/core/providers/app_providers.dart';

class ComplaintDetailScreen extends ConsumerStatefulWidget {
  const ComplaintDetailScreen({super.key, required this.slug});
  final String slug;

  @override
  ConsumerState<ComplaintDetailScreen> createState() => _ComplaintDetailScreenState();
}

class _ComplaintDetailScreenState extends ConsumerState<ComplaintDetailScreen> {
  Map<String, dynamic>? _data;
  final _msgController = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      _data = await ref.read(complaintRepositoryProvider).detail(widget.slug);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _send() async {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;
    try {
      await ref.read(complaintRepositoryProvider).sendMessage(widget.slug, text);
      _msgController.clear();
      _load();
    } on ApiException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return Scaffold(appBar: AppBar(), body: const Center(child: CircularProgressIndicator()));
    final messages = _data?['messages'] as List? ?? [];
    return Scaffold(
      appBar: AppBar(title: Text(_data?['complain']?['complain_no']?.toString() ?? 'Report')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, i) {
                final m = messages[i] as Map<String, dynamic>;
                return ListTile(title: Text(m['message']?.toString() ?? ''));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(children: [
              Expanded(child: TextField(controller: _msgController, decoration: const InputDecoration(hintText: 'Reply...', border: OutlineInputBorder()))),
              IconButton(onPressed: _send, icon: const Icon(Icons.send)),
            ]),
          ),
        ],
      ),
    );
  }
}
