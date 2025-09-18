import 'package:time_planner/src/core/exceptions/app_exception.dart';

class IdentifierNotFoundException implements AppException {
  @override
  final String message;
  @override
  final dynamic errorCode;
  const IdentifierNotFoundException(this.message, {this.errorCode});
}

class InvalidOtpException implements AppException {
  @override
  final String message;
  @override
  final dynamic errorCode;
  const InvalidOtpException(this.message, {this.errorCode});
}