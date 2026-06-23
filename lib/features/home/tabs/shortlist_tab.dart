import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getmarried/core/locale/l10n_extension.dart';
import 'package:getmarried/core/providers/app_providers.dart';
import 'package:getmarried/core/theme/app_colors.dart';
import 'package:getmarried/features/profile/biodata_detail_screen.dart';
import 'package:getmarried/shared/widgets/profile_cards.dart';

class ShortlistTab extends ConsumerStatefulWidget {
  const ShortlistTab({super.key});

  @override
  ConsumerState<ShortlistTab> createState() => _ShortlistTabState();
}

class _ShortlistTabState extends ConsumerState<ShortlistTab> {
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
      final items = await ref.read(interactionRepositoryProvider).shortlist();
      setState(() => _items = items);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }
    if (_items.isEmpty) {
      final l10n = context.l10n;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 64, color: AppColors.primary.withValues(alpha: 0.4)),
            const SizedBox(height: 16),
            Text(l10n.shortlistEmpty, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(l10n.saveProfilesYouLike, style: const TextStyle(color: AppColors.textMuted)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _load,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 16),
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index] as Map<String, dynamic>;
          final slug = item['slug']?.toString() ?? '';
          return ProfileCardList(
            item: item,
            onTap: slug.isEmpty ? () {} : () => Navigator.push(context, MaterialPageRoute(builder: (_) => BiodataDetailScreen(slug: slug))),
            onViewProfile: slug.isEmpty ? null : () => Navigator.push(context, MaterialPageRoute(builder: (_) => BiodataDetailScreen(slug: slug))),
          );
        },
      ),
    );
  }
}
