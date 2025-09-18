import 'package:time_planner/src/core/utils/result.dart';

abstract interface class ILoginRepository {
  Future<Result<void>> requestOtp(String identifier);
  Future<Result<String>> validateOtp(String identifier, String otp);
}