import 'package:time_planner/src/core/data/local/app_database.dart';
import 'package:time_planner/src/features/planner/domain/repositories/i_planner_repository.dart';

class GetActivitiesUseCase {
  final IPlannerRepository _repository;

  GetActivitiesUseCase({required IPlannerRepository repository}) : _repository = repository;

  Stream<List<Activity>> call(DateTime start, DateTime end) {
    return _repository.watchActivitiesInRange(start, end);
  }
}