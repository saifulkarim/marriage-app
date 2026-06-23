import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getmarried/core/locale/l10n_extension.dart';
import 'package:getmarried/core/locale/localized_field.dart';
import 'package:getmarried/core/providers/app_providers.dart';
import 'package:getmarried/core/theme/app_theme.dart';
import 'package:getmarried/features/matches/matches_screen.dart';
import 'package:getmarried/features/profile/biodata_detail_screen.dart';
import 'package:getmarried/features/profile/biodata_wizard_screen.dart';
import 'package:getmarried/shared/widgets/home_slider_carousel.dart';
import 'package:getmarried/shared/widgets/trust_banner.dart';
import 'package:getmarried/shared/widgets/profile_cards.dart';
import 'package:getmarried/shared/widgets/section_header.dart';

class HomeTab extends ConsumerWidget {
  const HomeTab({super.key, this.onShortcut});

  final void Function(String key)? onShortcut;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui = AppUiThemeExtension.of(context);
    final uiAsync = ref.watch(appUiConfigProvider);

    return FutureBuilder<Map<String, dynamic>>(
      future: ref.read(profileRepositoryProvider).dashboard(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: ui.colors.primary));
        }

        final data = snapshot.data ?? {};
        final completion = (data['completion'] as num?)?.toInt() ?? 0;
        final user = data['user'] as Map<String, dynamic>? ?? {};
        final biodata = user['biodata'] as Map<String, dynamic>?;
        final sliders = uiAsync.maybeWhen(data: (c) => c.sliders, orElse: () => ui.sliders);

        return RefreshIndicator(
          color: ui.colors.primary,
          onRefresh: () async {
            ref.invalidate(currentUserProvider);
            ref.invalidate(appUiConfigProvider);
          },
          child: ListView(
            children: [
              if (sliders.isNotEmpty) ...[
                const SizedBox(height: 8),
                HomeSliderCarousel(sliders: sliders),
                const SizedBox(height: 16),
              ],
              _HeroBanner(
                completion: completion,
                name: user['name']?.toString() ?? '',
                onEdit: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BiodataWizardScreen())),
                hasBiodata: biodata != null,
              ),
              const SizedBox(height: 20),
              _QuickSearchCard(onSearch: () => ref.read(homeTabIndexProvider.notifier).state = 1),
              const SizedBox(height: 20),
              FeatureShortcuts(onTap: onShortcut ?? (_) {}),
              const SizedBox(height: 24),
              SectionHeader(
                title: context.l10n.recommendedMatches,
                actionLabel: context.l10n.viewAll,
                onAction: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MatchesScreen())),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 210,
                child: FutureBuilder<List<dynamic>>(
                  future: ref.read(interactionRepositoryProvider).topMatches(limit: 10),
                  builder: (context, matchSnap) {
                    if (!matchSnap.hasData) {
                      return Center(child: CircularProgressIndicator(color: ui.colors.primary));
                    }
                    final matches = matchSnap.data!;
                    if (matches.isEmpty) {
                      return Center(child: Text(context.l10n.completeBiodataForMatches, style: TextStyle(color: ui.colors.textMuted)));
                    }
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: matches.length,
                      itemBuilder: (context, i) {
                        final item = matches[i] as Map<String, dynamic>;
                        final slug = item['slug']?.toString() ?? '';
                        return ProfileCardHorizontal(
                          item: item,
                          onTap: slug.isEmpty ? () {} : () => Navigator.push(context, MaterialPageRoute(builder: (_) => BiodataDetailScreen(slug: slug))),
                          onShortlist: slug.isEmpty
                              ? null
                              : () => ref.read(interactionRepositoryProvider).addShortlist(slug),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              const TrustBanner(),
              const SizedBox(height: 24),
              SectionHeader(title: context.l10n.successStories),
              const SizedBox(height: 12),
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _StoryCard(text: context.l10n.story1),
                    _StoryCard(text: context.l10n.story2),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({
    required this.completion,
    required this.name,
    required this.onEdit,
    required this.hasBiodata,
  });

  final int completion;
  final String name;
  final VoidCallback onEdit;
  final bool hasBiodata;

  @override
  Widget build(BuildContext context) {
    final ui = AppUiThemeExtension.of(context);
    final hero = ui.hero;
    final c = ui.colors;
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context);
    final cmsTitle = LocalizedField.pick(hero.title, hero.titleBn, locale);
    final cmsSubtitle = LocalizedField.pick(hero.subtitle, hero.subtitleBn, locale);
    final cmsButton = LocalizedField.pick(hero.buttonText, hero.buttonTextBn, locale);
    final heroTitle = name.isNotEmpty ? l10n.assalamuAlaikumName(name) : (cmsTitle.isNotEmpty ? cmsTitle : l10n.findLifePartner);
    final heroSubtitle = cmsSubtitle.isNotEmpty ? cmsSubtitle : l10n.trustedSubtitle;
    final buttonBase = hasBiodata
        ? (cmsButton.isNotEmpty ? cmsButton : l10n.editBiodata)
        : (cmsButton.isNotEmpty ? cmsButton : l10n.createBiodata);
    final buttonLabel = hasBiodata ? '$buttonBase ($completion%)' : buttonBase;

    Widget heroVisual;
    if (hero.showImage && hero.imageUrl != null && hero.imageUrl!.isNotEmpty) {
      heroVisual = ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(hero.imageUrl!, width: 100, height: 120, fit: BoxFit.cover, errorBuilder: (_, _, _) => _heroIcon(c.primary)),
      );
    } else {
      heroVisual = _heroIcon(c.primary);
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: hero.backgroundColor ?? c.primarySoft,
        borderRadius: BorderRadius.circular(20),
        image: hero.showImage && hero.imageUrl != null && hero.imageUrl!.isNotEmpty
            ? DecorationImage(image: NetworkImage(hero.imageUrl!), fit: BoxFit.cover, colorFilter: ColorFilter.mode(Colors.white.withValues(alpha: 0.82), BlendMode.srcOver))
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(heroTitle, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: c.primaryDark, height: 1.3)),
                const SizedBox(height: 6),
                Text(heroSubtitle, style: TextStyle(fontSize: 12, color: c.textSecondary, height: 1.4)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (hero.stat1Label != null) _StatChip(icon: Icons.people, label: hero.stat1Label!, color: c.primary),
                    const SizedBox(width: 8),
                    if (hero.stat2Label != null) _StatChip(icon: Icons.favorite, label: hero.stat2Label!, color: c.primary),
                  ],
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: onEdit,
                  style: OutlinedButton.styleFrom(backgroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
                  child: Text(buttonLabel),
                ),
              ],
            ),
          ),
          if (!(hero.showImage && hero.imageUrl != null && hero.imageUrl!.isNotEmpty)) heroVisual,
        ],
      ),
    );
  }

  Widget _heroIcon(Color color) {
    return Container(
      width: 90,
      height: 110,
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16)),
      child: Icon(Icons.favorite, size: 48, color: color),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.icon, required this.label, required this.color});
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.7), borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _QuickSearchCard extends StatelessWidget {
  const _QuickSearchCard({required this.onSearch});
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    final c = AppUiThemeExtension.of(context).colors;
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: c.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(l10n.quickSearch, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                const Spacer(),
                TextButton(
                  onPressed: onSearch,
                  child: Text('${l10n.advancedSearch} >', style: const TextStyle(fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _FilterBox(label: l10n.bride, selected: true)),
                const SizedBox(width: 8),
                Expanded(child: _FilterBox(label: l10n.groom, selected: false)),
              ],
            ),
            const SizedBox(height: 10),
            const _FilterBox(label: 'Age: 22 - 30', selected: false, fullWidth: true),
            const SizedBox(height: 10),
            const _FilterBox(label: 'Dhaka', selected: false, fullWidth: true, icon: Icons.location_on_outlined),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onSearch,
                icon: const Icon(Icons.search, size: 20),
                label: Text(l10n.findMatches),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterBox extends StatelessWidget {
  const _FilterBox({required this.label, required this.selected, this.fullWidth = false, this.icon});

  final String label;
  final bool selected;
  final bool fullWidth;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final c = AppUiThemeExtension.of(context).colors;
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: selected ? c.primary : c.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: selected ? c.primary : c.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[Icon(icon, size: 16, color: selected ? Colors.white : c.textMuted), const SizedBox(width: 6)],
          Text(label, style: TextStyle(fontSize: 12, color: selected ? Colors.white : c.textSecondary, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _StoryCard extends StatelessWidget {
  const _StoryCard({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final c = AppUiThemeExtension.of(context).colors;
    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.border),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: c.primaryLight, borderRadius: BorderRadius.circular(12)),
            child: Icon(Icons.favorite, color: c.primary),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: TextStyle(fontSize: 11, color: c.textSecondary, height: 1.4))),
        ],
      ),
    );
  }
}
