import 'package:flutter/material.dart';
import 'package:time_planner/src/features/login/domain/datasources/i_login_datasource.dart';
import 'package:time_planner/src/features/login/domain/exceptions/login_exceptions.dart';

class LoginLocalDataSourceImpl implements ILoginDataSource {
  static const String _validIdentifier = 'teste@email.com';
  static const String _validOtp = '1234';

  @override
  Future<void> requestOtp(String identifier) async {
    await Future.delayed(const Duration(seconds: 1));
    if (identifier.toLowerCase() == _validIdentifier) {
      debugPrint('SIMULAÇÃO: Código OTP "$_validOtp" enviado para $identifier');
      return;
    } else {
      throw const IdentifierNotFoundException('Usuário não encontrado.', errorCode: 404);
    }
  }

  @override
  Future<String> validateOtp(String identifier, String otp) async {
    await Future.delayed(const Duration(seconds: 1));
    if (identifier.toLowerCase() == _validIdentifier && otp == _validOtp) {
      debugPrint('SIMULAÇÃO: OTP validado com sucesso!');
      return 'mock_auth_token_for_${identifier}_at_${DateTime.now().toIso8601String()}';
    } else {
      throw const InvalidOtpException('Código OTP inválido.', errorCode: 401);
    }
  }
}