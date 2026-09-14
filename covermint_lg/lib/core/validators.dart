import 'package:flutter/foundation.dart';

class Validators {
  static final RegExp phoneRe = RegExp(r'^[6-9]\d{9}$');
  static final RegExp panRe = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$');
  static final RegExp emailRe = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  static final RegExp pincodeRe = RegExp(r'^[1-9][0-9]{5}$');
  static final RegExp ifscRe = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');

  static bool get isDevMode => kDebugMode;

  static String? name(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Name is required' : null;

  static String? phone(String? v) =>
      (v != null && phoneRe.hasMatch(v.trim()))
          ? null
          : 'Enter a valid 10-digit mobile number';

  static String? email(String? v) =>
      (v != null && emailRe.hasMatch(v.trim()))
          ? null
          : 'Enter a valid email address';

  static String? pan(String? v) =>
      (v != null && panRe.hasMatch(v.trim().toUpperCase()))
          ? null
          : 'PAN format: ABCDE1234F';

  static String? pincode(String? v) =>
      (v != null && pincodeRe.hasMatch(v.trim()))
          ? null
          : 'Enter a valid 6-digit pincode';

  static String? ifsc(String? v) {
    if (v == null || v.trim().isEmpty) return 'IFSC is required';
    final upper = v.trim().toUpperCase();
    if (ifscRe.hasMatch(upper)) return null;
    if (isDevMode && upper.startsWith('TEST') && upper.length >= 6) return null;
    return 'IFSC format: ABCD0123456';
  }

  static String? required(String? v, [String label = 'This field']) =>
      (v == null || v.trim().isEmpty) ? '$label is required' : null;

  static const int maxFileBytes = 5 * 1024 * 1024;
}
