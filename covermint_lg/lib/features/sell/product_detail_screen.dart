import 'package:flutter/material.dart';

import '../../../core/theme.dart';

class ProductDetailScreen extends StatelessWidget {
  final String category;

  const ProductDetailScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final title =
        '${category[0].toUpperCase()}${category.substring(1)} Insurance';
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: CovermintTheme.heroGradient),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: CovermintTheme.brandAccent.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications_active_outlined,
                        size: 48,
                        color: CovermintTheme.brandAccent,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Coming Soon',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'We will notify you when this product is available.',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: CovermintTheme.approvedGreen.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Your $category intent was recorded.',
                        style: const TextStyle(
                          color: CovermintTheme.approvedGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
