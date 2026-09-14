import 'package:flutter/foundation.dart';

import 'auth_storage.dart';

/// In-memory session + go_router refresh signal.
class AuthState extends ChangeNotifier {
  final AuthStorage _storage;

  String? _token;
  int? _lgSeq;
  bool _ready = false;

  AuthState(this._storage);

  bool get isAuthed => _token != null;
  bool get isReady => _ready;
  String? get token => _token;
  int? get lgSeq => _lgSeq;

  Future<void> restore() async {
    _token = await _storage.readToken();
    _lgSeq = await _storage.readLgSeq();
    _ready = true;
    notifyListeners();
  }

  Future<void> login({required String token, required int lgSeq}) async {
    await _storage.saveSession(token: token, lgSeq: lgSeq);
    _token = token;
    _lgSeq = lgSeq;
    notifyListeners();
  }

  Future<void> logout() async {
    await _storage.clear();
    _token = null;
    _lgSeq = null;
    notifyListeners();
  }
}
