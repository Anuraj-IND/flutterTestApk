import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme.dart';

class LoginScreen extends StatefulWidget {
  final dynamic repository;
  final dynamic authState;
  const LoginScreen({super.key, this.repository, this.authState});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phone = TextEditingController();
  final _otp = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _phone.dispose();
    _otp.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StitchColors.surface,
      appBar: AppBar(backgroundColor: StitchColors.surface, elevation: 0, leading: IconButton(icon: const Icon(Icons.arrow_back, color: StitchColors.onSurface), onPressed: () => context.go('/welcome'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: StitchColors.surfaceLowest, borderRadius: BorderRadius.circular(16), border: Border.all(color: StitchColors.slate200)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Agent Login', style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 20, fontWeight: FontWeight.w700, color: StitchColors.primary)),
                  const SizedBox(height: 4),
                  const Text('Enter your registered mobile number', style: TextStyle(fontSize: 12, color: StitchColors.onSurfaceVariant)),
                  const SizedBox(height: 16),
                  const Text('Mobile Number', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: StitchColors.onSurfaceVariant)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(color: StitchColors.surfaceLow, borderRadius: BorderRadius.circular(8), border: Border.all(color: StitchColors.slate200)),
                          child: Row(children: [const Icon(Icons.smartphone, size: 18, color: StitchColors.secondary), const SizedBox(width: 8), Expanded(child: TextField(controller: _phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(border: InputBorder.none, hintText: '10-digit number', isDense: true)))]),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        height: 48,
                        child: FilledButton(onPressed: () => setState(() => _sent = true), style: FilledButton.styleFrom(backgroundColor: StitchColors.primary), child: Text(_sent ? 'Resend' : 'Send OTP')),
                      ),
                    ],
                  ),
                  if (_sent) ...[
                    const SizedBox(height: 12),
                    const Text('OTP', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: StitchColors.onSurfaceVariant)),
                    const SizedBox(height: 6),
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(color: StitchColors.surfaceLow, borderRadius: BorderRadius.circular(8), border: Border.all(color: StitchColors.slate200)),
                      child: Row(children: [const Icon(Icons.lock_outline, size: 18, color: StitchColors.secondary), const SizedBox(width: 8), Expanded(child: TextField(controller: _otp, decoration: const InputDecoration(border: InputBorder.none, hintText: '123456', isDense: true)))]),
                    ),
                  ],
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: _sent && _otp.text.length == 6 || !_sent && _phone.text.length == 10 ? () => context.go('/dashboard') : null,
                      style: FilledButton.styleFrom(backgroundColor: StitchColors.primary),
                      child: const Text('Log In'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextButton(onPressed: () => context.go('/register'), child: const Text('New here? Register', style: TextStyle(color: StitchColors.secondary))),
          ],
        ),
      ),
    );
  }
}
