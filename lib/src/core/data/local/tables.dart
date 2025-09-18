// lib/src/core/data/local/tables.dart
import 'package:drift/drift.dart';


@DataClassName('Activity') 
class Activities extends Table {
 
  IntColumn get id => integer().autoIncrement()();
  
 
  TextColumn get description => text().withLength(min: 1, max: 200)();
  

  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime()();
}