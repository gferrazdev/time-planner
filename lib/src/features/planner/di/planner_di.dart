import 'package:get_it/get_it.dart';
import 'package:time_planner/src/core/data/local/app_database.dart';
import 'package:time_planner/src/features/planner/data/repositories/planner_repository_impl.dart';
import 'package:time_planner/src/features/planner/domain/repositories/i_planner_repository.dart';
import 'package:time_planner/src/features/planner/domain/usecases/add_activity_usecase.dart';
import 'package:time_planner/src/features/planner/domain/usecases/delete_activity_usecase.dart';
import 'package:time_planner/src/features/planner/domain/usecases/get_activities_usecase.dart';
import 'package:time_planner/src/features/planner/domain/usecases/update_activity_usecase.dart';
import 'package:time_planner/src/features/planner/presentation/planner_view_model.dart';

final sl = GetIt.instance;

void setupPlanner() {
  sl.registerFactory<ActivitiesDao>(() => sl<AppDatabase>().activitiesDao);
  sl.registerLazySingleton<IPlannerRepository>(
    () => PlannerRepositoryImpl(activitiesDao: sl<ActivitiesDao>()),
  );
  sl.registerLazySingleton<GetActivitiesUseCase>(
    () => GetActivitiesUseCase(repository: sl<IPlannerRepository>()),
  );
  sl.registerLazySingleton<AddActivityUseCase>(
    () => AddActivityUseCase(repository: sl<IPlannerRepository>()),
  );
  sl.registerLazySingleton<DeleteActivityUseCase>(
    () => DeleteActivityUseCase(repository: sl<IPlannerRepository>()),
  );
  sl.registerLazySingleton<UpdateActivityUseCase>(
    () => UpdateActivityUseCase(repository: sl<IPlannerRepository>()),
  );
  sl.registerFactory<PlannerViewModel>(
    () => PlannerViewModel(
      getActivitiesUseCase: sl(),
      deleteActivityUseCase: sl(),
      updateActivityUseCase: sl(),
      addActivityUseCase: sl(),
    ),
  );
}