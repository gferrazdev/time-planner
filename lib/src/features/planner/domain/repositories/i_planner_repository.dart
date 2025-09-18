import 'package:time_planner/src/core/data/local/app_database.dart';

abstract interface class IPlannerRepository {
  Stream<List<Activity>> watchActivitiesInRange(DateTime start, DateTime end);
  Future<void> deleteActivity(int id);
  Future<void> updateActivity(ActivitiesCompanion activity);
  Future<void> insertActivity(ActivitiesCompanion activity);
}