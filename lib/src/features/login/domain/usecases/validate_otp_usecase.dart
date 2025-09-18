import 'package:time_planner/src/core/utils/result.dart';
import 'package:time_planner/src/features/login/domain/repositories/i_login_repository.dart';

class ValidateOtpUseCase {
  final ILoginRepository _repository;
  ValidateOtpUseCase({required ILoginRepository repository}) : _repository = repository;

  Future<Result<String>> call({required String identifier, required String otp}) async {
    return await _repository.validateOtp(identifier, otp);
  }
}