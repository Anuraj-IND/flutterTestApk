import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme.dart';

// Placeholder - no API, just fields and navigation
class Step2Screen extends StatefulWidget {
  final dynamic repository;
  final String draftId;
  const Step2Screen({super.key, this.repository, required this.draftId});

  @override
  State<Step2Screen> createState() => _Step2ScreenState();
}

class _Step2ScreenState extends State<Step2Screen> {
  final _pincode = TextEditingController(text: '400053');
  final _address = TextEditingController(text: 'Flat 402, Greenfield Heights, Andheri West, Mumbai, MH - 400053');
  final _rmName = TextEditingController(text: 'Vikramaditya Rao');
  final _rmPhone = TextEditingController(text: '98201 12345');
  final _ifsc = TextEditingController(text: 'HDFC0000128');
  final _acc = TextEditingController(text: '50100234891023');
  final _accRe = TextEditingController(text: '50100234891023');
  bool _terms = true;
  bool _ifscValidated = true;

  @override
  void dispose() {
    _pincode.dispose();
    _address.dispose();
    _rmName.dispose();
    _rmPhone.dispose();
    _ifsc.dispose();
    _acc.dispose();
    _accRe.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StitchColors.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: StitchColors.surface.withValues(alpha: 0.95),
            elevation: 0,
            leading: IconButton(icon: const Icon(Icons.arrow_back, color: StitchColors.onSurface), onPressed: () => context.go('/register')),
            title: Column(
              children: const [
                Text('Agent Onboarding', style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 16, fontWeight: FontWeight.w600, color: StitchColors.onSurface)),
                Text('Step 2 of 2 • Final Verification', style: TextStyle(fontSize: 11, color: StitchColors.onSurfaceVariant)),
              ],
            ),
            centerTitle: true,
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: StitchColors.surfaceContainerHighest, borderRadius: BorderRadius.circular(999)),
                child: Row(children: const [
                  Icon(Icons.circle, size: 8, color: StitchColors.success),
                  SizedBox(width: 4),
                  Text('100% Ready', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: StitchColors.onSurface)),
                ]),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(36),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: const LinearProgressIndicator(value: 1.0, minHeight: 6, backgroundColor: StitchColors.surfaceContainerHighest, valueColor: AlwaysStoppedAnimation(StitchColors.secondaryContainer)),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: const [
                        Text('Address, Banking & KYC', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: StitchColors.secondary)),
                        Spacer(),
                        Text('2 of 2 Complete', style: TextStyle(fontSize: 11, color: StitchColors.onSurfaceVariant)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: StitchColors.surfaceContainer, borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.verified_user, size: 16, color: Color(0xFF314865)),
                          const SizedBox(width: 6),
                          const Text('Verified Details from Step 1', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: StitchColors.primary)),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: StitchColors.surfaceLowest, borderRadius: BorderRadius.circular(999)),
                            child: Row(children: const [Icon(Icons.lock, size: 12, color: StitchColors.onSurfaceVariant), SizedBox(width: 4), Text('Read-only', style: TextStyle(fontSize: 11, color: StitchColors.onSurfaceVariant))]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _summaryItem('Full Legal Name', 'Rajesh Kumar Sharma')),
                          Expanded(child: _summaryItem('Mobile Number', '+91 98765 43210')),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(child: _summaryItem('Registered Email', 'rajesh.sharma@...in')),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('PAN Number', style: TextStyle(fontSize: 11, color: StitchColors.onSurfaceVariant)),
                                Row(children: const [
                                  Text('ABCDE1234F', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: StitchColors.onSurface, letterSpacing: 0.8)),
                                  SizedBox(width: 4),
                                  Icon(Icons.check_circle, size: 14, color: StitchColors.secondary),
                                ]),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _sectionCard(
                  icon: Icons.pin_drop_outlined,
                  title: 'Address Details',
                  subtitle: 'Synchronized with Aadhaar eKYC database',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('Pincode *', style: TextStyle(fontSize: 12, color: StitchColors.onSurfaceVariant)),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: StitchColors.surfaceContainerHighest, borderRadius: BorderRadius.circular(999)),
                            child: Row(children: const [Icon(Icons.location_on, size: 12, color: StitchColors.secondary), SizedBox(width: 4), Text('Mumbai, MH auto-detected', style: TextStyle(fontSize: 11, color: StitchColors.secondary, fontWeight: FontWeight.w600))]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      _stitchField(controller: _pincode, suffix: const Icon(Icons.check_circle, color: StitchColors.secondary, size: 20)),
                      const SizedBox(height: 12),
                      const Text('Permanent Address (as per Aadhaar)', style: TextStyle(fontSize: 12, color: StitchColors.onSurfaceVariant)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: StitchColors.surfaceLow, borderRadius: BorderRadius.circular(8), border: Border.all(color: StitchColors.slate200)),
                        child: TextField(
                          controller: _address,
                          maxLines: 2,
                          style: const TextStyle(fontSize: 14, color: StitchColors.onSurface),
                          decoration: const InputDecoration(border: InputBorder.none, isDense: true),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _labeledField('Allocated RM Name', _rmName)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('RM Contact No.', style: TextStyle(fontSize: 11, color: StitchColors.onSurfaceVariant)),
                                const SizedBox(height: 6),
                                Container(
                                  height: 44,
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(color: StitchColors.surfaceLow, borderRadius: BorderRadius.circular(8), border: Border.all(color: StitchColors.slate200)),
                                  child: Row(
                                    children: [
                                      Expanded(child: TextField(controller: _rmPhone, decoration: const InputDecoration(border: InputBorder.none, isDense: true), style: const TextStyle(fontSize: 14))),
                                      const Icon(Icons.call, size: 16, color: StitchColors.secondary),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _sectionCard(
                  icon: Icons.account_balance_outlined,
                  title: 'Banking Details',
                  subtitle: 'Commission and payout settlement account',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Bank IFSC Code *', style: TextStyle(fontSize: 12, color: StitchColors.onSurfaceVariant)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(child: _stitchField(controller: _ifsc, hint: 'HDFC0000128')),
                          const SizedBox(width: 8),
                          Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(color: StitchColors.surfaceContainerHighest, borderRadius: BorderRadius.circular(8)),
                            child: Row(children: [
                              const Icon(Icons.verified, size: 16, color: StitchColors.secondary),
                              const SizedBox(width: 4),
                              Text(_ifscValidated ? 'Validated' : 'Verify', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: StitchColors.secondary)),
                            ]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: StitchColors.surfaceLow, borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          children: [
                            _bankRow('Bank Name', 'HDFC Bank Ltd', isBold: true),
                            const SizedBox(height: 6),
                            _bankRow('Branch', 'Andheri West Branch, Mumbai'),
                            const SizedBox(height: 6),
                            _bankRow('Branch Address', 'Plot No. 12, Link Road, Mumbai', isTruncate: true),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text('Bank Account Number *', style: TextStyle(fontSize: 12, color: StitchColors.onSurfaceVariant)),
                      const SizedBox(height: 6),
                      _stitchField(controller: _acc, obscure: true),
                      const SizedBox(height: 12),
                      Row(
                        children: const [
                          Text('Re-enter Account Number *', style: TextStyle(fontSize: 12, color: StitchColors.onSurfaceVariant)),
                          Spacer(),
                          Icon(Icons.check, size: 12, color: StitchColors.secondary),
                          SizedBox(width: 4),
                          Text('Matching', style: TextStyle(fontSize: 11, color: StitchColors.secondary, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          _stitchField(controller: _accRe),
                          const Padding(padding: EdgeInsets.only(right: 12), child: Icon(Icons.task_alt, color: StitchColors.secondary, size: 20)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _sectionCard(
                  icon: Icons.file_present_outlined,
                  title: 'Upload Documents',
                  subtitle: 'Original scans required for IRDAI approval',
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: StitchColors.surfaceContainerHighest, borderRadius: BorderRadius.circular(999)),
                    child: const Text('4/4 Attached', style: TextStyle(fontSize: 11, color: StitchColors.secondary, fontWeight: FontWeight.w600)),
                  ),
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.92,
                    children: [
                      _docTile('Aadhaar (Front)', 'aadhaar_front.jpg', 'https://lh3.googleusercontent.com/aida-public/AB6AXuAttP8BmWiRli1aYJGI4YcildJyzhAU5rWnVeVyBQ_r0aRmty4TJgANX4D6-9bcxtn5pPgvZIRhRfQNmHYXCaB7bnPsa9bCso7wuXymLmJeu90wQd_jXb8JcG8KWLglWwrvvdDl1kaRmJN_-zjKDWxULLocj0GUqrPlmPqU1ic8rB_6I3F8wMgtnLGLquBSmokMrpdO2Eyw2GhCHUgnBoD6Cf2LFeRXUElldY3SZwsIbuGY33V6Dfm9'),
                      _docTile('Aadhaar (Back)', 'aadhaar_back.jpg', 'https://lh3.googleusercontent.com/aida-public/AB6AXuC0pZlkwbsi4mr884B289tpXCRcV7fhm-15cjXkyX6ag6MG9XTx8i2xnQJw0GaY08KGsy446VHBibY09vcUnOeUGli4Z-6gFrYGqx7KVqx1SBo5ERqWewWGE9fwn7AOLBZePbzLIS58iGPcR7zsYLxCrI6hFPZcYcw4kTqdH5hYYzWIbCQu4qHtnUlDiL9b5ZE-aSWck3AEsrSGu8vtDaPg1gL2tb8QWeM_vCbTz8HTgffHLtNimvcS'),
                      _docTile('PAN Card', 'pan_card_reg.pdf', 'https://lh3.googleusercontent.com/aida-public/AB6AXuAporBTdEIuOHLGP78MOFNd0hueWtl_hcJjh53WeTs4bZ_GZWLgVlwfv6phbK0BFR-rwODe8MRAPzYf_CpG-RogKPKtInU6ou5EhKBBAlXnOuOo_zPNcbn7VNNuKZroLU4nJAaFHOx02DFuWpTeZ3vjKWqVQZ_Kt-PGcPOl_wAXs4ip6LOMmMdsbyd4LZ6WhhNplGmmvhsdx_r7KtVh_ICSulQUwh_e9ee6Ky3ZcxkIz77NFzqgbEGN'),
                      _docTile('Cancelled Cheque', 'hdfc_cheque.jpg', 'https://lh3.googleusercontent.com/aida-public/AB6AXuBpkyDUf-As156qGU6pE7YO_6pojeMBon7MN2tP6nEa7kaEh4ASPzKBZ6O4EcSa0fxjfgTaxou2q-yYg031kXU3iRZdAeJcoxNzNLANiGhnEzUc8ZbZzJeYTZYgNlzN9mjDAbrGZD5TH1__wFOXRfTj-us-GU8HLl0BSg9omHMTOSKlpn_jOTTHocRDMiRu7vIq9UtBn-yciPRXowkWGAtKC-vbkdcyhBlkcvY7O_1903SN2sGAQC70'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: StitchColors.surfaceLowest, borderRadius: BorderRadius.circular(12), border: Border.all(color: StitchColors.slate200), boxShadow: const [BoxShadow(color: Color(0x0A0F172A), blurRadius: 8)]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.gavel_outlined, size: 20, color: StitchColors.secondary),
                          const SizedBox(width: 8),
                          const Text('Terms & Agent Code of Conduct', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: StitchColors.onSurface)),
                          const Spacer(),
                          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: StitchColors.surfaceContainerHigh, borderRadius: BorderRadius.circular(999)), child: const Text('v2.4 (2024)', style: TextStyle(fontSize: 10, color: StitchColors.onSurface))),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(color: StitchColors.surfaceLow, borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: const [
                            Icon(Icons.verified, size: 16, color: StitchColors.secondary),
                            SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Rajesh Kumar Sharma', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: StitchColors.onSurface)),
                                Text('Timestamp: 24 Oct 2024, 02:45 PM IST', style: TextStyle(fontSize: 11, color: StitchColors.onSurfaceVariant)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 112,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: StitchColors.surfaceLow, borderRadius: BorderRadius.circular(8)),
                        child: const SingleChildScrollView(
                          child: Text(
                            '1. Representation: The Agent undertakes to act in strict compliance with the statutory regulations laid down by IRDAI and corporate compliance charters.\n\n2. Disclosure of Commissions: All incentives, fees, and payout splits are dynamically bound to certified policy closures.\n\n3. Data Confidentiality: No customer data shall be stored on unauthorized media.\n\n4. Termination: Any breach triggers immediate deactivation.',
                            style: TextStyle(fontSize: 11, height: 1.4, color: StitchColors.onSurfaceVariant),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: () => setState(() => _terms = !_terms),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                color: _terms ? StitchColors.primary : Colors.white,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: _terms ? StitchColors.primary : StitchColors.slate200),
                              ),
                              child: _terms ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'I declare that the information and bank documents provided are true and correct. I agree to the Terms & Conditions and Agent Code of Conduct.',
                                style: TextStyle(fontSize: 12, color: StitchColors.onSurface, height: 1.3),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _terms ? () => context.go('/dashboard') : null,
                    style: FilledButton.styleFrom(backgroundColor: StitchColors.primary, disabledBackgroundColor: StitchColors.slate200),
                    icon: const Icon(Icons.shield, size: 18),
                    label: const Text('Complete Registration & Launch Dashboard'),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.lock, size: 12, color: StitchColors.onSurfaceVariant),
                    SizedBox(width: 4),
                    Text('256-bit encrypted IRDAI agency application submission', style: TextStyle(fontSize: 11, color: StitchColors.onSurfaceVariant)),
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(String label, String value) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 11, color: StitchColors.onSurfaceVariant)),
      const SizedBox(height: 2),
      Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: StitchColors.onSurface), overflow: TextOverflow.ellipsis),
    ]);
  }

  Widget _sectionCard({required IconData icon, required String title, String? subtitle, Widget? trailing, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: StitchColors.surfaceLowest, borderRadius: BorderRadius.circular(12), border: Border.all(color: StitchColors.slate200), boxShadow: const [BoxShadow(color: Color(0x0A0F172A), blurRadius: 6)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 32, height: 32, decoration: BoxDecoration(color: StitchColors.surfaceContainerHigh, borderRadius: BorderRadius.circular(8)), child: Icon(icon, size: 18, color: StitchColors.secondary)),
              const SizedBox(width: 8),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: StitchColors.onSurface)), if (subtitle != null) Text(subtitle, style: const TextStyle(fontSize: 11, color: StitchColors.onSurfaceVariant))])),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _stitchField({required TextEditingController controller, String? hint, bool obscure = false, Widget? suffix}) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: StitchColors.surfaceLow, borderRadius: BorderRadius.circular(8), border: Border.all(color: StitchColors.slate200)),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscure,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: StitchColors.onSurface, letterSpacing: 0.5),
              decoration: InputDecoration(border: InputBorder.none, hintText: hint, isDense: true, hintStyle: const TextStyle(color: StitchColors.outline)),
            ),
          ),
          if (suffix != null) suffix,
        ],
      ),
    );
  }

  Widget _labeledField(String label, TextEditingController c) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 11, color: StitchColors.onSurfaceVariant)),
      const SizedBox(height: 6),
      _stitchField(controller: c),
    ]);
  }

  Widget _bankRow(String label, String value, {bool isBold = false, bool isTruncate = false}) {
    return Row(children: [
      Text(label, style: const TextStyle(fontSize: 11, color: StitchColors.onSurfaceVariant)),
      const Spacer(),
      SizedBox(
        width: 180,
        child: Text(value, textAlign: TextAlign.right, overflow: isTruncate ? TextOverflow.ellipsis : TextOverflow.visible, style: TextStyle(fontSize: isBold ? 13 : 12, fontWeight: isBold ? FontWeight.w600 : FontWeight.w400, color: isBold ? StitchColors.primary : StitchColors.onSurface)),
      ),
    ]);
  }

  Widget _docTile(String title, String file, String url) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: StitchColors.surfaceLow, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(url, fit: BoxFit.cover, width: double.infinity, errorBuilder: (_, __, ___) => Container(color: StitchColors.surfaceContainerHigh, child: const Icon(Icons.image, color: StitchColors.slate500))),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(color: StitchColors.secondaryContainer, shape: BoxShape.circle),
                    child: const Icon(Icons.check, size: 14, color: StitchColors.onSecondaryFixedVariant),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: StitchColors.onSurface), maxLines: 1, overflow: TextOverflow.ellipsis),
          Text(file, style: const TextStyle(fontSize: 10, color: StitchColors.onSurfaceVariant), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 6),
          SizedBox(
            width: double.infinity,
            height: 26,
            child: OutlinedButton(onPressed: () {}, style: OutlinedButton.styleFrom(padding: EdgeInsets.zero, backgroundColor: StitchColors.surfaceContainer, side: BorderSide.none, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: const Text('Re-upload', style: TextStyle(fontSize: 11, color: StitchColors.secondary))),
          ),
        ],
      ),
    );
  }
}
