import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/theme.dart';
import '../../../shared/widgets/feedback.dart';
import '../register/data/covermint_repository.dart';

const _fallbackCategories = [
  {'category': 'life', 'title': 'Life Insurance', 'icon': 'life'},
  {'category': 'motor', 'title': 'Motor Insurance', 'icon': 'motor'},
  {'category': 'health', 'title': 'Health Insurance', 'icon': 'health'},
];

class SellHubScreen extends StatefulWidget {
  final CovermintRepository repository;

  const SellHubScreen({super.key, required this.repository});

  @override
  State<SellHubScreen> createState() => _SellHubScreenState();
}

class _SellHubScreenState extends State<SellHubScreen> {
  late final Future<List<Map<String, dynamic>>> _future;
  final Set<String> _busy = {};

  @override
  void initState() {
    super.initState();
    _future = widget.repository.getCatalog();
  }

  static String _categoryOf(Map<String, dynamic> item) {
    for (final key in ['category', 'type', 'slug', 'name', 'title', 'id']) {
      final v = item[key];
      if (v is String && v.isNotEmpty) return v.toLowerCase();
    }
    return 'unknown';
  }

  static String _titleOf(Map<String, dynamic> item, int index) {
    for (final key in ['title', 'name', 'label']) {
      final v = item[key];
      if (v is String && v.isNotEmpty) return v;
    }
    if (index < _fallbackCategories.length) {
      return _fallbackCategories[index]['title']!;
    }
    return 'Insurance';
  }

  static IconData _iconFor(String category) {
    switch (category) {
      case 'life':
        return Icons.favorite;
      case 'motor':
        return Icons.directions_car;
      case 'health':
        return Icons.health_and_safety;
      default:
        return Icons.shield;
    }
  }

  static LinearGradient _gradientFor(String category) {
    switch (category) {
      case 'life':
        return const LinearGradient(
          colors: [Color(0xFFE91E63), Color(0xFF9C27B0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'motor':
        return const LinearGradient(
          colors: [Color(0xFF2196F3), Color(0xFF0D47A1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'health':
        return const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF1B5E20)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return CovermintTheme.primaryGradient;
    }
  }

  Future<void> _open(Map<String, dynamic> item, int index) async {
    final category = _categoryOf(item);
    final key = category == 'unknown' ? 'cat-$index' : category;
    setState(() => _busy.add(key));
    try {
      final intent = await widget.repository.postIntent(category: category);
      if (!mounted) return;
      showOk(context, 'Intent created: ${intent['id']}');
      context.go('/sell/$category');
    } catch (e) {
      if (mounted) showApiError(context, e);
    } finally {
      if (mounted) setState(() => _busy.remove(key));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Sell Hub'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: CovermintTheme.heroGradient),
        child: SafeArea(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _future,
            builder: (context, snap) {
              if (snap.connectionState != ConnectionState.done) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }
              if (snap.hasError) {
                final e = snap.error!;
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline,
                          color: Colors.white, size: 48),
                      const SizedBox(height: 16),
                      Text(e is ApiException ? e.message : e.toString(),
                          style: const TextStyle(color: Colors.white)),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () => setState(() {}),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }
              final items =
                  snap.data!.isEmpty ? _fallbackCategories : snap.data!;
              return ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, i) {
                  final item = items[i];
                  final category = _categoryOf(item);
                  final key =
                      category == 'unknown' ? 'cat-$i' : category;
                  final loading = _busy.contains(key);
                  return _buildCategoryCard(
                    title: _titleOf(item, i),
                    icon: _iconFor(category),
                    gradient: _gradientFor(category),
                    loading: loading,
                    onTap: loading ? null : () => _open(item, i),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard({
    required String title,
    required IconData icon,
    required LinearGradient gradient,
    required bool loading,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 32),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tap to start a policy intent',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            loading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : Icon(Icons.arrow_forward_ios,
                    color: Colors.white.withValues(alpha: 0.8), size: 20),
          ],
        ),
      ),
    );
  }
}
