import 'package:time_planner/src/core/data/local/app_database.dart';
import 'package:time_planner/src/features/planner/domain/repositories/i_planner_repository.dart';

class AddActivityUseCase {
  final IPlannerRepository _repository;
  AddActivityUseCase({required IPlannerRepository repository}) : _repository = repository;

  Future<void> call(ActivitiesCompanion activity) {
    return _repository.insertActivity(activity);
  }
}