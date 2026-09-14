import 'package:flutter/material.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/theme.dart';
import '../register/data/covermint_repository.dart';

class RenewalsTab extends StatefulWidget {
  final CovermintRepository repository;

  const RenewalsTab({super.key, required this.repository});

  @override
  State<RenewalsTab> createState() => _RenewalsTabState();
}

class _RenewalsTabState extends State<RenewalsTab>
    with AutomaticKeepAliveClientMixin {
  late Future<Map<String, dynamic>> _future;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _future = widget.repository.getRenewals();
  }

  Future<void> _refresh() async {
    final next = widget.repository.getRenewals();
    setState(() => _future = next);
    try {
      await next;
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Renewals'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: CovermintTheme.heroGradient),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: _refresh,
            child: FutureBuilder<Map<String, dynamic>>(
              future: _future,
              builder: (context, snap) {
                if (snap.connectionState != ConnectionState.done) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }
                if (snap.hasError) {
                  final e = snap.error!;
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    children: [
                      Text(e is ApiException ? e.message : e.toString(),
                          style: const TextStyle(color: Colors.white)),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _refresh,
                        child: const Text('Retry'),
                      ),
                    ],
                  );
                }
                final buckets = snap.data!['buckets'];
                final map = buckets is Map
                    ? Map<String, dynamic>.from(buckets)
                    : const {'d30': 0, 'd60': 0, 'd90': 0};
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  children: [
                    _buildBucketCard('30 Days', '${map['d30'] ?? 0}',
                        CovermintTheme.rejectedRed, Icons.warning_amber),
                    const SizedBox(height: 12),
                    _buildBucketCard('60 Days', '${map['d60'] ?? 0}',
                        CovermintTheme.pendingAmber, Icons.schedule),
                    const SizedBox(height: 12),
                    _buildBucketCard('90 Days', '${map['d90'] ?? 0}',
                        CovermintTheme.approvedGreen, Icons.check_circle),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.inbox_outlined,
                              color: Colors.white70, size: 48),
                          SizedBox(height: 12),
                          Text(
                            'No renewal data found',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBucketCard(
      String label, String count, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          Text(
            count,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
