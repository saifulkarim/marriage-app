import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getmarried/core/api/api_client.dart';
import 'package:getmarried/core/locale/l10n_extension.dart';
import 'package:getmarried/core/providers/app_providers.dart';
import 'package:getmarried/core/theme/app_colors.dart';
import 'package:getmarried/core/utils/biodata_helpers.dart';
import 'package:getmarried/features/billing/billing_screen.dart';
import 'package:getmarried/features/profile/pdf_download_helper.dart';
import 'package:getmarried/shared/widgets/app_logo.dart';

class BiodataDetailScreen extends ConsumerStatefulWidget {
  const BiodataDetailScreen({super.key, required this.slug});

  final String slug;

  @override
  ConsumerState<BiodataDetailScreen> createState() => _BiodataDetailScreenState();
}

class _BiodataDetailScreenState extends ConsumerState<BiodataDetailScreen> {
  Map<String, dynamic>? _data;
  bool _loading = true;
  bool _actionLoading = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final data = await ref.read(profileRepositoryProvider).biodataDetail(widget.slug);
      setState(() => _data = data);
    } on ApiException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _action(Future<void> Function() fn, String success) async {
    setState(() => _actionLoading = true);
    try {
      await fn();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(success)));
    } on ApiException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _actionLoading = false);
    }
  }

  Future<void> _viewContact() async {
    setState(() => _actionLoading = true);
    try {
      final contact = await ref.read(profileRepositoryProvider).viewContact(widget.slug);
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Contact Info'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (contact['name'] != null) Text('Name: ${contact['name']}'),
              if (contact['contact_no'] != null) Text('Phone: ${contact['contact_no']}'),
              if (contact['email'] != null) Text('Email: ${contact['email']}'),
              if (contact['gurdians_mobile_no'] != null) Text('Guardian: ${contact['gurdians_mobile_no']}'),
            ],
          ),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close'))],
        ),
      );
    } on ApiException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _actionLoading = false);
    }
  }

  Future<void> _requestMeeting() async {
    final dateController = TextEditingController();
    int meetingType = 1;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Request Meeting'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<int>(
              value: meetingType,
              items: const [
                DropdownMenuItem(value: 1, child: Text('In Person')),
                DropdownMenuItem(value: 2, child: Text('Video Call')),
              ],
              onChanged: (v) => meetingType = v ?? 1,
              decoration: const InputDecoration(labelText: 'Type', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(
                labelText: 'Proposed Date (YYYY-MM-DD)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Send')),
        ],
      ),
    );
    if (ok != true || dateController.text.trim().isEmpty) return;
    await _action(
      () => ref.read(meetingRepositoryProvider).request(
            widget.slug,
            type: meetingType,
            date: dateController.text.trim(),
          ),
      'Meeting request sent',
    );
  }

  Future<void> _requestPhotoAccess() async {
    await _action(
      () => ref.read(photoAccessRepositoryProvider).request(widget.slug),
      'Photo access requested',
    );
  }

  Future<void> _reportComplaint() async {
    final contactController = TextEditingController();
    final detailsController = TextEditingController();
    int reason = 1;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Report Biodata'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int>(
                value: reason,
                items: const [
                  DropdownMenuItem(value: 1, child: Text('Fake Profile')),
                  DropdownMenuItem(value: 2, child: Text('Harassment')),
                  DropdownMenuItem(value: 3, child: Text('Other')),
                ],
                onChanged: (v) => reason = v ?? 1,
                decoration: const InputDecoration(labelText: 'Reason', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: contactController,
                decoration: const InputDecoration(labelText: 'Your Contact', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: detailsController,
                decoration: const InputDecoration(labelText: 'Details', border: OutlineInputBorder()),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Submit')),
        ],
      ),
    );
    if (ok != true || contactController.text.trim().isEmpty) return;
    await _action(
      () => ref.read(complaintRepositoryProvider).create(
            biodataSlug: widget.slug,
            reason: reason,
            contactNo: contactController.text.trim(),
            details: detailsController.text.trim().isEmpty ? null : detailsController.text.trim(),
          ),
      'Report submitted',
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    final biodata = _data?['biodata'] as Map<String, dynamic>? ?? {};
    final answers = _data?['answers'] as List? ?? [];
    final image = biodata['image']?.toString();
    final title = biodataTitle(biodata, fallback: context.l10n.profileLabel);
    final age = biodataAge(biodata['birth_date']?.toString());
    final location = biodataLocation(biodata, Localizations.localeOf(context));

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const AppLogo(size: 16, showTagline: false),
          actions: [
            IconButton(icon: const Icon(Icons.share_outlined), onPressed: () {}),
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'contact':
                    _viewContact();
                  case 'meeting':
                    _requestMeeting();
                  case 'photo':
                    _requestPhotoAccess();
                  case 'pdf':
                    downloadAndOpenBiodataPdf(ref: ref, context: context, slug: widget.slug);
                  case 'report':
                    _reportComplaint();
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'contact', child: Text('View Contact')),
                PopupMenuItem(value: 'meeting', child: Text('Request Meeting')),
                PopupMenuItem(value: 'photo', child: Text('Request Photo Access')),
                PopupMenuItem(value: 'pdf', child: Text('Download PDF')),
                PopupMenuItem(value: 'report', child: Text('Report')),
              ],
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textMuted,
            indicatorColor: AppColors.primary,
            tabs: [
              Tab(text: 'About'),
              Tab(text: 'Basic Info'),
              Tab(text: 'Details'),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, -2))],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _actionLoading ? null : () => Navigator.pop(context),
                          child: const Icon(Icons.close, color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: FilledButton.icon(
                          onPressed: _actionLoading
                              ? null
                              : () => _action(
                                    () => ref.read(interactionRepositoryProvider).addShortlist(widget.slug),
                                    'Shortlisted',
                                  ),
                          icon: const Icon(Icons.favorite_border, size: 18),
                          label: const Text('Shortlist'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: FilledButton.icon(
                          onPressed: _actionLoading
                              ? null
                              : () => _action(
                                    () => ref.read(interactionRepositoryProvider).sendInterest(widget.slug),
                                    'Interest sent',
                                  ),
                          icon: const Icon(Icons.chat_bubble_outline, size: 18),
                          label: const Text('Interest'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text('100% Secure • Your privacy is our priority', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _aboutTab(biodata, image, title, age, location),
            _basicTab(biodata),
            _detailsTab(answers),
          ],
        ),
      ),
    );
  }

  Widget _aboutTab(Map<String, dynamic> biodata, String? image, String title, String? age, String location) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: image != null && image.isNotEmpty
              ? Image.network(image, height: 260, width: double.infinity, fit: BoxFit.cover, errorBuilder: (_, _, _) => _imagePlaceholder())
              : _imagePlaceholder(),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            ),
            const Icon(Icons.verified, color: AppColors.success),
          ],
        ),
        if (age != null || location.isNotEmpty)
          Text('${age ?? ''}${age != null && location.isNotEmpty ? ' • ' : ''}$location', style: const TextStyle(color: AppColors.textSecondary)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(12)),
          child: const Row(
            children: [
              Icon(Icons.shield_outlined, color: AppColors.primary),
              SizedBox(width: 10),
              Expanded(child: Text('Verified Profile: Phone & Email Verified', style: TextStyle(fontSize: 12))),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _quickAction(Icons.favorite_border, 'Shortlist', () => _action(() => ref.read(interactionRepositoryProvider).addShortlist(widget.slug), 'Shortlisted')),
            _quickAction(Icons.chat_bubble_outline, 'Message', () {}),
            _quickAction(Icons.visibility_outlined, 'View Contact', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BillingScreen()))),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(14)),
          child: Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Contact Details are Hidden', style: TextStyle(fontWeight: FontWeight.w700)),
                    Text('Unlock to view phone number & email', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              FilledButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BillingScreen())),
                child: const Text('Unlock'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _basicTab(Map<String, dynamic> biodata) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _infoCard(Icons.cake_outlined, 'Birth Date', biodata['birth_date']),
        _infoCard(Icons.height, 'Height', biodataHeight(biodata)),
        _infoCard(Icons.monitor_weight_outlined, 'Weight', biodata['weight']),
        _infoCard(Icons.palette_outlined, 'Skin Tone', biodata['skin_tone']),
        _infoCard(Icons.bloodtype_outlined, 'Blood Group', biodata['blood_group']),
        _infoCard(Icons.location_on_outlined, 'District', biodata['permenant_address']),
      ],
    );
  }

  Widget _detailsTab(List answers) {
    if (answers.isEmpty) return const Center(child: Text('No additional details'));
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: answers.length,
      itemBuilder: (context, i) {
        final item = answers[i] as Map<String, dynamic>;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item['question']?.toString() ?? item['question_bn']?.toString() ?? '', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 4),
              Text(item['answer']?.toString() ?? '', style: const TextStyle(color: AppColors.textSecondary)),
            ],
          ),
        );
      },
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      height: 260,
      color: AppColors.primaryLight,
      child: const Center(child: Icon(Icons.person, size: 80, color: AppColors.primary)),
    );
  }

  Widget _infoCard(IconData icon, String label, dynamic value) {
    if (value == null || value.toString().isEmpty) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 12))),
          Text(value.toString(), style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _quickAction(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }
}
