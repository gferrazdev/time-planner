import 'package:time_planner/src/core/data/local/app_database.dart';
import 'package:time_planner/src/features/planner/domain/repositories/i_planner_repository.dart';

class PlannerRepositoryImpl implements IPlannerRepository {
  final ActivitiesDao _activitiesDao;
  PlannerRepositoryImpl({required ActivitiesDao activitiesDao}) : _activitiesDao = activitiesDao;

  @override
  Stream<List<Activity>> watchActivitiesInRange(DateTime start, DateTime end) {
    return _activitiesDao.watchActivitiesInRange(start, end);
  }

  @override
  Future<void> deleteActivity(int id) {
    return _activitiesDao.deleteActivity(id);
  }

  @override
  Future<void> updateActivity(ActivitiesCompanion activity) {
    return _activitiesDao.updateActivity(activity);
  }
  
  @override
  Future<void> insertActivity(ActivitiesCompanion activity) {
    return _activitiesDao.insertActivity(activity);
  }
}