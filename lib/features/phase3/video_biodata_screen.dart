import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getmarried/core/api/api_client.dart';
import 'package:getmarried/core/providers/app_providers.dart';

class VideoBiodataScreen extends ConsumerStatefulWidget {
  const VideoBiodataScreen({super.key});

  @override
  ConsumerState<VideoBiodataScreen> createState() => _VideoBiodataScreenState();
}

class _VideoBiodataScreenState extends ConsumerState<VideoBiodataScreen> {
  Map<String, dynamic>? _data;
  bool _loading = true;
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      _data = await ref.read(phase3RepositoryProvider).videoStatus();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _upload() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);
    if (result == null || result.files.single.path == null) return;
    setState(() => _uploading = true);
    try {
      await ref.read(phase3RepositoryProvider).uploadVideo(result.files.single.path!);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Video uploaded for review')));
      _load();
    } on ApiException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final video = _data?['video'] as Map<String, dynamic>?;
    return Scaffold(
      appBar: AppBar(title: const Text('Video Biodata')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                if (video != null) ...[
                  Text('Status: ${video['status']}'),
                  if (video['video_url'] != null) Text('URL: ${video['video_url']}', maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 16),
                ] else
                  const Text('No video biodata uploaded yet.'),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _uploading ? null : _upload,
                  icon: _uploading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.upload),
                  label: const Text('Upload Video (MP4/WebM)'),
                ),
              ]),
            ),
    );
  }
}
