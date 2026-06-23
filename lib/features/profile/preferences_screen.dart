import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getmarried/core/api/api_client.dart';
import 'package:getmarried/core/providers/app_providers.dart';

class PreferencesScreen extends ConsumerStatefulWidget {
  const PreferencesScreen({super.key});

  @override
  ConsumerState<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends ConsumerState<PreferencesScreen> {
  final _ageMin = TextEditingController();
  final _ageMax = TextEditingController();
  final _religion = TextEditingController();
  final _education = TextEditingController();
  final _profession = TextEditingController();
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final p = await ref.read(profileRepositoryProvider).preferences();
      if (p.isNotEmpty) {
        _ageMin.text = '${p['age_min'] ?? ''}';
        _ageMax.text = '${p['age_max'] ?? ''}';
        _religion.text = p['religion']?.toString() ?? '';
        _education.text = p['education_level']?.toString() ?? '';
        _profession.text = p['profession']?.toString() ?? '';
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await ref.read(profileRepositoryProvider).savePreferences({
        if (_ageMin.text.isNotEmpty) 'age_min': int.tryParse(_ageMin.text),
        if (_ageMax.text.isNotEmpty) 'age_max': int.tryParse(_ageMax.text),
        'religion': _religion.text,
        'education_level': _education.text,
        'profession': _profession.text,
      });
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved')));
    } on ApiException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _ageMin.dispose();
    _ageMax.dispose();
    _religion.dispose();
    _education.dispose();
    _profession.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return Scaffold(appBar: AppBar(), body: const Center(child: CircularProgressIndicator()));
    return Scaffold(
      appBar: AppBar(title: const Text('Looking For')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: _ageMin, decoration: const InputDecoration(labelText: 'Min Age', border: OutlineInputBorder()), keyboardType: TextInputType.number),
          const SizedBox(height: 12),
          TextField(controller: _ageMax, decoration: const InputDecoration(labelText: 'Max Age', border: OutlineInputBorder()), keyboardType: TextInputType.number),
          const SizedBox(height: 12),
          TextField(controller: _religion, decoration: const InputDecoration(labelText: 'Religion', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: _education, decoration: const InputDecoration(labelText: 'Education', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: _profession, decoration: const InputDecoration(labelText: 'Profession', border: OutlineInputBorder())),
          const SizedBox(height: 24),
          FilledButton(onPressed: _saving ? null : _save, child: _saving ? const CircularProgressIndicator() : const Text('Save Preferences')),
        ],
      ),
    );
  }
}
