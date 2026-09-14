import 'package:dio/dio.dart';

import '../../../core/api/api_config.dart';
import '../../../core/api/api_exception.dart';

/// All backend calls for the LG app. Throws [ApiException] on failure so
/// screens can surface the server `{error}` directly.
class CovermintRepository {
  final Dio _dio;

  CovermintRepository(this._dio);

  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      throw toApiException(e);
    }
  }

  // ---------- Registration step 1 ----------

  /// Returns `draft_id`. 409 when PAN/phone already registered.
  Future<String> registerInit({
    required String name,
    required String phone,
    required String email,
    required String panNo,
  }) {
    return _guard(() async {
      final res = await _dio.post(ApiConfig.registerInit, data: {
        'name': name.trim(),
        'phone': phone.trim(),
        'email': email.trim(),
        'pan_no': panNo.trim().toUpperCase(),
      });
      return res.data['draft_id'] as String;
    });
  }

  Future<void> otpSend({required String phone, required String purpose}) {
    return _guard(() async {
      await _dio.post(ApiConfig.otpSend, data: {
        'phone': phone.trim(),
        'purpose': purpose,
      });
    });
  }

  Future<void> otpVerify({
    required String phone,
    required String otp,
    required String purpose,
  }) {
    return _guard(() async {
      await _dio.post(ApiConfig.otpVerify, data: {
        'phone': phone.trim(),
        'otp': otp.trim(),
        'purpose': purpose,
      });
    });
  }

  // ---------- Registration step 2 ----------

  Future<Map<String, dynamic>> getDraft(String draftId) {
    return _guard(() async {
      final res = await _dio.get(ApiConfig.registerDraft(draftId));
      return Map<String, dynamic>.from(res.data as Map);
    });
  }

  Future<void> patchDraft(String draftId, Map<String, dynamic> body) {
    return _guard(() async {
      await _dio.patch(ApiConfig.registerDraft(draftId), data: body);
    });
  }

  Future<Map<String, dynamic>> verifyIfsc(String ifsc) {
    return _guard(() async {
      final res = await _dio.post(ApiConfig.ifscVerify, data: {
        'ifsc': ifsc.trim().toUpperCase(),
      });
      return Map<String, dynamic>.from(res.data as Map);
    });
  }

  /// Uploads whichever of the 4 doc files are provided (server versions them).
  /// Keys: aadhaar_front, aadhaar_back, pan_card, cheque.
  Future<void> uploadDocs(String draftId, Map<String, String> pathsByField) {
    return _guard(() async {
      final form = FormData();
      for (final entry in pathsByField.entries) {
        form.files.add(
          MapEntry(
            entry.key,
            await MultipartFile.fromFile(entry.value),
          ),
        );
      }
      await _dio.post(
        ApiConfig.registerDocs(draftId),
        data: form,
        options: Options(contentType: 'multipart/form-data'),
      );
    });
  }

  Future<Map<String, dynamic>> getTos() {
    return _guard(() async {
      final res = await _dio.get(ApiConfig.tosLatest);
      return Map<String, dynamic>.from(res.data as Map);
    });
  }

  Future<void> tosAccept({
    required String draftId,
    required String name,
    required String tosVersion,
  }) {
    return _guard(() async {
      await _dio.post(ApiConfig.tosAccept(draftId), data: {
        'name': name,
        'tos_version': tosVersion,
        'scrolled_complete': true,
      });
    });
  }

  /// Returns `{lg_id, lg_seq, verification_status}`. 400 with a gate message
  /// when anything is missing.
  Future<Map<String, dynamic>> submit(String draftId) {
    return _guard(() async {
      final res = await _dio.post(ApiConfig.registerSubmit(draftId));
      return Map<String, dynamic>.from(res.data as Map);
    });
  }

  // ---------- Login + dashboard ----------

  /// Returns `{token, lg_seq, id}`.
  Future<Map<String, dynamic>> loginVerify({
    required String phone,
    required String otp,
  }) {
    return _guard(() async {
      final res = await _dio.post(ApiConfig.loginVerify, data: {
        'phone': phone.trim(),
        'otp': otp.trim(),
      });
      return Map<String, dynamic>.from(res.data as Map);
    });
  }

  Future<Map<String, dynamic>> getDashboard() {
    return _guard(() async {
      final res = await _dio.get(ApiConfig.dashboard);
      return Map<String, dynamic>.from(res.data as Map);
    });
  }

  // ---------- Sell hub + bottom-nav tabs ----------

  Future<List<Map<String, dynamic>>> getCatalog() {
    return _guard(() async {
      final res = await _dio.get(ApiConfig.catalog);
      final data = res.data;
      final list = data is List
          ? data
          : (data is Map && data['data'] is List
              ? data['data'] as List
              : const []);
      return list
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    });
  }

  /// Returns the created intent row (shows its `id` in a snackbar).
  Future<Map<String, dynamic>> postIntent({
    required String category,
    Map<String, dynamic> payload = const {},
  }) {
    return _guard(() async {
      final res = await _dio.post(ApiConfig.policyIntent, data: {
        'category': category,
        'payload': payload,
      });
      final data = res.data;
      return data is Map ? Map<String, dynamic>.from(data) : {'id': '?'};
    });
  }

  Future<Map<String, dynamic>> getLeads() {
    return _guard(() async {
      final res = await _dio.get(ApiConfig.leads);
      final data = res.data;
      return data is Map
          ? Map<String, dynamic>.from(data)
          : {'data': [], 'page': 1, 'total': 0};
    });
  }

  Future<Map<String, dynamic>> getRenewals() {
    return _guard(() async {
      final res = await _dio.get(ApiConfig.renewals);
      final data = res.data;
      return data is Map
          ? Map<String, dynamic>.from(data)
          : {
              'data': [],
              'buckets': {'d30': 0, 'd60': 0, 'd90': 0},
            };
    });
  }

  Future<Map<String, dynamic>> getPerformance() {
    return _guard(() async {
      final res = await _dio.get(ApiConfig.performance);
      final data = res.data;
      return data is Map
          ? Map<String, dynamic>.from(data)
          : {
              'leads_generated': 0,
              'conversion_pct': 0,
              'commission_earned': 0,
            };
    });
  }
}
