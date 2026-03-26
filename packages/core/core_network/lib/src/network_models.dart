import 'package:meta/meta.dart';

@immutable
class NetworkRequest {
  const NetworkRequest({
    required this.path,
    this.method = 'GET',
    this.query = const {},
    this.headers = const {},
    this.body,
  });

  final String path;
  final String method;
  final Map<String, String> query;
  final Map<String, String> headers;
  final Object? body;
}

@immutable
class NetworkResponse {
  const NetworkResponse({
    required this.statusCode,
    this.body,
    this.headers = const {},
  });

  final int statusCode;
  final Object? body;
  final Map<String, String> headers;
}

class NetworkException implements Exception {
  const NetworkException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'NetworkException(statusCode: $statusCode, message: $message)';
}
