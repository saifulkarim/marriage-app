import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getmarried/core/api/api_client.dart';
import 'package:getmarried/core/locale/l10n_extension.dart';
import 'package:getmarried/core/providers/app_providers.dart';
import 'package:getmarried/core/theme/app_colors.dart';
import 'package:getmarried/features/billing/billing_screen.dart';
import 'package:getmarried/features/profile/biodata_detail_screen.dart';
import 'package:getmarried/shared/widgets/profile_cards.dart';
import 'package:getmarried/shared/widgets/trust_banner.dart';

class MatchesScreen extends ConsumerStatefulWidget {
  const MatchesScreen({super.key});

  @override
  ConsumerState<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends ConsumerState<MatchesScreen> with SingleTickerProviderStateMixin {
  late TabController _tab;
  List<dynamic> _results = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
    _load();
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final results = await ref.read(interactionRepositoryProvider).search(filters: {'per_page': 30});
      setState(() => _results = results);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _openDetail(String slug) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => BiodataDetailScreen(slug: slug)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.matchesForYou),
        actions: [
          PopupMenuButton<String>(
            initialValue: 'relevant',
            onSelected: (_) {},
            itemBuilder: (_) => [PopupMenuItem(value: 'relevant', child: Text(l10n.mostRelevant))],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Text(l10n.mostRelevant, style: const TextStyle(fontSize: 13)),
                  const Icon(Icons.keyboard_arrow_down),
                ],
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tab,
          isScrollable: true,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textMuted,
          indicatorColor: AppColors.primary,
          tabs: [
            Tab(text: l10n.allMatches(_results.length)),
            Tab(text: l10n.recentlyActive),
            Tab(text: l10n.newMembers),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : Column(
              children: [
                const SizedBox(height: 8),
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [l10n.age, l10n.religion, l10n.location, l10n.education, l10n.moreFilters]
                        .map((f) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(f, style: const TextStyle(fontSize: 12)),
                                onSelected: (_) {},
                                backgroundColor: AppColors.surface,
                                side: const BorderSide(color: AppColors.border),
                              ),
                            ))
                        .toList(),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tab,
                    children: [
                      _buildList(_results),
                      _buildList(_results),
                      _buildList(_results),
                    ],
                  ),
                ),
                const TrustBanner(compact: true),
                const SizedBox(height: 8),
                _PremiumBanner(
                  onUpgrade: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BillingScreen())),
                ),
                const SizedBox(height: 8),
              ],
            ),
    );
  }

  Widget _buildList(List<dynamic> items) {
    if (items.isEmpty) return Center(child: Text(context.l10n.noMatchesFound));
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _load,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 16),
        itemCount: items.length,
        itemBuilder: (context, i) {
          final item = items[i] as Map<String, dynamic>;
          final slug = item['slug']?.toString() ?? '';
          return ProfileCardList(
            item: item,
            onTap: slug.isEmpty ? () {} : () => _openDetail(slug),
            onShortlist: slug.isEmpty
                ? null
                : () async {
                    try {
                      await ref.read(interactionRepositoryProvider).addShortlist(slug);
                      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.shortlisted)));
                    } on ApiException catch (e) {
                      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
                    }
                  },
            onViewProfile: slug.isEmpty ? null : () => _openDetail(slug),
          );
        },
      ),
    );
  }
}

class _PremiumBanner extends StatelessWidget {
  const _PremiumBanner({required this.onUpgrade});
  final VoidCallback onUpgrade;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.workspace_premium, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.getBetterMatches, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                Text(l10n.premiumResponses, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ),
          FilledButton(onPressed: onUpgrade, style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 14)), child: Text(l10n.upgrade)),
        ],
      ),
    );
  }
}
