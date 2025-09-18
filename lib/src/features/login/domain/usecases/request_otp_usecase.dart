import 'package:time_planner/src/core/utils/result.dart';
import 'package:time_planner/src/features/login/domain/repositories/i_login_repository.dart';

class RequestOtpUseCase {
  final ILoginRepository _repository;
  RequestOtpUseCase({required ILoginRepository repository}) : _repository = repository;

  Future<Result<void>> call(String identifier) async {
    return await _repository.requestOtp(identifier);
  }
}