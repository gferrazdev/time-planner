import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:time_planner/src/core/app/app_material.dart';
import 'package:time_planner/src/core/data/local/app_database.dart';
import 'package:time_planner/src/core/di/injection.dart';

void main() async {
  // Garante que os bindings do Flutter estejam prontos
  WidgetsFlutterBinding.ensureInitialized();
   await initializeDateFormatting('pt_BR', null); // Inicializa formatação
  
  // Inicializa a injeção de dependência
  await Injection.init();

  // ----- BLOCO DE TESTE PARA ADICIONAR DADOS -----
  final database = sl<AppDatabase>();
  final now = DateTime.now();
  sl<AppDatabase>().activitiesDao.clearActivities();
  // Inserindo a primeira atividade
  await database.activitiesDao.insertActivity(
    ActivitiesCompanion.insert(
      description: 'Reunião de Alinhamento Semanal',
      startTime: now.copyWith(hour: 14, minute: 0, second: 0),
      endTime: now.copyWith(hour: 15, minute: 30, second: 0),
    )
  );

  // Inserindo a SEGUNDA atividade
  await database.activitiesDao.insertActivity(
    ActivitiesCompanion.insert(
      description: 'Consulta com Dr. Silveira',
      startTime: now.copyWith(hour: 16, minute: 0, second: 0),
      endTime: now.copyWith(hour: 17, minute: 0, second: 0),
    )
  );
  // ---------------------------------------------

  runApp(const AppMaterial());
}