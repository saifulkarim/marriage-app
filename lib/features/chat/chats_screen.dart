import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getmarried/core/locale/l10n_extension.dart';
import 'package:getmarried/core/providers/app_providers.dart';
import 'package:getmarried/core/theme/app_colors.dart';
import 'package:getmarried/features/chat/chat_room_screen.dart';

class ChatsScreen extends ConsumerStatefulWidget {
  const ChatsScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  ConsumerState<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends ConsumerState<ChatsScreen> {
  List<dynamic> _rooms = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      _rooms = await ref.read(chatRepositoryProvider).rooms();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final body = _loading
        ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
        : _rooms.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.chat_bubble_outline, size: 64, color: AppColors.primary.withValues(alpha: 0.4)),
                    const SizedBox(height: 16),
                    Text(l10n.noChatsYet, style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text(l10n.acceptInterestToChat, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                  ],
                ),
              )
            : RefreshIndicator(
                color: AppColors.primary,
                onRefresh: _load,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: _rooms.length,
                  separatorBuilder: (_, _) => const Divider(height: 1, indent: 72),
                  itemBuilder: (context, i) {
                    final r = _rooms[i] as Map<String, dynamic>;
                    final initial = ((r['partner_biodata_no'] ?? r['partner_name'] ?? '?').toString()).substring(0, 1);
                    final unread = r['unread_count'] as int? ?? 0;
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primaryLight,
                        child: Text(initial, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                      ),
                      title: Text(r['partner_name']?.toString() ?? l10n.chats, style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(
                        r['last_message']?['message']?.toString() ?? l10n.noMessagesYet,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                      ),
                      trailing: unread > 0
                          ? Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                              child: Text('$unread', style: const TextStyle(color: Colors.white, fontSize: 11)),
                            )
                          : null,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatRoomScreen(
                            roomId: r['id'] as int,
                            partnerName: r['partner_name']?.toString() ?? '',
                          ),
                        ),
                      ).then((_) => _load()),
                    );
                  },
                ),
              );

    if (widget.embedded) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(l10n.messages, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          ),
          Expanded(child: body),
        ],
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(l10n.chats)),
      body: body,
    );
  }
}
