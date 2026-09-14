import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme.dart';
import '../../../core/auth/auth_state.dart';
import '../../../core/validators.dart';
import '../../../shared/widgets/feedback.dart';
import '../../register/data/covermint_repository.dart';

class LoginScreen extends StatefulWidget {
  final CovermintRepository repository;
  final AuthState authState;

  const LoginScreen({
    super.key,
    required this.repository,
    required this.authState,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _phone = TextEditingController();
  final _otp = TextEditingController();
  bool _otpSent = false;
  bool _busy = false;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));
    _animController.forward();
  }

  @override
  void dispose() {
    _phone.dispose();
    _otp.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (Validators.phone(_phone.text) != null) {
      showOk(context, 'Enter a valid 10-digit mobile number first.');
      return;
    }
    setState(() => _busy = true);
    try {
      await widget.repository.otpSend(phone: _phone.text, purpose: 'login');
      if (mounted) {
        setState(() => _otpSent = true);
        showOk(context, 'OTP sent. Dev mode OTP is 123456.');
      }
    } catch (e) {
      if (mounted) showApiError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _login() async {
    if (_otp.text.trim().isEmpty) {
      showOk(context, 'Enter the OTP first.');
      return;
    }
    setState(() => _busy = true);
    try {
      final res = await widget.repository.loginVerify(
        phone: _phone.text,
        otp: _otp.text,
      );
      final token = res['token'] as String?;
      final seq = res['lg_seq'];
      if (token == null || token.isEmpty || seq is! int) {
        throw Exception('Unexpected login response.');
      }
      await widget.authState.login(token: token, lgSeq: seq);
    } catch (e) {
      if (mounted) showApiError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        decoration: const BoxDecoration(
          gradient: CovermintTheme.heroGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: Column(
                  children: [
                    SizedBox(height: size.height * 0.08),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shield_outlined,
                        size: 64,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Covermint',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Lead Generator Portal',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 48),
                    _buildGlassCard(
                      child: Column(
                        children: [
                          _buildPhoneField(),
                          const SizedBox(height: 16),
                          if (_otpSent) ...[
                            _buildOtpField(),
                            const SizedBox(height: 16),
                          ],
                          _buildLoginButton(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: _busy ? null : () => context.go('/register'),
                      child: Text(
                        'New here? Register',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mobile Number',
          style: TextStyle(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                controller: _phone,
                decoration: InputDecoration(
                  hintText: '10-digit number',
                  prefixIcon: const Icon(Icons.phone_outlined, size: 20),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
                keyboardType: TextInputType.phone,
                style: const TextStyle(fontSize: 16, letterSpacing: 1.5),
                onChanged: (_) {
                  if (_otpSent) setState(() => _otpSent = false);
                },
              ),
            ),
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                child: FilledButton(
                  onPressed: _busy ? null : _sendOtp,
                  style: FilledButton.styleFrom(
                    backgroundColor: _otpSent
                        ? CovermintTheme.brandAccent
                        : CovermintTheme.brandPrimary,
                    minimumSize: const Size(0, 52),
                  ),
                  child: _busy
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          _otpSent ? 'Resend' : 'Send OTP',
                          style: const TextStyle(fontSize: 13),
                        ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOtpField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'OTP Verification',
          style: TextStyle(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _otp,
          decoration: InputDecoration(
            hintText: 'Dev OTP: 123456',
            prefixIcon: const Icon(Icons.lock_outline, size: 20),
            filled: true,
            fillColor: Colors.grey.shade50,
            suffixIcon: TextButton(
              onPressed: _busy ? null : _login,
              child: const Text('Verify'),
            ),
          ),
          keyboardType: TextInputType.number,
          style: const TextStyle(fontSize: 18, letterSpacing: 8),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
        onPressed: (_otpSent && !_busy) ? _login : null,
        style: FilledButton.styleFrom(
          backgroundColor: CovermintTheme.brandPrimary,
          disabledBackgroundColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _busy
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : const Text(
                'Log In',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }
}
