import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getmarried/core/locale/l10n_extension.dart';
import 'package:getmarried/core/providers/app_providers.dart';
import 'package:getmarried/core/theme/app_colors.dart';
import 'package:getmarried/features/auth/change_password_screen.dart';
import 'package:getmarried/features/billing/billing_screen.dart';
import 'package:getmarried/features/more/more_menu_screen.dart';
import 'package:getmarried/features/profile/biodata_wizard_screen.dart';
import 'package:getmarried/features/profile/pdf_download_helper.dart';
import 'package:getmarried/features/profile/preferences_screen.dart';
import 'package:getmarried/shared/widgets/language_toggle.dart';

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
      loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
      error: (e, _) => Center(child: Text(context.l10n.errorPrefix('$e'))),
      data: (user) {
        final l10n = context.l10n;
        final biodata = user['biodata'] as Map<String, dynamic>?;
        final completion = (user['profile_completion'] as num?)?.toInt() ?? 0;
        final plan = user['subscription_plan']?.toString() ?? 'free';
        final isPremium = plan != 'free';

        return ListView(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.gradientStart, AppColors.gradientEnd]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: AppColors.primaryLight,
                        backgroundImage: biodata?['image'] != null ? NetworkImage(biodata!['image'].toString()) : null,
                        child: biodata?['image'] == null ? const Icon(Icons.person, size: 40, color: AppColors.primary) : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BiodataWizardScreen())),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                            child: const Icon(Icons.edit, size: 14, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.assalamuAlaikum, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                user['name']?.toString() ?? '',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                              ),
                            ),
                            const Icon(Icons.verified, color: AppColors.success, size: 18),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(l10n.profileStrength(completion), style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: completion / 100,
                            minHeight: 6,
                            backgroundColor: Colors.white,
                            color: AppColors.primary,
                          ),
                        ),
                        if (biodata != null) ...[
                          const SizedBox(height: 6),
                          Text(l10n.profileId(biodata['biodata_no'].toString()), style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (isPremium)
              Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4E5),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFFFD699)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.workspace_premium, color: AppColors.premium),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.premiumMember, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                          Text(l10n.planLabel(plan), style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BillingScreen())),
                      child: Text(l10n.manage),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _StatBox(icon: Icons.favorite, label: l10n.connections, value: '${user['connections'] ?? 0}'),
                  const SizedBox(width: 10),
                  _StatBox(icon: Icons.visibility, label: l10n.views, value: '${biodata?['views'] ?? 0}'),
                  const SizedBox(width: 10),
                  _StatBox(icon: Icons.bookmark, label: l10n.shortlists, value: '—'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: LanguageSettingsTile(),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(l10n.quickActions, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 90,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _ActionCard(Icons.edit, l10n.editProfile, const Color(0xFF8B5CF6), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BiodataWizardScreen()))),
                  _ActionCard(Icons.tune, l10n.preferences, const Color(0xFFF59E0B), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PreferencesScreen()))),
                  _ActionCard(Icons.payment, l10n.premium, AppColors.primary, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BillingScreen()))),
                  _ActionCard(Icons.lock, l10n.password, AppColors.info, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChangePasswordScreen()))),
                  _ActionCard(Icons.apps, l10n.more, const Color(0xFF14B8A6), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MoreMenuScreen()))),
                ],
              ),
            ),
            if (biodata?['slug'] != null) ...[
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: OutlinedButton.icon(
                  onPressed: () => downloadAndOpenBiodataPdf(ref: ref, context: context, slug: biodata!['slug'].toString()),
                  icon: const Icon(Icons.picture_as_pdf),
                  label: Text(l10n.downloadBiodataPdf),
                ),
              ),
            ],
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.shield_outlined, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.privacyPriority,
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard(this.icon, this.label, this.color, this.onTap);
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
