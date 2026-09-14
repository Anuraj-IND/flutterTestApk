import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StitchColors.surface,
      body: Stack(
        children: [
          Positioned(
            top: -80,
            left: -60,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                color: StitchColors.secondaryFixed.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: const SizedBox(),
            ),
          ),
          Positioned(
            top: 160,
            right: -80,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                color: StitchColors.surfaceContainerHighest.withValues(alpha: 0.6),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: StitchColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: const [
                          BoxShadow(color: Color(0x0A000000), blurRadius: 4, offset: Offset(0, 1)),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            children: [
                              Container(width: 8, height: 8, decoration: const BoxDecoration(color: StitchColors.secondary, shape: BoxShape.circle)),
                              Container(width: 8, height: 8, decoration: BoxDecoration(color: StitchColors.secondary.withValues(alpha: 0.4), shape: BoxShape.circle)),
                            ],
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            "INDIA'S #1 INSURANCE AGENT PARTNER",
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.4, color: StitchColors.onSurface),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 112,
                            height: 112,
                            decoration: BoxDecoration(
                              color: StitchColors.surfaceLowest,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: const [
                                BoxShadow(color: Color(0x1A0A2540), blurRadius: 20, offset: Offset(0, 8)),
                              ],
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: StitchColors.primary,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.shield_outlined, color: Colors.white, size: 32),
                                ),
                                const SizedBox(height: 6),
                                const Text('LG', style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w800, fontSize: 10, color: StitchColors.primary, letterSpacing: 1)),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: -8,
                            right: -8,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(color: StitchColors.primary, shape: BoxShape.circle),
                              child: const Icon(Icons.verified, color: Colors.white, size: 14),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: const [
                          Text('LG', style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 24, fontWeight: FontWeight.w800, color: StitchColors.primary, letterSpacing: -0.5)),
                          SizedBox(width: 6),
                          Icon(Icons.circle, size: 6, color: StitchColors.secondaryContainer),
                          SizedBox(width: 6),
                          Text('LEAD GENERATOR', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 1.2, color: Color(0xFF314865))),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Text('Grow Leads. Close Faster.', style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 18, fontWeight: FontWeight.w600, color: StitchColors.onSurface)),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: StitchColors.surfaceLow.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 8)],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.bolt, size: 12, color: StitchColors.secondary),
                            SizedBox(width: 4),
                            Text('Instant Quotes', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: StitchColors.onSurfaceVariant)),
                            SizedBox(width: 6),
                            Text('•', style: TextStyle(color: StitchColors.outlineVariant, fontWeight: FontWeight.bold)),
                            SizedBox(width: 6),
                            Icon(Icons.verified_user_outlined, size: 12, color: StitchColors.secondary),
                            SizedBox(width: 4),
                            Text('Rapid KYC', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: StitchColors.onSurfaceVariant)),
                            SizedBox(width: 6),
                            Text('•', style: TextStyle(color: StitchColors.outlineVariant, fontWeight: FontWeight.bold)),
                            SizedBox(width: 6),
                            Icon(Icons.cloud_done_outlined, size: 12, color: StitchColors.secondary),
                            SizedBox(width: 4),
                            Text('100% Digital', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: StitchColors.onSurfaceVariant)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: StitchColors.surfaceLowest,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [BoxShadow(color: Color(0x0F0A2540), blurRadius: 12, offset: Offset(0, 4))],
                          border: Border.all(color: StitchColors.slate200),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(color: StitchColors.secondaryFixed, borderRadius: BorderRadius.circular(12)),
                              child: const Icon(Icons.trending_up, color: StitchColors.onSecondaryFixedVariant),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Active Field Submissions', style: TextStyle(fontSize: 11, color: StitchColors.onSurfaceVariant)),
                                  Text('₹4.2 Cr Disbursed Today', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: StitchColors.onSurface)),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios, size: 14, color: StitchColors.secondary),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: FilledButton(
                          onPressed: () => context.go('/register'),
                          style: FilledButton.styleFrom(backgroundColor: StitchColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('Get Started', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, size: 18),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Already registered?', style: TextStyle(fontSize: 14, color: StitchColors.onSurfaceVariant)),
                          TextButton(
                            onPressed: () => context.go('/login'),
                            child: const Text('Agent Login', style: TextStyle(color: StitchColors.secondary, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: StitchColors.surfaceLow, borderRadius: BorderRadius.circular(999)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.lock_outline, size: 12, color: StitchColors.outline),
                            SizedBox(width: 6),
                            Text('IRDAI Compliant & 256-bit Encrypted Portal', style: TextStyle(fontSize: 11, color: StitchColors.onSurfaceVariant)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
