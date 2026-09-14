import 'package:flutter/material.dart';
import '../../../core/theme.dart';

class RenewalsTab extends StatelessWidget {
  final dynamic repository;
  const RenewalsTab({super.key, this.repository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StitchColors.surface,
      appBar: AppBar(title: const Text('Renewals'), backgroundColor: StitchColors.surface),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _bucket('30 Days', '12', StitchColors.error, Icons.warning_amber),
          const SizedBox(height: 12),
          _bucket('60 Days', '8', StitchColors.warning, Icons.schedule),
          const SizedBox(height: 12),
          _bucket('90 Days', '24', StitchColors.success, Icons.check_circle),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: StitchColors.surfaceLow, borderRadius: BorderRadius.circular(12)),
            child: const Column(children: [
              Icon(Icons.inbox_outlined, color: StitchColors.slate500, size: 32),
              SizedBox(height: 12),
              Text('No renewal data', style: TextStyle(color: StitchColors.onSurface, fontWeight: FontWeight.w600)),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _bucket(String label, String count, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: StitchColors.surfaceLowest, borderRadius: BorderRadius.circular(12), border: Border.all(color: StitchColors.slate200)),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: color, size: 20)),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: StitchColors.onSurface))),
          Text(count, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }
}
