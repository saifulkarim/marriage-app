import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getmarried/core/providers/app_providers.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
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
      final items = await ref.read(notificationRepositoryProvider).list();
      setState(() => _items = items);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(onPressed: () async {
            await ref.read(notificationRepositoryProvider).markAllRead();
            ref.invalidate(unreadNotificationCountProvider);
            _load();
          }, child: const Text('Read all')),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? const Center(child: Text('No notifications'))
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (context, i) {
                      final n = _items[i] as Map<String, dynamic>;
                      return ListTile(
                        title: Text(n['title']?.toString() ?? ''),
                        subtitle: Text(n['message']?.toString() ?? ''),
                        trailing: n['read_at'] == null ? const Icon(Icons.circle, size: 10, color: Colors.red) : null,
                        onTap: () async {
                          await ref.read(notificationRepositoryProvider).markRead(n['id'] as int);
                          ref.invalidate(unreadNotificationCountProvider);
                          _load();
                        },
                      );
                    },
                  ),
                ),
    );
  }
}
