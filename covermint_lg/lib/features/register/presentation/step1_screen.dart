import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme.dart';
import '../data/covermint_repository.dart';

class Step1Screen extends StatefulWidget {
  final CovermintRepository? repository;
  const Step1Screen({super.key, this.repository});

  @override
  State<Step1Screen> createState() => _Step1ScreenState();
}

class _Step1ScreenState extends State<Step1Screen> {
  final _name = TextEditingController(text: 'Rajesh Kumar Sharma');
  final _phone = TextEditingController(text: '9876543210');
  final _email = TextEditingController(text: 'rajesh.sharma@insurancepartners.in');
  final _pan = TextEditingController(text: 'ABCDE1234F');
  final List<TextEditingController> _otpCtrls = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpNodes = List.generate(6, (_) => FocusNode());

  bool _otpSent = true;
  bool _phoneVerified = true;
  int _resendSec = 28;

  @override
  void initState() {
    super.initState();
    _otpCtrls[0].text = '4';
    _otpCtrls[1].text = '8';
    _otpCtrls[2].text = '2';
    _otpCtrls[3].text = '9';
    _otpCtrls[4].text = '1';
    _otpCtrls[5].text = '6';
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    _pan.dispose();
    for (final c in _otpCtrls) c.dispose();
    for (final n in _otpNodes) n.dispose();
    super.dispose();
  }

  void _onOtpChanged(String v, int idx) {
    if (v.isNotEmpty && idx < 5) _otpNodes[idx + 1].requestFocus();
    if (v.isEmpty && idx > 0) _otpNodes[idx - 1].requestFocus();
    setState(() {});
  }

