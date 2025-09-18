// lib/src/core/di/core_module.dart
import 'package:get_it/get_it.dart';
import 'package:time_planner/src/core/data/local/app_database.dart';

final sl = GetIt.instance;

void setupCore() {
  sl.registerLazySingleton<AppDatabase>(() => AppDatabase());
}