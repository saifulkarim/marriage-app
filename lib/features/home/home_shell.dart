import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getmarried/core/providers/app_providers.dart';
import 'package:getmarried/core/theme/app_theme.dart';
import 'package:getmarried/features/billing/billing_screen.dart';
import 'package:getmarried/features/chat/chats_screen.dart';
import 'package:getmarried/features/home/tabs/home_tab.dart';
import 'package:getmarried/features/home/tabs/profile_tab.dart';
import 'package:getmarried/features/home/tabs/search_tab.dart';
import 'package:getmarried/features/home/tabs/shortlist_tab.dart';
import 'package:getmarried/features/matches/matches_screen.dart';
import 'package:getmarried/features/profile/verification_screen.dart';
import 'package:getmarried/l10n/app_localizations.dart';
import 'package:getmarried/shared/widgets/app_header.dart';

class HomeShell extends ConsumerWidget {
  const HomeShell({super.key});

  void _onShortcut(BuildContext context, WidgetRef ref, String key) {
    switch (key) {
      case 'matches':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const MatchesScreen()));
      case 'premium':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const BillingScreen()));
      case 'shortlist':
        ref.read(homeTabIndexProvider.notifier).state = 2;
      case 'verified':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const VerificationScreen()));
      case 'visitors':
        ref.read(homeTabIndexProvider.notifier).state = 4;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(homeTabIndexProvider);
    final c = AppUiThemeExtension.of(context).colors;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: c.background,
      body: Column(
        children: [
          AppHeader(
            showMenu: index == 0 || index == 4,
            showBack: index != 0 && index != 4,
            onBack: index != 0 && index != 4 ? () => ref.read(homeTabIndexProvider.notifier).state = 0 : null,
          ),
          Expanded(
            child: IndexedStack(
              index: index,
              children: [
                HomeTab(onShortcut: (k) => _onShortcut(context, ref, k)),
                const SearchTab(),
                const ShortlistTab(),
                const ChatsScreen(embedded: true),
                const ProfileTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: c.surface,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, -2))],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: l10n.navHome, active: index == 0, activeColor: c.navbarActive, inactiveColor: c.navbarInactive, onTap: () => ref.read(homeTabIndexProvider.notifier).state = 0),
                _NavItem(icon: Icons.search, activeIcon: Icons.search, label: l10n.navSearch, active: index == 1, activeColor: c.navbarActive, inactiveColor: c.navbarInactive, onTap: () => ref.read(homeTabIndexProvider.notifier).state = 1),
                _NavItem(icon: Icons.favorite_border, activeIcon: Icons.favorite, label: l10n.navShortlist, active: index == 2, activeColor: c.navbarActive, inactiveColor: c.navbarInactive, onTap: () => ref.read(homeTabIndexProvider.notifier).state = 2),
                _NavItem(icon: Icons.chat_bubble_outline, activeIcon: Icons.chat_bubble, label: l10n.navChat, active: index == 3, activeColor: c.navbarActive, inactiveColor: c.navbarInactive, onTap: () => ref.read(homeTabIndexProvider.notifier).state = 3),
                _NavItem(icon: Icons.person_outline, activeIcon: Icons.person, label: l10n.navProfile, active: index == 4, activeColor: c.navbarActive, inactiveColor: c.navbarInactive, onTap: () => ref.read(homeTabIndexProvider.notifier).state = 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.active,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool active;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? activeColor : inactiveColor;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(active ? activeIcon : icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: active ? FontWeight.w600 : FontWeight.w400)),
          ],
        ),
      ),
    );
  }
}
