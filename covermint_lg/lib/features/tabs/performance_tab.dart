import 'package:flutter/material.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/theme.dart';
import '../register/data/covermint_repository.dart';

class PerformanceTab extends StatefulWidget {
  final CovermintRepository repository;

  const PerformanceTab({super.key, required this.repository});

  @override
  State<PerformanceTab> createState() => _PerformanceTabState();
}

class _PerformanceTabState extends State<PerformanceTab>
    with AutomaticKeepAliveClientMixin {
  late Future<Map<String, dynamic>> _future;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _future = widget.repository.getPerformance();
  }

  Future<void> _refresh() async {
    final next = widget.repository.getPerformance();
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
        title: const Text('Performance'),
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
                final d = snap.data!;
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  children: [
                    _buildKpiCard(
                      'Leads Generated',
                      '${d['leads_generated'] ?? 0}',
                      Icons.people_alt,
                      CovermintTheme.brandPrimary,
                    ),
                    const SizedBox(height: 12),
                    _buildKpiCard(
                      'Conversion Rate',
                      '${d['conversion_pct'] ?? 0}%',
                      Icons.trending_up,
                      CovermintTheme.approvedGreen,
                    ),
                    const SizedBox(height: 12),
                    _buildKpiCard(
                      'Commission Earned',
                      '${d['commission_earned'] ?? 0}',
                      Icons.account_balance_wallet,
                      CovermintTheme.brandAccent,
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

  Widget _buildKpiCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
          Text(
            value,
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
