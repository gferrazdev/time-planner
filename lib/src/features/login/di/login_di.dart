import 'package:get_it/get_it.dart';
import 'package:time_planner/src/features/login/data/datasources/login_local_datasource_impl.dart';
import 'package:time_planner/src/features/login/data/repositories/login_repository_impl.dart';
import 'package:time_planner/src/features/login/domain/datasources/i_login_datasource.dart';
import 'package:time_planner/src/features/login/domain/repositories/i_login_repository.dart';
import 'package:time_planner/src/features/login/domain/usecases/request_otp_usecase.dart';
import 'package:time_planner/src/features/login/domain/usecases/validate_otp_usecase.dart';
import 'package:time_planner/src/features/login/presentation/login_view_model.dart';

final sl = GetIt.instance;

void setupLogin() {
  sl.registerLazySingleton<ILoginDataSource>(() => LoginLocalDataSourceImpl());
  sl.registerLazySingleton<ILoginRepository>(() => LoginRepositoryImpl(dataSource: sl()));
  sl.registerLazySingleton<RequestOtpUseCase>(() => RequestOtpUseCase(repository: sl()));
  sl.registerLazySingleton<ValidateOtpUseCase>(() => ValidateOtpUseCase(repository: sl()));
  sl.registerFactory<LoginViewModel>(() => LoginViewModel(requestOtpUseCase: sl(), validateOtpUseCase: sl()));
}