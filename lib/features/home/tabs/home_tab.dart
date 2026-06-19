import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getmarried/core/providers/app_providers.dart';
import 'package:getmarried/features/profile/biodata_detail_screen.dart';
import 'package:getmarried/features/profile/biodata_wizard_screen.dart';

class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<Map<String, dynamic>>(
      future: ref.read(profileRepositoryProvider).dashboard(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final data = snapshot.data ?? {};
        final completion = data['completion'] ?? 0;
        final trustBadge = data['trust_badge'] ?? 'basic';
        final user = data['user'] as Map<String, dynamic>? ?? {};
        final biodata = user['biodata'] as Map<String, dynamic>?;

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(currentUserProvider);
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('স্বাগতম, ${user['name'] ?? ''}',
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text('Profile completion: $completion%'),
                      Text('Trust badge: $trustBadge'),
                      Text('Connections: ${user['connections'] ?? 0}'),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(value: (completion as num) / 100),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const BiodataWizardScreen()),
                  );
                },
                icon: const Icon(Icons.edit),
                label: Text(biodata == null ? 'Create Biodata' : 'Edit Biodata'),
              ),
              const SizedBox(height: 16),
              Text('Top Matches', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              FutureBuilder<List<dynamic>>(
                future: ref.read(interactionRepositoryProvider).topMatches(limit: 10),
                builder: (context, matchSnap) {
                  if (!matchSnap.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final matches = matchSnap.data!;
                  if (matches.isEmpty) {
                    return const Text('No matches yet. Complete your biodata.');
                  }
                  return Column(
                    children: matches.take(5).map((m) {
                      final item = m as Map<String, dynamic>;
                      final slug = item['slug']?.toString() ?? '';
                      return ListTile(
                        title: Text(item['biodata_no']?.toString() ?? slug),
                        subtitle: Text('Score: ${item['score'] ?? item['match_score'] ?? '-'}'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: slug.isEmpty
                            ? null
                            : () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => BiodataDetailScreen(slug: slug),
                                  ),
                                ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
