// lib/src/core/di/injection.dart
import 'package:get_it/get_it.dart';
import 'package:time_planner/src/core/di/core_module.dart';
import 'package:time_planner/src/features/login/di/login_di.dart';
import 'package:time_planner/src/features/planner/di/planner_di.dart';

final sl = GetIt.instance;

class Injection {
  static Future<void> init() async {
    setupCore();
    setupPlanner();
    setupLogin();
  }
}