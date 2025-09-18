import 'package:time_planner/src/core/data/local/app_database.dart';
import 'package:time_planner/src/features/planner/domain/repositories/i_planner_repository.dart';

class UpdateActivityUseCase {
  final IPlannerRepository _repository;

  UpdateActivityUseCase({required IPlannerRepository repository}) : _repository = repository;

  Future<void> call(ActivitiesCompanion activity) {
    return _repository.updateActivity(activity);
  }
}