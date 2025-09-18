import 'package:time_planner/src/core/exceptions/app_exception.dart';
import 'package:time_planner/src/core/utils/result.dart';
import 'package:time_planner/src/features/login/domain/datasources/i_login_datasource.dart';
import 'package:time_planner/src/features/login/domain/repositories/i_login_repository.dart';

class LoginRepositoryImpl implements ILoginRepository {
  final ILoginDataSource _dataSource;
  LoginRepositoryImpl({required ILoginDataSource dataSource}) : _dataSource = dataSource;

  @override
  Future<Result<void>> requestOtp(String identifier) async {
    try {
      await _dataSource.requestOtp(identifier);
      return Result.success(null);
    } on AppException catch (e) {
      return Result.failure(e.message, errorCode: e.errorCode);
    }
  }

  @override
  Future<Result<String>> validateOtp(String identifier, String otp) async {
    try {
      final token = await _dataSource.validateOtp(identifier, otp);
      return Result.success(token);
    } on AppException catch (e) {
      return Result.failure(e.message, errorCode: e.errorCode);
    }
  }
}