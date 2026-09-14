import 'package:flutter/material.dart';
import '../../../core/theme.dart';

class ProductDetailScreen extends StatelessWidget {
  final String category;
  const ProductDetailScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final title = '${category[0].toUpperCase()}${category.substring(1)} Insurance';
    return Scaffold(
      backgroundColor: StitchColors.surface,
      appBar: AppBar(title: Text(title), backgroundColor: StitchColors.surface),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: StitchColors.surfaceLowest, borderRadius: BorderRadius.circular(16), border: Border.all(color: StitchColors.slate200)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: StitchColors.secondaryContainer.withValues(alpha: 0.2), shape: BoxShape.circle), child: const Icon(Icons.notifications_active_outlined, color: StitchColors.secondary, size: 32)),
                const SizedBox(height: 16),
                const Text('Coming soon — we will notify you.', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: StitchColors.onSurface), textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text('Your $category intent was recorded.', style: const TextStyle(color: StitchColors.onSurfaceVariant), textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
