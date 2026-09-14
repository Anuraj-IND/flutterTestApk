import 'package:dio/dio.dart';

/// Backend error shape is `{error: string}`. This normalizes Dio failures
/// into that message so screens can surface it directly.
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

ApiException toApiException(DioException e) {
  final data = e.response?.data;
  if (data is Map && data['error'] is String) {
    return ApiException(data['error'] as String, e.response?.statusCode);
  }
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return ApiException(
        'Request timed out. Check your connection and retry.',
        e.response?.statusCode,
      );
    case DioExceptionType.connectionError:
      return ApiException(
        'Cannot reach the server. Check your connection and retry.',
        e.response?.statusCode,
      );
    case DioExceptionType.badResponse:
      return ApiException(
        'Server error (${e.response?.statusCode ?? '?'}). Retry in a bit.',
        e.response?.statusCode,
      );
    default:
      return ApiException('Something went wrong. Please retry.', null);
  }
}
