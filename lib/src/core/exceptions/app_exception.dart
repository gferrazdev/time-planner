// lib/src/core/exceptions/app_exception.dart
abstract class AppException implements Exception {
  final String message;
  final dynamic errorCode;
  const AppException({required this.message, this.errorCode});
  @override
  String toString() => 'AppException(message: $message, errorCode: $errorCode)';
}