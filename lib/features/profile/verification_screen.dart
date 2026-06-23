import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getmarried/core/api/api_client.dart';
import 'package:getmarried/core/providers/app_providers.dart';
import 'package:image_picker/image_picker.dart';

class VerificationScreen extends ConsumerStatefulWidget {
  const VerificationScreen({super.key});

  @override
  ConsumerState<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends ConsumerState<VerificationScreen> {
  Map<String, dynamic>? _status;
  String? _nidPath;
  String? _selfiePath;
  bool _loading = true;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      _status = await ref.read(profileRepositoryProvider).verificationStatus();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _pick(bool selfie) async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) setState(() => selfie ? _selfiePath = file.path : _nidPath = file.path);
  }

  Future<void> _submit() async {
    if (_nidPath == null && _selfiePath == null) return;
    setState(() => _submitting = true);
    try {
      await ref.read(profileRepositoryProvider).submitVerification(nidPath: _nidPath, selfiePath: _selfiePath);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Documents submitted')));
      _load();
    } on ApiException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verification')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                if (_status != null) ...[
                  Text('NID Status: ${_status!['nid_status'] ?? 'N/A'}'),
                  Text('Face Status: ${_status!['face_status'] ?? 'N/A'}'),
                  const SizedBox(height: 16),
                ],
                OutlinedButton.icon(onPressed: () => _pick(false), icon: const Icon(Icons.badge), label: Text(_nidPath ?? 'Upload NID')),
                const SizedBox(height: 8),
                OutlinedButton.icon(onPressed: () => _pick(true), icon: const Icon(Icons.face), label: Text(_selfiePath ?? 'Upload Selfie')),
                const SizedBox(height: 24),
                FilledButton(onPressed: _submitting ? null : _submit, child: _submitting ? const CircularProgressIndicator() : const Text('Submit')),
              ]),
            ),
    );
  }
}
