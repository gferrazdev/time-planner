import 'package:time_planner/src/features/planner/domain/repositories/i_planner_repository.dart';

class DeleteActivityUseCase {
  final IPlannerRepository _repository;

  DeleteActivityUseCase({required IPlannerRepository repository}) : _repository = repository;

  Future<void> call(int id) {
    return _repository.deleteActivity(id);
  }
}