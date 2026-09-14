import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme.dart';

class SellHubScreen extends StatelessWidget {
  final dynamic repository;
  const SellHubScreen({super.key, this.repository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StitchColors.surface,
      appBar: AppBar(
        backgroundColor: StitchColors.surface,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: StitchColors.secondary), onPressed: () => context.go('/dashboard')),
        title: const Text('Dashboard', style: TextStyle(fontSize: 14, color: StitchColors.secondary)),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Choose Insurance Type', style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 24, fontWeight: FontWeight.w700, color: StitchColors.primary)),
            const SizedBox(height: 6),
            const Text('Select a policy category to initiate a new client lead & quote calculation', style: TextStyle(fontSize: 14, color: StitchColors.onSurfaceVariant)),
            const SizedBox(height: 20),
            _insuranceCard(
              context,
              icon: Icons.shield_outlined,
              iconBg: StitchColors.tertiaryFixedDim.withValues(alpha: 0.3),
              title: 'Life Insurance',
              badge: 'Top Commission 18%',
              badgeBg: StitchColors.secondaryFixed,
              badgeColor: StitchColors.onSecondaryFixedVariant,
              desc: 'Term Life, Endowment, ULIP & Child Education plans with guaranteed returns.',
              chips: const ['Instant Quote', 'Paperless KYC', 'Instant Payout'],
              footerLeft: 'Get Started',
              footerRight: 'Avg closure 6 mins',
              onTap: () => _showToast(context, 'Life Insurance'),
            ),
            const SizedBox(height: 12),
            _insuranceCard(
              context,
              icon: Icons.directions_car_outlined,
              iconBg: StitchColors.primaryFixed,
              title: 'Motor Insurance',
              badge: 'Zero-Inspection Ready',
              badgeBg: StitchColors.surfaceContainerHigh,
              badgeColor: StitchColors.onSurfaceVariant,
              desc: 'Comprehensive 4-Wheeler & 2-Wheeler coverage with instant vehicle inspection.',
              chips: const ['Zero Dep', '24x7 Roadside', 'Instant Policy Copy'],
              footerLeft: 'Get Started',
              footerRight: 'Instant RC lookup',
              onTap: () => _showToast(context, 'Motor Insurance'),
            ),
            const SizedBox(height: 12),
            _insuranceCard(
              context,
              icon: Icons.medical_services_outlined,
              iconBg: StitchColors.tertiaryFixed,
              title: 'Health Insurance',
              badge: '10,000+ Hospitals',
              badgeBg: StitchColors.tertiaryFixed,
              badgeColor: Color(0xFF00201D),
              desc: 'Individual & Family Floater medical covers with cashless hospital network.',
              chips: const ['Cashless Claims', 'Pre-Existing Cover', 'Tax Saving 80D'],
              footerLeft: 'Get Started',
              footerRight: 'Pre-underwritten',
              onTap: () => _showToast(context, 'Health Insurance'),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: StitchColors.surfaceContainer, borderRadius: BorderRadius.circular(12)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 40, height: 40, decoration: const BoxDecoration(color: StitchColors.surfaceLowest, shape: BoxShape.circle), child: const Icon(Icons.support_agent, color: StitchColors.secondary)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Need help choosing?', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: StitchColors.primary)),
                        const SizedBox(height: 4),
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(fontSize: 12, color: StitchColors.onSurfaceVariant, height: 1.4),
                            children: [
                              TextSpan(text: 'Connect with your Regional Manager '),
                              TextSpan(text: 'Vikramaditya Rao', style: TextStyle(fontWeight: FontWeight.w600, color: StitchColors.primary)),
                              TextSpan(text: ' directly for co-browsing and high-ticket assistance.'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _smallBtn(Icons.call, 'Call RM', () {}),
                            const SizedBox(width: 8),
                            _smallBtn(Icons.chat_bubble_outline, 'WhatsApp', () {}),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _insuranceCard(BuildContext context, {required IconData icon, required Color iconBg, required String title, required String badge, required Color badgeBg, required Color badgeColor, required String desc, required List<String> chips, required String footerLeft, required String footerRight, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(color: StitchColors.surfaceLowest, borderRadius: BorderRadius.circular(12), border: Border.all(color: StitchColors.slate200), boxShadow: const [BoxShadow(color: Color(0x0A0F172A), blurRadius: 6)]),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(width: 48, height: 48, decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle), child: Icon(icon, color: StitchColors.primary, size: 24)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: StitchColors.primary)),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(999)),
                              child: Text(badge, style: TextStyle(fontSize: 11, color: badgeColor, fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(color: StitchColors.surfaceContainerHigh, borderRadius: BorderRadius.circular(999)),
                        child: Row(children: const [Icon(Icons.circle, size: 6, color: StitchColors.secondaryContainer), SizedBox(width: 4), Text('API Beta', style: TextStyle(fontSize: 11, color: StitchColors.onSurfaceVariant))]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(desc, style: const TextStyle(fontSize: 14, color: StitchColors.onSurfaceVariant, height: 1.4)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: chips.map((c) => Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: StitchColors.surfaceLow, borderRadius: BorderRadius.circular(6)), child: Text(c, style: const TextStyle(fontSize: 11, color: StitchColors.onSurfaceVariant)))).toList(),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(color: StitchColors.surfaceLow.withValues(alpha: 0.5), borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12))),
              child: Row(
                children: [
                  Text(footerLeft, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: StitchColors.secondary)),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward, size: 16, color: StitchColors.secondary),
                  const Spacer(),
                  Text(footerRight, style: const TextStyle(fontSize: 11, color: StitchColors.outline)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _smallBtn(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: StitchColors.surfaceLowest, borderRadius: BorderRadius.circular(8), boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 4)]),
        child: Row(children: [Icon(icon, size: 14, color: StitchColors.secondary), const SizedBox(width: 6), Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: StitchColors.primary))]),
      ),
    );
  }

  static void _showToast(BuildContext context, String policy) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [const Icon(Icons.check_circle, color: StitchColors.secondaryContainer), const SizedBox(width: 8), Text('Initiating $policy Lead Flow...')]),
        backgroundColor: StitchColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
