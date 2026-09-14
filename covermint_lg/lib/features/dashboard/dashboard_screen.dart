import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/auth/auth_state.dart';
import '../../../core/theme.dart';
import '../register/data/covermint_repository.dart';

class DashboardScreen extends StatefulWidget {
  final CovermintRepository repository;
  final AuthState authState;

  const DashboardScreen({
    super.key,
    required this.repository,
    required this.authState,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<Map<String, dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.repository.getDashboard();
  }

  Future<void> _refresh() async {
    final next = widget.repository.getDashboard();
    setState(() => _future = next);
    await next;
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Log out?'),
        content: const Text('Your saved session on this device will be cleared.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Log out'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await widget.authState.logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Log out',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<Map<String, dynamic>>(
          future: _future,
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return Container(
                decoration: const BoxDecoration(gradient: CovermintTheme.heroGradient),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              );
            }
            if (snap.hasError) {
              final e = snap.error!;
              return Container(
                decoration: const BoxDecoration(gradient: CovermintTheme.heroGradient),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.white, size: 48),
                      const SizedBox(height: 16),
                      Text(e is ApiException ? e.message : e.toString(),
                          style: const TextStyle(color: Colors.white)),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: _refresh,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }
            final d = snap.data!;
            final seq = d['lg_seq'] ?? d['lgSeq'] ?? widget.authState.lgSeq;
            final status = '${d['verification_status'] ?? 'pending'}';
            return CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 80, 20, 30),
                    decoration: const BoxDecoration(
                      gradient: CovermintTheme.heroGradient,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 48,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '#$seq',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Lead Generator ID',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _statusPill(status),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildInfoCard(d),
                      const SizedBox(height: 16),
                      _buildSellButton(),
                    ]),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _statusPill(String status) {
    final lower = status.toLowerCase();
    final Color color;
    final IconData icon;
    if (lower == 'approved') {
      color = CovermintTheme.approvedGreen;
      icon = Icons.check_circle;
    } else if (lower == 'rejected') {
      color = CovermintTheme.rejectedRed;
      icon = Icons.cancel;
    } else {
      color = CovermintTheme.pendingAmber;
      icon = Icons.hourglass_top;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 6),
          Text(
            status.toUpperCase(),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(Map<String, dynamic> d) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Personal Information',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(height: 24),
          _row('Name', d['name'], Icons.person_outline),
          _row('Phone', d['phone'], Icons.phone_outlined),
          _row('Email', d['email'], Icons.email_outlined),
          _row('Aadhaar', d['aadhaar_masked'], Icons.credit_card),
          _row(
            'RM',
            _join([d['rm_name'], d['rm_phone']], ' · '),
            Icons.support_agent,
          ),
          _row('ISP', d['isp_name'], Icons.business),
          _row('PO', d['po_name'], Icons.store),
          _row(
            'Active',
            (d['is_active'] == true) ? 'Yes' : 'No',
            d['is_active'] == true ? Icons.check_circle : Icons.cancel,
          ),
        ],
      ),
    );
  }

  static String _join(List<Object?> parts, String sep) {
    final items =
        parts.map((e) => '$e'.trim()).where((e) => e.isNotEmpty).toList();
    return items.isEmpty ? '—' : items.join(sep);
  }

  Widget _row(String label, Object? value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: CovermintTheme.brandPrimary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 16, color: CovermintTheme.brandPrimary),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              (value == null || '$value'.isEmpty) ? '—' : '$value',
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSellButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton.icon(
        onPressed: () => context.go('/sell'),
        icon: const Icon(Icons.storefront, color: Colors.white),
        label: const Text(
          'Sell Insurance',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: CovermintTheme.brandAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
