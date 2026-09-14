import 'package:flutter/material.dart';
import '../../../core/theme.dart';

class LeadsTab extends StatelessWidget {
  final dynamic repository;
  const LeadsTab({super.key, this.repository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StitchColors.surface,
      appBar: AppBar(title: const Text('Leads'), backgroundColor: StitchColors.surface),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(color: StitchColors.surfaceLowest, borderRadius: BorderRadius.circular(16), border: Border.all(color: StitchColors.slate200)),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: StitchColors.surfaceLow, shape: BoxShape.circle),
                  child: const Icon(Icons.inbox_outlined, size: 32, color: StitchColors.slate500),
                ),
                const SizedBox(height: 16),
                const Text('No leads yet', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: StitchColors.onSurface)),
                const SizedBox(height: 8),
                const Text('Leads will appear here once you start selling.', style: TextStyle(fontSize: 12, color: StitchColors.onSurfaceVariant), textAlign: TextAlign.center),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _leadTile('Aman Verma', '+91 98765 12345', 'Motor — Pending'),
          _leadTile('Priya Sharma', '+91 91234 56789', 'Life — Verified'),
        ],
      ),
    );
  }

  Widget _leadTile(String name, String phone, String status) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: StitchColors.surfaceLowest, borderRadius: BorderRadius.circular(12), border: Border.all(color: StitchColors.slate200)),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: StitchColors.surfaceLow, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.person, color: StitchColors.secondary, size: 20)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: StitchColors.onSurface)), Text(phone, style: const TextStyle(color: StitchColors.onSurfaceVariant, fontSize: 12)), Text(status, style: const TextStyle(color: StitchColors.secondary, fontSize: 11))])),
          const Icon(Icons.arrow_forward_ios, size: 14, color: StitchColors.outline),
        ],
      ),
    );
  }
}