  bool get _canProceed {
    final otp = _otpCtrls.map((c) => c.text).join();
    return _name.text.trim().isNotEmpty &&
        _phone.text.trim().length == 10 &&
        otp.length == 6 &&
        _email.text.contains('@') &&
        _pan.text.length == 10;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StitchColors.surface,
      appBar: AppBar(
        backgroundColor: StitchColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: StitchColors.onSurface),
          onPressed: () => context.go('/welcome'),
        ),
        title: const Text('Agent Onboarding', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: StitchColors.onSurface)),
        centerTitle: true,
        actions: const [Padding(padding: EdgeInsets.only(right: 16), child: Icon(Icons.verified_user_outlined, color: StitchColors.secondary, size: 22))],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: StitchColors.surfaceLowest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: StitchColors.slate200),
                boxShadow: const [BoxShadow(color: Color(0x0A0F172A), blurRadius: 4)],
              ),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Text('STEP 1 OF 2', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.8, color: StitchColors.secondary)),
                      SizedBox(width: 6),
                      Icon(Icons.circle, size: 4, color: StitchColors.outlineVariant),
                      SizedBox(width: 6),
                      Text('Personal Details', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: StitchColors.onSurface)),
                      Spacer(),
                      Text('50%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: StitchColors.onSurfaceVariant)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: 0.5,
                      minHeight: 8,
                      backgroundColor: StitchColors.surfaceContainerHigh,
                      valueColor: const AlwaysStoppedAnimation(StitchColors.secondaryContainer),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF0A2540), Color(0xFF004666)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: StitchColors.secondaryContainer.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(999)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.bolt, size: 12, color: StitchColors.tertiaryFixed),
                              SizedBox(width: 4),
                              Text('Fast-Track KYC', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: StitchColors.tertiaryFixed)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text('Create your LG Account', style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
                        const SizedBox(height: 4),
                        const Text('Enter your primary KYC identification details', style: TextStyle(fontSize: 12, color: Color(0xFFB0C8EB))),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: StitchColors.surfaceContainer,
                      border: Border.all(color: Colors.white24),
                      image: const DecorationImage(
                        image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuDjzAkE2xbSqlrtHhbKnhoV11QAToHAjAMRCL_AChj8iaE3402eTH9gBbNq9Wy_NIWkZAxroALkHpSZwnQN5wSYU5udd9ErFYfVTRZaXYaOT8-azyt9EPktwKnweJZu0F8v-2lkQXA2kqsivHGg381hv_0nB6VWNPE4TbGH71jEbDt2s4-sbCkEMvow6rS-NvWDpAIwx87knCgx9PW6Tz1KOtavLBs0zih1Yc_ckb4gICrYoNyryZ5n'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _fieldCard(
              label: 'Full Name (As per PAN card)',
              trailing: _verifiedPill('Verified'),
              child: _inputRow(
                icon: Icons.badge_outlined,
                controller: _name,
                hint: 'Enter legal full name',
                onChanged: (_) => setState(() {}),
                trailing: const Icon(Icons.verified, color: StitchColors.success, size: 20),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: StitchColors.surfaceLowest, borderRadius: BorderRadius.circular(12), border: Border.all(color: StitchColors.slate200)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Text('Mobile Phone Number', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: StitchColors.onSurfaceVariant)),
                      Spacer(),
                      Text('SMS Verification', style: TextStyle(fontSize: 11, color: StitchColors.secondary, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(color: StitchColors.surfaceLow, borderRadius: BorderRadius.circular(8), border: Border.all(color: StitchColors.slate200)),
                          child: Row(
                            children: [
                              const Icon(Icons.smartphone, size: 18, color: StitchColors.secondary),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _phone,
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                                  decoration: const InputDecoration(border: InputBorder.none, hintText: '10-digit number', isDense: true),
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                  onChanged: (_) => setState(() {}),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        height: 36,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(color: StitchColors.surfaceContainerHighest, borderRadius: BorderRadius.circular(8)),
                        child: const Center(child: Text('OTP Sent', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: StitchColors.onSecondaryFixedVariant))),
                      ),
                    ],
                  ),
                  if (_otpSent) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: StitchColors.surfaceLow.withValues(alpha: 0.7), borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Text('Enter 6-digit OTP sent to your mobile', style: TextStyle(fontSize: 11, color: StitchColors.onSurface)),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(color: StitchColors.surfaceLowest, borderRadius: BorderRadius.circular(999), boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 4)]),
                                child: Row(
                                  children: [
                                    const Icon(Icons.check, size: 12, color: StitchColors.success),
                                    const SizedBox(width: 4),
                                    Text(_phoneVerified ? 'Verified ✓' : 'Verify', style: const TextStyle(fontSize: 11, color: StitchColors.success, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(6, (i) {
                              return SizedBox(
                                width: 44,
                                height: 48,
                                child: TextField(
                                  controller: _otpCtrls[i],
                                  focusNode: _otpNodes[i],
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(1)],
                                  style: const TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF001C37)),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: StitchColors.surfaceLowest,
                                    contentPadding: EdgeInsets.zero,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: StitchColors.secondary, width: 1.5)),
                                  ),
                                  onChanged: (v) => _onOtpChanged(v, i),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.schedule, size: 14, color: StitchColors.onSurfaceVariant),
                              const SizedBox(width: 4),
                              Text('Resend OTP in 00:${_resendSec.toString().padLeft(2, '0')}', style: const TextStyle(fontSize: 11, color: StitchColors.onSurfaceVariant)),
                              const Spacer(),
                              GestureDetector(onTap: () => setState(() => _resendSec = 28), child: const Text('Change Number', style: TextStyle(fontSize: 11, color: StitchColors.secondary))),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            _fieldCard(
              label: 'Official Email Address',
              trailing: _verifiedPill('Verified'),
              child: _inputRow(
                icon: Icons.mail_outline,
                controller: _email,
                hint: 'agent.name@domain.com',
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) => setState(() {}),
                trailing: const Icon(Icons.verified, color: StitchColors.success, size: 20),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: StitchColors.surfaceLowest, borderRadius: BorderRadius.circular(12), border: Border.all(color: StitchColors.slate200)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('Permanent Account Number (PAN)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: StitchColors.onSurfaceVariant)),
                      const Spacer(),
                      _verifiedPill('Valid Format'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _inputRow(
                    icon: Icons.credit_card_outlined,
                    controller: _pan,
                    hint: 'ABCDE1234F',
                    textCapitalization: TextCapitalization.characters,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')), LengthLimitingTextInputFormatter(10)],
                    onChanged: (_) => setState(() {}),
                    trailing: const Icon(Icons.check_circle, color: StitchColors.success, size: 20),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Icon(Icons.info_outline, size: 12, color: StitchColors.onSurfaceVariant),
                      SizedBox(width: 4),
                      Text('Format: 5 letters, 4 numbers, 1 letter', style: TextStyle(fontSize: 11, color: StitchColors.onSurfaceVariant)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: StitchColors.surfaceLow, borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: StitchColors.secondaryContainer.withValues(alpha: 0.3), shape: BoxShape.circle),
                    child: const Icon(Icons.lock_outline, size: 20, color: StitchColors.onSecondaryFixedVariant),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('IRDAI Regulatory Protection', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: StitchColors.onSurface)),
                        SizedBox(height: 2),
                        Text('Your identification credentials are encrypted under 256-bit SSL banking standards.', style: TextStyle(fontSize: 12, color: StitchColors.onSurfaceVariant)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: _canProceed ? () => context.go('/register/placeholder') : null,
                style: FilledButton.styleFrom(backgroundColor: StitchColors.primary, disabledBackgroundColor: StitchColors.slate200),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Next — Step 2', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.shield_outlined, size: 14, color: StitchColors.secondary),
                SizedBox(width: 6),
                Text('Your information is encrypted with 256-bit SSL encryption.', style: TextStyle(fontSize: 11, color: StitchColors.onSurfaceVariant)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _fieldCard({required String label, required Widget trailing, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: StitchColors.surfaceLowest, borderRadius: BorderRadius.circular(12), border: Border.all(color: StitchColors.slate200)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: StitchColors.onSurfaceVariant)), const Spacer(), trailing]),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _verifiedPill(String text) {
    return Row(children: [const Icon(Icons.check_circle, size: 14, color: StitchColors.success), const SizedBox(width: 4), Text(text, style: const TextStyle(fontSize: 11, color: StitchColors.success, fontWeight: FontWeight.w500))]);
  }

  Widget _inputRow({required IconData icon, required TextEditingController controller, String? hint, TextInputType? keyboardType, TextCapitalization? textCapitalization, List<TextInputFormatter>? inputFormatters, ValueChanged<String>? onChanged, Widget? trailing}) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: StitchColors.surfaceLow, borderRadius: BorderRadius.circular(8), border: Border.all(color: StitchColors.slate200)),
      child: Row(
        children: [
          Icon(icon, size: 18, color: StitchColors.secondary),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              textCapitalization: textCapitalization ?? TextCapitalization.none,
              inputFormatters: inputFormatters,
              onChanged: onChanged,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: StitchColors.onSurface),
              decoration: InputDecoration(border: InputBorder.none, hintText: hint, hintStyle: const TextStyle(color: StitchColors.outline, fontSize: 14), isDense: true),
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }
}
