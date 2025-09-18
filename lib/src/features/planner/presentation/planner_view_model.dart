import 'dart:async';
import 'package:collection/collection.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_planner/src/core/data/local/app_database.dart';
import 'package:time_planner/src/features/planner/domain/usecases/add_activity_usecase.dart';
import 'package:time_planner/src/features/planner/domain/usecases/delete_activity_usecase.dart';
import 'package:time_planner/src/features/planner/domain/usecases/get_activities_usecase.dart';
import 'package:time_planner/src/features/planner/domain/usecases/update_activity_usecase.dart';


enum PlannerViewType { grid, list }

class PlannerViewModel extends ChangeNotifier {
  final GetActivitiesUseCase _getActivitiesUseCase;
  final DeleteActivityUseCase _deleteActivityUseCase;
  final UpdateActivityUseCase _updateActivityUseCase;
  final AddActivityUseCase _addActivityUseCase;

  PlannerViewModel({
    required GetActivitiesUseCase getActivitiesUseCase,
    required DeleteActivityUseCase deleteActivityUseCase,
    required UpdateActivityUseCase updateActivityUseCase,
    required AddActivityUseCase addActivityUseCase,
  })  : _getActivitiesUseCase = getActivitiesUseCase,
        _deleteActivityUseCase = deleteActivityUseCase,
        _updateActivityUseCase = updateActivityUseCase,
        _addActivityUseCase = addActivityUseCase {
    _listenToActivities();
  }

 
  PlannerViewType _viewType = PlannerViewType.grid;
  PlannerViewType get viewType => _viewType;

  StreamSubscription? _activitiesSubscription;
  Map<DateTime, List<Activity>> _allActivities = {};
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<String, List<Activity>> _groupedActivities = {};

  DateTime get focusedDay => _focusedDay;
  DateTime? get selectedDay => _selectedDay;
  Map<String, List<Activity>> get groupedActivities => _groupedActivities;

  List<Activity> get activitiesForSelectedDay {
    if (_selectedDay == null) return [];
    final dateKey =
        DateTime.utc(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
    return _allActivities[dateKey] ?? [];
  }
  
  void setViewType(PlannerViewType newViewType) {
    if (_viewType != newViewType) {
      _viewType = newViewType;
      notifyListeners();
    }
  }

  void _listenToActivities() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    _activitiesSubscription?.cancel();
    _activitiesSubscription =
        _getActivitiesUseCase(startOfMonth, endOfMonth).listen((activities) {
      _allActivities = groupBy(
          activities,
          (activity) => DateTime.utc(activity.startTime.year,
              activity.startTime.month, activity.startTime.day));
      _updateGroupedActivities();
      notifyListeners();
    });
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _updateGroupedActivities();
      notifyListeners();
    }
  }

  void _updateGroupedActivities() {
    final selectedDayActivities = activitiesForSelectedDay;
    _groupedActivities = groupBy(
      selectedDayActivities..sort((a, b) => a.startTime.compareTo(b.startTime)),
      (activity) => DateFormat('HH:mm').format(activity.startTime),
    );
  }

  bool isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  List<Activity> getEventsForDay(DateTime day) {
    final dateKey = DateTime.utc(day.year, day.month, day.day);
    return _allActivities[dateKey] ?? [];
  }

  Future<void> deleteActivity(int id) async {
    await _deleteActivityUseCase(id);
  }

  Future<void> updateActivity({
    required int id,
    required String description,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    final companion = ActivitiesCompanion(
      id: drift.Value(id),
      description: drift.Value(description),
      startTime: drift.Value(startTime),
      endTime: drift.Value(endTime),
    );
    await _updateActivityUseCase(companion);
  }

  Future<void> addActivity({
    required String description,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    final companion = ActivitiesCompanion.insert(
      description: description,
      startTime: startTime,
      endTime: endTime,
    );
    await _addActivityUseCase(companion);
  }

  @override
  void dispose() {
    _activitiesSubscription?.cancel();
    super.dispose();
  }
}