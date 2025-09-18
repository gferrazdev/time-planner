import 'package:flutter/material.dart';
import 'package:time_planner/src/features/login/domain/usecases/request_otp_usecase.dart';
import 'package:time_planner/src/features/login/domain/usecases/validate_otp_usecase.dart';

class LoginViewModel extends ChangeNotifier {
  final RequestOtpUseCase _requestOtpUseCase;
  final ValidateOtpUseCase _validateOtpUseCase;

  LoginViewModel({
    required RequestOtpUseCase requestOtpUseCase,
    required ValidateOtpUseCase validateOtpUseCase,
  })  : _requestOtpUseCase = requestOtpUseCase,
        _validateOtpUseCase = validateOtpUseCase;

  final identifierController = TextEditingController();
  final otpController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _showOtpFields = false;
  bool get showOtpFields => _showOtpFields;

  bool _loginSuccess = false;
  bool get loginSuccess => _loginSuccess;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> requestOtp() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _requestOtpUseCase(identifierController.text);

    result.when(
      success: (_) {
        _showOtpFields = true;
      },
      failure: (message, errorCode) {
        _errorMessage = message;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> validateOtp() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _validateOtpUseCase(
      identifier: identifierController.text,
      otp: otpController.text,
    );
     result.when(
      success: (token) {
        _loginSuccess = true;     
        debugPrint('Login bem-sucedido! Token: $token');
      },
      failure: (message, errorCode) {
        _errorMessage = message;
        otpController.clear();
      },
    );

    _isLoading = false;
    notifyListeners();
  }
  
  @override
  void dispose() {
    identifierController.dispose();
    otpController.dispose();
    super.dispose();
  }
}