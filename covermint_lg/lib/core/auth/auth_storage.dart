import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure persistence for the LG JWT session.
class AuthStorage {
  static const String kTokenKey = 'kSecuredLGToken';
  static const String kLgSeqKey = 'kSecuredLGLgSeq';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveSession({required String token, required int lgSeq}) async {
    await _storage.write(key: kTokenKey, value: token);
    await _storage.write(key: kLgSeqKey, value: lgSeq.toString());
  }

  Future<String?> readToken() => _storage.read(key: kTokenKey);

  Future<int?> readLgSeq() async {
    final raw = await _storage.read(key: kLgSeqKey);
    return raw == null ? null : int.tryParse(raw);
  }

  Future<void> clear() async {
    await _storage.delete(key: kTokenKey);
    await _storage.delete(key: kLgSeqKey);
  }
}
