import 'package:flutter/material.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/theme.dart';
import '../register/data/covermint_repository.dart';

class LeadsTab extends StatefulWidget {
  final CovermintRepository repository;

  const LeadsTab({super.key, required this.repository});

  @override
  State<LeadsTab> createState() => _LeadsTabState();
}

class _LeadsTabState extends State<LeadsTab>
    with AutomaticKeepAliveClientMixin {
  late Future<Map<String, dynamic>> _future;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _future = widget.repository.getLeads();
  }

  Future<void> _refresh() async {
    final next = widget.repository.getLeads();
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
        title: const Text('Leads'),
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
                final data = snap.data!['data'];
                final items = data is List ? data : const [];
                if (items.isEmpty) {
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(24),
                    children: [
                      const SizedBox(height: 80),
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.inbox_outlined,
                          size: 64,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'No leads yet',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Leads will appear here once you start selling.',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                }
                return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    final item = items[i] is Map
                        ? items[i] as Map
                        : {'id': items[i]};
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
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
                              color: CovermintTheme.brandPrimary
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.person,
                              color: CovermintTheme.brandPrimary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${item['name'] ?? item['id'] ?? 'Lead'}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                if (item['phone'] != null)
                                  Text(
                                    '${item['phone']}',
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 13,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios,
                              color: Colors.grey.shade300, size: 16),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
