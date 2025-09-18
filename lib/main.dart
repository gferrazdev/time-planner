import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:time_planner/src/core/app/app_material.dart';
import 'package:time_planner/src/core/data/local/app_database.dart';
import 'package:time_planner/src/core/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);

  await Injection.init();



 
  final database = sl<AppDatabase>();
  final now = DateTime.now();
  await database.activitiesDao.insertActivity(
    ActivitiesCompanion.insert(
      description: 'Reunião de Alinhamento Semanal',
      startTime: now,
      endTime: now.add(const Duration(hours: 1)),
    ),
  );

  runApp(const AppMaterial());
}
