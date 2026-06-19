import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getmarried/core/api/api_client.dart';
import 'package:getmarried/core/providers/app_providers.dart';

class BiodataDetailScreen extends ConsumerStatefulWidget {
  const BiodataDetailScreen({super.key, required this.slug});

  final String slug;

  @override
  ConsumerState<BiodataDetailScreen> createState() => _BiodataDetailScreenState();
}

class _BiodataDetailScreenState extends ConsumerState<BiodataDetailScreen> {
  Map<String, dynamic>? _data;
  bool _loading = true;
  bool _actionLoading = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final data = await ref.read(profileRepositoryProvider).biodataDetail(widget.slug);
      setState(() => _data = data);
    } on ApiException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _action(Future<void> Function() fn, String success) async {
    setState(() => _actionLoading = true);
    try {
      await fn();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(success)));
    } on ApiException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _actionLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final biodata = _data?['biodata'] as Map<String, dynamic>? ?? {};
    final answers = _data?['answers'] as List? ?? [];
    final image = biodata['image']?.toString();

    return Scaffold(
      appBar: AppBar(title: Text(biodata['biodata_no']?.toString() ?? 'Biodata')),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _actionLoading
                      ? null
                      : () => _action(
                            () => ref.read(interactionRepositoryProvider).addShortlist(widget.slug),
                            'Shortlisted',
                          ),
                  icon: const Icon(Icons.bookmark),
                  label: const Text('Shortlist'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.icon(
                  onPressed: _actionLoading
                      ? null
                      : () => _action(
                            () => ref.read(interactionRepositoryProvider).sendInterest(widget.slug),
                            'Interest sent',
                          ),
                  icon: const Icon(Icons.favorite),
                  label: const Text('Interest'),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (image != null && image.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(image, height: 200, width: double.infinity, fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const SizedBox(height: 120, child: Icon(Icons.person, size: 80))),
            ),
          const SizedBox(height: 16),
          _infoTile('Birth Date', biodata['birth_date']),
          _infoTile('Height', '${biodata['height_foot'] ?? ''}\' ${biodata['height_inch'] ?? ''}"'),
          _infoTile('Weight', biodata['weight']),
          _infoTile('Skin Tone', biodata['skin_tone']),
          _infoTile('Blood Group', biodata['blood_group']),
          _infoTile('District', biodata['permenant_address']),
          const Divider(height: 32),
          Text('Details', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...answers.map((a) {
            final item = a as Map<String, dynamic>;
            return ListTile(
              title: Text(item['question']?.toString() ?? item['question_bn']?.toString() ?? ''),
              subtitle: Text(item['answer']?.toString() ?? ''),
            );
          }),
        ],
      ),
    );
  }

  Widget _infoTile(String label, dynamic value) {
    if (value == null || value.toString().isEmpty) return const SizedBox.shrink();
    return ListTile(title: Text(label), trailing: Text(value.toString()));
  }
}
