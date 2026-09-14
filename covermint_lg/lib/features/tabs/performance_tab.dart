import 'package:flutter/material.dart';
import '../../../core/theme.dart';

class PerformanceTab extends StatelessWidget {
  final dynamic repository;
  const PerformanceTab({super.key, this.repository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StitchColors.surface,
      appBar: AppBar(title: const Text('Performance'), backgroundColor: StitchColors.surface),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _kpi('Leads generated', '42', Icons.people_alt_outlined, StitchColors.primary),
          const SizedBox(height: 12),
          _kpi('Conversion', '68%', Icons.trending_up, StitchColors.success),
          const SizedBox(height: 12),
          _kpi('Commission earned', '₹1.2L', Icons.account_balance_wallet_outlined, StitchColors.secondary),
        ],
      ),
    );
  }

  Widget _kpi(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: StitchColors.surfaceLowest, borderRadius: BorderRadius.circular(16), border: Border.all(color: StitchColors.slate200)),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color, size: 24)),
          const SizedBox(width: 16),
          Expanded(child: Text(label, style: const TextStyle(color: StitchColors.onSurfaceVariant, fontSize: 14))),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }
}
