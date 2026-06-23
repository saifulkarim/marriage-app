import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getmarried/core/providers/app_providers.dart';
import 'package:getmarried/core/theme/app_colors.dart';
import 'package:getmarried/features/chat/chats_screen.dart';
import 'package:getmarried/features/more/more_menu_screen.dart';
import 'package:getmarried/features/notifications/notifications_screen.dart';
import 'package:getmarried/shared/widgets/app_logo.dart';

class AppHeader extends ConsumerWidget {
  const AppHeader({
    super.key,
    this.showMenu = true,
    this.showBack = false,
    this.onBack,
    this.trailing,
  });

  final bool showMenu;
  final bool showBack;
  final VoidCallback? onBack;
  final Widget? trailing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unread = ref.watch(unreadNotificationCountProvider);

    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
      child: Row(
        children: [
          if (showBack)
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              onPressed: onBack ?? () => Navigator.maybePop(context),
            )
          else if (showMenu)
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MoreMenuScreen()),
              ),
            )
          else
            const SizedBox(width: 48),
          const Expanded(child: Center(child: AppLogo(size: 18))),
          trailing ??
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _BadgeIcon(
                    icon: Icons.chat_bubble_outline,
                    count: 0,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ChatsScreen()),
                    ),
                  ),
                  unread.when(
                    data: (count) => _BadgeIcon(
                      icon: Icons.notifications_outlined,
                      count: count,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                        ).then((_) => ref.invalidate(unreadNotificationCountProvider));
                      },
                    ),
                    loading: () => _BadgeIcon(
                      icon: Icons.notifications_outlined,
                      count: 0,
                      onTap: () {},
                    ),
                    error: (_, _) => _BadgeIcon(
                      icon: Icons.notifications_outlined,
                      count: 0,
                      onTap: () {},
                    ),
                  ),
                ],
              ),
        ],
      ),
    );
  }
}

class _BadgeIcon extends StatelessWidget {
  const _BadgeIcon({required this.icon, required this.count, required this.onTap});

  final IconData icon;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(icon: Icon(icon), onPressed: onTap),
        if (count > 0)
          Positioned(
            right: 6,
            top: 6,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                count > 9 ? '9+' : '$count',
                style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
