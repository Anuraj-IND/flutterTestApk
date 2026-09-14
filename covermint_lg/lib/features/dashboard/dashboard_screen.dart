import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme.dart';

class DashboardScreen extends StatefulWidget {
  final dynamic repository;
  final dynamic authState;
  const DashboardScreen({super.key, this.repository, this.authState});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _masked = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StitchColors.surface,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        const CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuDuCLgcGmFX8VlVY0yVX8gW09AeqImUR4yydV1nwxrwtTiyZNbOorycUJSHItZJT-6rhOvk-mPZovCpls-aPKWet0HzjA3ZH5ZZ9_GkO3PQYAwIwpfx1cN1_3ki_1QRvVfLcCqqi7AOSpW5HkuDBGHL-ZEg58VK0UmqAvSoP_T_PVuaOGjVIFJtarMT2PUmyM0zgOssQvPBZrouUZUNbXxX1GRYt2nlf4Sq-2LxyY0QaUtvibLfK_Lh'),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(color: StitchColors.success, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('Hi, Rajesh', style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 18, fontWeight: FontWeight.w600, color: StitchColors.onSurface)),
                              SizedBox(width: 4),
                              Icon(Icons.verified, size: 16, color: StitchColors.secondary),
                            ],
                          ),
                          Text('Mumbai Central Hub • Senior LG', style: TextStyle(fontSize: 11, color: StitchColors.onSurfaceVariant)),
                        ],
                      ),
                    ),
                    Stack(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(color: StitchColors.surfaceContainerLow, shape: BoxShape.circle),
                          child: const Icon(Icons.notifications_outlined, color: StitchColors.primary),
                        ),
                        Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(color: StitchColors.error, borderRadius: BorderRadius.circular(999)),
                            child: const Text('3', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF0A2540), Color(0xFF0D3B66), Color(0xFF004C6E)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [BoxShadow(color: Color(0x330A2540), blurRadius: 20, offset: Offset(0, 8))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('FIELD IDENTITY PASS', style: TextStyle(fontSize: 11, letterSpacing: 0.8, color: StitchColors.secondaryFixed, fontWeight: FontWeight.w600)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(999)),
                        child: Row(children: const [
                          Icon(Icons.circle, size: 8, color: StitchColors.tertiaryFixedDim),
                          SizedBox(width: 6),
                          Text('Active Field Agent', style: TextStyle(fontSize: 11, color: Colors.white)),
                        ]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Lead Generator ID', style: TextStyle(fontSize: 11, color: Color(0xFFB0C8EB))),
                  Row(
                    children: [
                      const Text('LG-12345', style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: -0.5)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: StitchColors.secondary.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(8)),
                        child: const Text('Mumbai Zone', style: TextStyle(fontSize: 11, color: StitchColors.secondaryFixed)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: const [
                        Expanded(child: Column(children: [Text('Active Leads', style: TextStyle(fontSize: 11, color: Color(0xFFB0C8EB))), SizedBox(height: 4), Text('28', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white))])),
                        Expanded(child: Column(children: [Text('Policies', style: TextStyle(fontSize: 11, color: Color(0xFFB0C8EB))), SizedBox(height: 4), Text('14', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white))])),
                        Expanded(child: Column(children: [Text('Monthly Target', style: TextStyle(fontSize: 11, color: Color(0xFFB0C8EB))), SizedBox(height: 4), Text('82%', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: StitchColors.tertiaryFixed))])),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: const [
                Text('Agent KYC & Assignment', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: StitchColors.onSurface)),
                Spacer(),
                Text('Verified Underwriter', style: TextStyle(fontSize: 11, color: StitchColors.success, backgroundColor: StitchColors.successBg)),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: StitchColors.surfaceLowest, borderRadius: BorderRadius.circular(16), border: Border.all(color: StitchColors.slate200)),
              child: Column(
                children: [
                  _kycRow(Icons.badge_outlined, 'Full Legal Name', 'Rajesh Kumar Sharma', 'Code: LG-MUM-8842'),
                  const Divider(height: 24, color: StitchColors.slate200),
                  _kycRow(Icons.call_outlined, 'Primary Phone', '+91 98765 43210', null, trailing: const Text('Verified', style: TextStyle(fontSize: 11, color: StitchColors.secondary))),
                  const Divider(height: 24, color: StitchColors.slate200),
                  Row(
                    children: [
                      Container(width: 40, height: 40, decoration: BoxDecoration(color: StitchColors.surfaceLow, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.fingerprint, color: StitchColors.secondary)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Aadhaar Identity (Govt. ID)', style: TextStyle(fontSize: 11, color: StitchColors.onSurfaceVariant)),
                            Row(
                              children: [
                                Text(_masked ? 'XXXX-XXXX-1234' : '7482-9910-1234', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: StitchColors.onSurface, letterSpacing: 0.5)),
                                const Spacer(),
                                InkWell(onTap: () => setState(() => _masked = !_masked), child: Icon(_masked ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 18, color: StitchColors.onSurfaceVariant)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24, color: StitchColors.slate200),
                  _kycRow(Icons.mail_outline, 'Official Mail ID', 'rajesh.sharma@insurancepartners.in', null),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: StitchColors.surfaceLow, borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('REPORTING HIERARCHY', style: TextStyle(fontSize: 10, letterSpacing: 0.8, color: StitchColors.onSurfaceVariant, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.supervisor_account_outlined, size: 16, color: StitchColors.secondary),
                            const SizedBox(width: 8),
                            const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Relationship Manager', style: TextStyle(fontSize: 11, color: StitchColors.onSurfaceVariant)), Text('Vikramaditya Rao', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: StitchColors.onSurface))])),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(color: StitchColors.surfaceLowest, borderRadius: BorderRadius.circular(8), boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 4)]),
                              child: Row(children: const [Icon(Icons.phone, size: 14, color: StitchColors.secondary), SizedBox(width: 4), Text('Call RM', style: TextStyle(fontSize: 12, color: StitchColors.secondary, fontWeight: FontWeight.w600))]),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(children: const [Icon(Icons.verified_user_outlined, size: 16, color: StitchColors.secondary), SizedBox(width: 8), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Insurance Specified Person (ISP)', style: TextStyle(fontSize: 11, color: StitchColors.onSurfaceVariant)), Text('Amitav Banerjee', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: StitchColors.onSurface)), Text('Licence #ISP-9921', style: TextStyle(fontSize: 11, color: StitchColors.secondary))])]),
                        const SizedBox(height: 12),
                        Row(children: const [Icon(Icons.account_balance_outlined, size: 16, color: StitchColors.secondary), SizedBox(width: 8), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Principal Officer (PO)', style: TextStyle(fontSize: 11, color: StitchColors.onSurfaceVariant)), Text('Dr. Sunita Deshmukh', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: StitchColors.onSurface))])]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => context.go('/sell'),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF0A2540), Color(0xFF0A2540), Color(0xFF006591)], begin: Alignment.centerLeft, end: Alignment.centerRight),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [BoxShadow(color: Color(0x330A2540), blurRadius: 20, offset: Offset(0, 8))],
                ),
                child: Row(
                  children: [
                    Container(width: 32, height: 32, decoration: BoxDecoration(color: StitchColors.success, shape: BoxShape.circle), child: const Center(child: Text('⚡', style: TextStyle(fontSize: 16)))),
                    const SizedBox(width: 12),
                    const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Sell New Insurance', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)), Text('Instant quote generation', style: TextStyle(fontSize: 11, color: StitchColors.secondaryFixed))])),
                    Container(width: 36, height: 36, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle), child: const Icon(Icons.arrow_forward, color: Colors.white, size: 18)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: StitchColors.surfaceLowest, borderRadius: BorderRadius.circular(12), border: Border.all(color: StitchColors.slate200)),
                    child: Row(children: [
                      Container(width: 32, height: 32, decoration: BoxDecoration(color: StitchColors.surfaceContainerHigh, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.history_edu_outlined, size: 16, color: StitchColors.secondary)),
                      const SizedBox(width: 8),
                      const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Branch Code', style: TextStyle(fontSize: 11, color: StitchColors.onSurfaceVariant)), Text('MH-MUM-04', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: StitchColors.onSurface))]),
                    ]),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: StitchColors.surfaceLowest, borderRadius: BorderRadius.circular(12), border: Border.all(color: StitchColors.slate200)),
                    child: Row(children: [
                      Container(width: 32, height: 32, decoration: BoxDecoration(color: StitchColors.surfaceContainerHigh, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.workspace_premium_outlined, size: 16, color: StitchColors.success)),
                      const SizedBox(width: 8),
                      const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Commission Tier', style: TextStyle(fontSize: 11, color: StitchColors.onSurfaceVariant)), Text('Tier 1 Platinum', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: StitchColors.onSurface))]),
                    ]),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _kycRow(IconData icon, String label, String value, String? sub, {Widget? trailing}) {
    return Row(
      children: [
        Container(width: 40, height: 40, decoration: BoxDecoration(color: StitchColors.surfaceLow, borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: StitchColors.secondary, size: 18)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: StitchColors.onSurfaceVariant)),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: StitchColors.onSurface)),
              if (sub != null) Text(sub, style: const TextStyle(fontSize: 11, color: StitchColors.onSurfaceVariant)),
            ],
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }
}
