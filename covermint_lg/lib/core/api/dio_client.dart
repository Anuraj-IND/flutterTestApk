import 'package:dio/dio.dart';

import '../auth/auth_state.dart';
import 'api_config.dart';

/// Shared Dio instance: attaches `Authorization: Bearer <token>`,
/// auto-logs-out on 401 so the router guard bounces to /login.
class DioClient {
  final Dio dio;

  DioClient(AuthState authState)
      : dio = Dio(
          BaseOptions(
            baseUrl: ApiConfig.baseUrl,
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            headers: {'Content-Type': 'application/json'},
          ),
        ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = authState.token;
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (e, handler) async {
          if (e.response?.statusCode == 401 && authState.isAuthed) {
            await authState.logout();
          }
          handler.next(e);
        },
      ),
    );
  }
}
