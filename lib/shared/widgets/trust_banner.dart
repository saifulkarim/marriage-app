import 'package:flutter/material.dart';
import 'package:getmarried/core/locale/l10n_extension.dart';
import 'package:getmarried/core/models/app_ui_config.dart';
import 'package:getmarried/core/theme/app_theme.dart';

class TrustBanner extends StatelessWidget {
  const TrustBanner({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final ui = AppUiThemeExtension.of(context);
    final c = ui.colors;
    final l10n = context.l10n;
    final text = ui.trustBannerText ?? l10n.privacyPriority;

    if (compact) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: c.primarySoft, borderRadius: BorderRadius.circular(14)),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: c.primary.withValues(alpha: 0.15), shape: BoxShape.circle),
              child: Icon(Icons.shield_outlined, color: c.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(text, style: TextStyle(fontSize: 12, color: c.textSecondary, height: 1.4))),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: _TrustItem(icon: Icons.shield_outlined, title: l10n.secureTitle, subtitle: l10n.secureSubtitle, colors: c)),
          const SizedBox(width: 8),
          Expanded(child: _TrustItem(icon: Icons.verified_outlined, title: l10n.verifiedTitle, subtitle: l10n.verifiedSubtitle, colors: c)),
          const SizedBox(width: 8),
          Expanded(child: _TrustItem(icon: Icons.favorite_outline, title: l10n.genuineTitle, subtitle: l10n.genuineSubtitle, colors: c)),
        ],
      ),
    );
  }
}

class _TrustItem extends StatelessWidget {
  const _TrustItem({required this.icon, required this.title, required this.subtitle, required this.colors});
  final IconData icon;
  final String title;
  final String subtitle;
  final AppUiColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: colors.primary, size: 22),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
          Text(subtitle, textAlign: TextAlign.center, style: TextStyle(fontSize: 9, color: colors.textMuted)),
        ],
      ),
    );
  }
}

class FeatureShortcuts extends StatelessWidget {
  const FeatureShortcuts({super.key, required this.onTap});

  final void Function(String key) onTap;

  @override
  Widget build(BuildContext context) {
    final c = AppUiThemeExtension.of(context).colors;
    final l10n = context.l10n;
    final apiShortcuts = AppUiThemeExtension.of(context).config.shortcuts;
    final items = apiShortcuts.isNotEmpty
        ? apiShortcuts.map((s) => _Item(s.label, _iconFromName(s.icon), _colorFromHex(s.color, c.primary), s.key)).toList()
        : [
            _Item(l10n.shortcutMatches, Icons.favorite, c.primary, 'matches'),
            _Item(l10n.shortcutPremium, Icons.workspace_premium, const Color(0xFFFFB020), 'premium'),
            _Item(l10n.shortcutVisitors, Icons.people_outline, const Color(0xFF8B5CF6), 'visitors'),
            _Item(l10n.shortcutShortlist, Icons.bookmark_border, const Color(0xFF14B8A6), 'shortlist'),
            _Item(l10n.shortcutVerified, Icons.verified_user_outlined, const Color(0xFF3B82F6), 'verified'),
          ];

    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final item = items[i];
          return GestureDetector(
            onTap: () => onTap(item.key),
            child: Container(
              width: 72,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: c.border),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item.icon, color: item.color, size: 24),
                  const SizedBox(height: 6),
                  Text(item.label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Item {
  const _Item(this.label, this.icon, this.color, this.key);
  final String label;
  final IconData icon;
  final Color color;
  final String key;
}

IconData _iconFromName(String? name) {
  return switch (name) {
    'workspace_premium' => Icons.workspace_premium,
    'people_outline' => Icons.people_outline,
    'bookmark_border' => Icons.bookmark_border,
    'verified_user' => Icons.verified_user_outlined,
    _ => Icons.favorite,
  };
}

Color _colorFromHex(String? hex, Color fallback) {
  if (hex == null || hex.isEmpty) return fallback;
  var value = hex.replaceFirst('#', '');
  if (value.length == 6) value = 'FF$value';
  if (value.length != 8) return fallback;
  return Color(int.parse(value, radix: 16));
}
