import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme.dart';
import '../../../core/validators.dart';
import '../../../shared/widgets/feedback.dart';
import '../data/covermint_repository.dart';

class Step1Screen extends StatefulWidget {
  final CovermintRepository repository;

  const Step1Screen({super.key, required this.repository});

  @override
  State<Step1Screen> createState() => _Step1ScreenState();
}

class _Step1ScreenState extends State<Step1Screen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _pan = TextEditingController();
  final _otp = TextEditingController();

  bool _otpSent = false;
  bool _otpVerified = false;
  bool _busy = false;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    _pan.dispose();
    _otp.dispose();
    super.dispose();
  }

  bool get _formValid =>
      Validators.name(_name.text) == null &&
      Validators.phone(_phone.text) == null &&
      Validators.email(_email.text) == null &&
      Validators.pan(_pan.text) == null;

  Future<void> _sendOtp() async {
    if (Validators.phone(_phone.text) != null) {
      showOk(context, 'Enter a valid 10-digit mobile number first.');
      return;
    }
    setState(() => _busy = true);
    try {
      await widget.repository.otpSend(phone: _phone.text, purpose: 'register');
      if (mounted) {
        setState(() {
          _otpSent = true;
          _otpVerified = false;
        });
        showOk(context, 'OTP sent. Dev mode OTP is 123456.');
      }
    } catch (e) {
      if (mounted) showApiError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _verifyOtp() async {
    if (_otp.text.trim().isEmpty) {
      showOk(context, 'Enter the OTP first.');
      return;
    }
    setState(() => _busy = true);
    try {
      await widget.repository.otpVerify(
        phone: _phone.text,
        otp: _otp.text,
        purpose: 'register',
      );
      if (mounted) {
        setState(() => _otpVerified = true);
        showOk(context, 'Phone verified.');
      }
    } catch (e) {
      if (mounted) showApiError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _next() async {
    if (!_formValid || !_otpVerified) return;
    setState(() => _busy = true);
    try {
      final draftId = await widget.repository.registerInit(
        name: _name.text,
        phone: _phone.text,
        email: _email.text,
        panNo: _pan.text,
      );
      if (mounted) context.go('/register/$draftId');
    } catch (e) {
      if (mounted) showApiError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canProceed = _formValid && _otpVerified && !_busy;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Registration'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: CovermintTheme.heroGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              onChanged: () => setState(() {}),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStepIndicator(1, 2),
                  const SizedBox(height: 24),
                  _buildGlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Personal Information'),
                        const SizedBox(height: 16),
                        _buildAnimatedField(
                          delay: 0,
                          child: _buildTextField(
                            controller: _name,
                            label: 'Full Name',
                            icon: Icons.person_outline,
                            textCapitalization: TextCapitalization.words,
                            validator: Validators.name,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildAnimatedField(
                          delay: 100,
                          child: _buildPhoneRow(),
                        ),
                        if (_otpSent) ...[
                          const SizedBox(height: 12),
                          _buildAnimatedField(
                            delay: 150,
                            child: _buildOtpRow(),
                          ),
                        ],
                        if (_otpVerified) ...[
                          const SizedBox(height: 8),
                          _buildVerifiedBadge(),
                        ],
                        const SizedBox(height: 12),
                        _buildAnimatedField(
                          delay: 200,
                          child: _buildTextField(
                            controller: _email,
                            label: 'Email Address',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: Validators.email,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildAnimatedField(
                          delay: 300,
                          child: _buildTextField(
                            controller: _pan,
                            label: 'PAN Number',
                            icon: Icons.credit_card,
                            textCapitalization: TextCapitalization.characters,
                            validator: Validators.pan,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[A-Za-z0-9]')),
                              LengthLimitingTextInputFormatter(10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildNextButton(canProceed),
                  const SizedBox(height: 12),
                  Center(
                    child: TextButton(
                      onPressed: _busy ? null : () => context.go('/login'),
                      child: Text(
                        'Already registered? Log in',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int current, int total) {
    return Row(
      children: List.generate(total, (i) {
        final isActive = i < current;
        final isCurrent = i == current - 1;
        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 5,
            decoration: BoxDecoration(
              color: isActive
                  ? CovermintTheme.brandAccent
                  : Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        );
      }),
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: CovermintTheme.brandDark,
      ),
    );
  }

  Widget _buildAnimatedField({required int delay, required Widget child}) {
    return AnimatedOpacity(
      opacity: 1,
      duration: Duration(milliseconds: 400 + delay),
      child: child,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hintText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    TextCapitalization? textCapitalization,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(icon, size: 20),
      ),
      keyboardType: keyboardType,
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      inputFormatters: inputFormatters,
      validator: validator,
      style: const TextStyle(fontSize: 15),
    );
  }

  Widget _buildPhoneRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextFormField(
            controller: _phone,
            decoration: const InputDecoration(
              labelText: 'Mobile Number',
              hintText: '10-digit, starts 6-9',
              prefixIcon: Icon(Icons.phone_outlined, size: 20),
            ),
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            validator: Validators.phone,
            onChanged: (_) {
              if (_otpSent) {
                setState(() {
                  _otpSent = false;
                  _otpVerified = false;
                });
              }
            },
          ),
        ),
        const SizedBox(width: 8),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: FilledButton.icon(
            onPressed: _busy ? null : _sendOtp,
            icon: Icon(_otpSent ? Icons.refresh : Icons.send, size: 18),
            label: Text(_otpSent ? 'Resend' : 'Send OTP'),
            style: FilledButton.styleFrom(
              minimumSize: const Size(0, 52),
              backgroundColor:
                  _otpSent ? CovermintTheme.brandAccent : CovermintTheme.brandPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOtpRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextField(
            controller: _otp,
            decoration: const InputDecoration(
              labelText: 'Enter OTP',
              hintText: 'Dev OTP: 123456',
              prefixIcon: Icon(Icons.lock_outline, size: 20),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: FilledButton.icon(
            onPressed: _busy ? null : _verifyOtp,
            icon: const Icon(Icons.check, size: 18),
            label: const Text('Verify'),
            style: FilledButton.styleFrom(
              minimumSize: const Size(0, 52),
              backgroundColor: CovermintTheme.approvedGreen,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVerifiedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: CovermintTheme.approvedGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: CovermintTheme.approvedGreen.withValues(alpha: 0.3),
        ),
      ),
      child: const Row(
        children: [
          Icon(Icons.check_circle, color: CovermintTheme.approvedGreen, size: 18),
          SizedBox(width: 8),
          Text(
            'Phone verified',
            style: TextStyle(
              color: CovermintTheme.approvedGreen,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton(bool canProceed) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton.icon(
        onPressed: canProceed ? _next : null,
        icon: _busy
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.arrow_forward),
        label: Text(_busy ? 'Processing...' : 'Continue to Step 2'),
        style: FilledButton.styleFrom(
          backgroundColor: canProceed
              ? CovermintTheme.brandAccent
              : Colors.grey.shade400,
          disabledBackgroundColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
