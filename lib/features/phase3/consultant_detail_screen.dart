import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getmarried/core/api/api_client.dart';
import 'package:getmarried/core/providers/app_providers.dart';

class ConsultantDetailScreen extends ConsumerStatefulWidget {
  const ConsultantDetailScreen({super.key, required this.id});
  final int id;

  @override
  ConsumerState<ConsultantDetailScreen> createState() => _ConsultantDetailScreenState();
}

class _ConsultantDetailScreenState extends ConsumerState<ConsultantDetailScreen> {
  Map<String, dynamic>? _c;
  final _dateController = TextEditingController();
  final _notesController = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      _c = await ref.read(phase3RepositoryProvider).consultantDetail(widget.id);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _book() async {
    try {
      await ref.read(phase3RepositoryProvider).bookConsultant(
        widget.id,
        scheduledAt: _dateController.text.trim(),
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booking requested')));
        Navigator.pop(context);
      }
    } on ApiException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return Scaffold(appBar: AppBar(), body: const Center(child: CircularProgressIndicator()));
    return Scaffold(
      appBar: AppBar(title: Text(_c?['title']?.toString() ?? 'Consultant')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(_c?['bio']?.toString() ?? '', style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 8),
          Text('Rate: ৳ ${_c?['hourly_rate']} / hour'),
          Text('Rating: ${_c?['rating']} (${_c?['sessions_count']} sessions)'),
          const SizedBox(height: 24),
          TextField(controller: _dateController, decoration: const InputDecoration(labelText: 'Date & Time (YYYY-MM-DD HH:MM)', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: _notesController, decoration: const InputDecoration(labelText: 'Notes (optional)', border: OutlineInputBorder()), maxLines: 3),
          const SizedBox(height: 24),
          FilledButton(onPressed: _book, child: const Text('Book Consultation')),
        ]),
      ),
    );
  }
}
