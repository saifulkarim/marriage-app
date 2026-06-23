import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getmarried/core/providers/app_providers.dart';
import 'package:getmarried/features/phase3/consultant_detail_screen.dart';

class ConsultantsScreen extends ConsumerStatefulWidget {
  const ConsultantsScreen({super.key});

  @override
  ConsumerState<ConsultantsScreen> createState() => _ConsultantsScreenState();
}

class _ConsultantsScreenState extends ConsumerState<ConsultantsScreen> with SingleTickerProviderStateMixin {
  late TabController _tab;
  List<dynamic> _consultants = [];
  List<dynamic> _bookings = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final repo = ref.read(phase3RepositoryProvider);
      _consultants = await repo.consultants();
      _bookings = await repo.myBookings();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultants'),
        bottom: TabBar(controller: _tab, tabs: const [Tab(text: 'Available'), Tab(text: 'My Bookings')]),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tab,
              children: [
                ListView.builder(
                  itemCount: _consultants.length,
                  itemBuilder: (context, i) {
                    final c = _consultants[i] as Map<String, dynamic>;
                    return ListTile(
                      title: Text(c['title']?.toString() ?? c['consultant_name']?.toString() ?? ''),
                      subtitle: Text('৳ ${c['hourly_rate']} / hr • ⭐ ${c['rating'] ?? 0}'),
                      onTap: () => Navigator.push(context, MaterialPageRoute(
                        builder: (_) => ConsultantDetailScreen(id: c['id'] as int),
                      )).then((_) => _load()),
                    );
                  },
                ),
                _bookings.isEmpty
                    ? const Center(child: Text('No bookings'))
                    : ListView.builder(
                        itemCount: _bookings.length,
                        itemBuilder: (context, i) {
                          final b = _bookings[i] as Map<String, dynamic>;
                          return ListTile(
                            title: Text(b['consultant']?['title']?.toString() ?? 'Booking'),
                            subtitle: Text('${b['scheduled_at']} • ${b['status']}'),
                          );
                        },
                      ),
              ],
            ),
    );
  }
}
