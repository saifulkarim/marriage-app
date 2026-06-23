import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getmarried/core/api/api_client.dart';
import 'package:getmarried/core/locale/l10n_extension.dart';
import 'package:getmarried/core/providers/app_providers.dart';
import 'package:getmarried/core/theme/app_colors.dart';
import 'package:getmarried/features/profile/biodata_detail_screen.dart';
import 'package:getmarried/shared/widgets/profile_cards.dart';
import 'package:getmarried/shared/widgets/section_header.dart';
import 'package:getmarried/shared/widgets/trust_banner.dart';

class SearchTab extends ConsumerStatefulWidget {
  const SearchTab({super.key});

  @override
  ConsumerState<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends ConsumerState<SearchTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> _results = [];
  bool _loading = false;
  String? _error;
  final _biodataNoController = TextEditingController();
  int _lookingFor = 1; // 1 bride, 2 groom

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _search();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _biodataNoController.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await ref.read(interactionRepositoryProvider).search(
        filters: {'per_page': 20, if (_lookingFor > 0) 'biodata_type_id': _lookingFor},
      );
      setState(() => _results = results);
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _searchByNumber() async {
    final no = _biodataNoController.text.trim();
    if (no.isEmpty) return;
    try {
      final biodata = await ref.read(profileRepositoryProvider).searchByNumber(no);
      final slug = biodata['slug']?.toString();
      if (slug != null && mounted) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => BiodataDetailScreen(slug: slug)));
      }
    } on ApiException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  void _openDetail(String slug) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => BiodataDetailScreen(slug: slug)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textMuted,
          indicatorColor: AppColors.primary,
          tabs: [Tab(text: l10n.basicSearch), Tab(text: l10n.advancedSearch)],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildSearchForm(advanced: false),
              _buildSearchForm(advanced: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchForm({required bool advanced}) {
    final l10n = context.l10n;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _biodataNoController,
                decoration: InputDecoration(
                  hintText: l10n.searchByBiodataNo,
                  prefixIcon: const Icon(Icons.tag),
                ),
              ),
            ),
            const SizedBox(width: 8),
            FilledButton(onPressed: _searchByNumber, child: Text(l10n.go)),
          ],
        ),
        const SizedBox(height: 16),
        _FilterRow(
          icon: Icons.person_outline,
          child: Row(
            children: [
              Expanded(child: _ToggleChip(label: l10n.bride, selected: _lookingFor == 1, onTap: () => setState(() => _lookingFor = 1))),
              const SizedBox(width: 8),
              Expanded(child: _ToggleChip(label: l10n.groom, selected: _lookingFor == 2, onTap: () => setState(() => _lookingFor = 2))),
            ],
          ),
        ),
        _FilterRow(icon: Icons.cake_outlined, child: _DropdownField(label: 'Age: 22 - 30')),
        _FilterRow(icon: Icons.mosque_outlined, child: _DropdownField(label: 'Religion: Islam')),
        if (advanced) ...[
          _FilterRow(icon: Icons.school_outlined, child: _DropdownField(label: 'Education')),
          _FilterRow(icon: Icons.work_outline, child: _DropdownField(label: 'Profession')),
          _FilterRow(icon: Icons.height, child: _DropdownField(label: "Height: 5'0\" - 5'8\"")),
        ],
        _FilterRow(icon: Icons.location_on_outlined, child: _DropdownField(label: 'Location: Dhaka')),
        const SizedBox(height: 16),
        Row(
          children: [
            TextButton(onPressed: () => setState(() => _lookingFor = 1), child: Text(l10n.clearAll)),
            const Spacer(),
            TextButton(onPressed: () {}, child: Text(advanced ? l10n.lessFilters : l10n.moreFilters)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: FilledButton.icon(
                onPressed: _loading ? null : _search,
                icon: _loading
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.search),
                label: Text(l10n.showMatches(_results.length)),
              ),
            ),
            const SizedBox(width: 10),
            OutlinedButton.icon(onPressed: _search, icon: const Icon(Icons.tune, size: 18), label: Text(l10n.reset)),
          ],
        ),
        const SizedBox(height: 24),
        SectionHeader(title: l10n.topMatchesForYou),
        const SizedBox(height: 8),
        if (_error != null)
          Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
        else if (_loading)
          const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator(color: AppColors.primary)))
        else if (_results.isEmpty)
          Center(child: Text(l10n.noBiodataFound, style: const TextStyle(color: AppColors.textMuted)))
        else
          ..._results.take(5).map((r) {
            final item = r as Map<String, dynamic>;
            final slug = item['slug']?.toString() ?? '';
            return ProfileCardList(
              item: item,
              onTap: slug.isEmpty ? () {} : () => _openDetail(slug),
              onShortlist: slug.isEmpty ? null : () => ref.read(interactionRepositoryProvider).addShortlist(slug),
              onViewProfile: slug.isEmpty ? null : () => _openDetail(slug),
            );
          }),
        const SizedBox(height: 16),
        const TrustBanner(compact: true),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({required this.icon, required this.child});
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(width: 12),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _ToggleChip extends StatelessWidget {
  const _ToggleChip({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? AppColors.primary : AppColors.border),
        ),
        child: Center(
          child: Text(label, style: TextStyle(color: selected ? Colors.white : AppColors.textSecondary, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
          const Icon(Icons.keyboard_arrow_down, color: AppColors.textMuted),
        ],
      ),
    );
  }
}
