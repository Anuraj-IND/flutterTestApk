import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme.dart';
import '../../core/validators.dart';

class IfscField extends StatefulWidget {
  final TextEditingController controller;
  final Future<void> Function(String ifsc) onVerify;
  final bool verifying;
  final bool? valid;
  final String? message;

  const IfscField({
    super.key,
    required this.controller,
    required this.onVerify,
    this.verifying = false,
    this.valid,
    this.message,
  });

  @override
  State<IfscField> createState() => _IfscFieldState();
}

class _IfscFieldState extends State<IfscField> {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    final ifsc = value.trim().toUpperCase();
    if (RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$').hasMatch(ifsc)) {
      _debounce = Timer(const Duration(milliseconds: 600), () {
        widget.onVerify(ifsc);
      });
    } else if (Validators.isDevMode &&
        ifsc.startsWith('TEST') &&
        ifsc.length >= 6) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ifsc = widget.controller.text.trim().toUpperCase();
    final isDevTest =
        Validators.isDevMode && ifsc.startsWith('TEST') && ifsc.length >= 6;

    Color? suffixColor;
    IconData? suffixIcon;

    if (widget.verifying) {
      suffixIcon = null;
    } else if (widget.valid == true || isDevTest) {
      suffixColor = CovermintTheme.approvedGreen;
      suffixIcon = Icons.check_circle;
    } else if (widget.valid == false) {
      suffixColor = scheme.error;
      suffixIcon = Icons.error;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.controller,
          decoration: InputDecoration(
            labelText: 'IFSC *',
            hintText: 'ABCD0123456',
            prefixIcon: const Icon(Icons.account_balance, size: 20),
            suffixIcon: widget.verifying
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : (suffixIcon == null
                    ? null
                    : Icon(suffixIcon, color: suffixColor)),
          ),
          textCapitalization: TextCapitalization.characters,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
            LengthLimitingTextInputFormatter(11),
          ],
          onChanged: _onChanged,
        ),
        if (widget.message != null) ...[
          const SizedBox(height: 4),
          Text(
            widget.message!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: widget.valid == true
                      ? CovermintTheme.approvedGreen
                      : scheme.error,
                ),
          ),
        ],
        if (isDevTest && widget.message == null) ...[
          const SizedBox(height: 4),
          Text(
            'Dev mode: TEST IFSC accepted',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: CovermintTheme.pendingAmber,
                  fontStyle: FontStyle.italic,
                ),
          ),
        ],
      ],
    );
  }
}
