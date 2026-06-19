import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getmarried/core/providers/app_providers.dart';
import 'package:getmarried/features/auth/login_screen.dart';
import 'package:getmarried/features/billing/billing_screen.dart';
import 'package:getmarried/features/home/tabs/home_tab.dart';
import 'package:getmarried/features/home/tabs/interests_tab.dart';
import 'package:getmarried/features/home/tabs/profile_tab.dart';
import 'package:getmarried/features/home/tabs/search_tab.dart';
import 'package:getmarried/features/home/tabs/shortlist_tab.dart';

class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  int _index = 0;

  static const _tabs = [
    HomeTab(),
    SearchTab(),
    InterestsTab(),
    ShortlistTab(),
    ProfileTab(),
  ];

  Future<void> _logout() async {
    await ref.read(authRepositoryProvider).logout();
    ref.invalidate(sessionProvider);
    ref.invalidate(currentUserProvider);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GetMarried'),
        actions: [
          IconButton(
            icon: const Icon(Icons.payment),
            tooltip: 'Billing',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const BillingScreen()),
            ),
          ),
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: _tabs[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.favorite_border), selectedIcon: Icon(Icons.favorite), label: 'Interest'),
          NavigationDestination(icon: Icon(Icons.bookmark_border), selectedIcon: Icon(Icons.bookmark), label: 'Shortlist'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
