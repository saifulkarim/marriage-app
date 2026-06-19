import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getmarried/core/providers/app_providers.dart';
import 'package:getmarried/features/billing/billing_screen.dart';
import 'package:getmarried/features/profile/biodata_wizard_screen.dart';

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (user) {
        final biodata = user['biodata'] as Map<String, dynamic>?;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(user['name']?.toString() ?? ''),
              subtitle: Text(user['email']?.toString() ?? user['contact']?.toString() ?? ''),
            ),
            const Divider(),
            ListTile(
              title: const Text('Profile Completion'),
              trailing: Text('${user['profile_completion'] ?? 0}%'),
            ),
            ListTile(
              title: const Text('Connections'),
              trailing: Text('${user['connections'] ?? 0}'),
            ),
            ListTile(
              title: const Text('Subscription'),
              trailing: Text(user['subscription_plan']?.toString() ?? 'free'),
            ),
            if (biodata != null) ...[
              const Divider(),
              ListTile(title: const Text('Biodata No'), trailing: Text(biodata['biodata_no']?.toString() ?? '-')),
              ListTile(title: const Text('Status'), trailing: Text(_statusLabel(biodata['status']))),
            ],
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const BiodataWizardScreen()),
              ),
              icon: const Icon(Icons.edit),
              label: const Text('Edit Biodata'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const BillingScreen()),
              ),
              icon: const Icon(Icons.payment),
              label: const Text('Credits & Subscription'),
            ),
          ],
        );
      },
    );
  }

  String _statusLabel(dynamic status) {
    return switch (status) {
      1 => 'Approved',
      2 => 'Blocked',
      _ => 'Pending',
    };
  }
}
