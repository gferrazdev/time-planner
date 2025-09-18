// lib/src/core/data/local/app_database.dart
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import 'package:time_planner/src/core/data/local/tables.dart';

part 'app_database.g.dart';


@DriftDatabase(tables: [Activities], daos: [ActivitiesDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

 
  ActivitiesDao get activitiesDao => ActivitiesDao(this);
}


@DriftAccessor(tables: [Activities])
class ActivitiesDao extends DatabaseAccessor<AppDatabase> with _$ActivitiesDaoMixin {
  ActivitiesDao(super.db);

  Stream<List<Activity>> watchActivitiesInRange(DateTime start, DateTime end) {
    return (select(activities)
          ..where((tbl) => tbl.startTime.isBetween(Variable(start), Variable(end)))
          ..orderBy([(tbl) => OrderingTerm(expression: tbl.startTime)]))
        .watch();
  }

  
  Future<int> insertActivity(ActivitiesCompanion entry) {
    return into(activities).insert(entry);
  }

  Future<void> clearActivities() => delete(activities).go();

  Future<int> deleteActivity(int id) {
    return (delete(activities)..where((tbl) => tbl.id.equals(id))).go();
  }

  
  Future<bool> updateActivity(ActivitiesCompanion entry) {
    return update(activities).replace(entry);
  }

}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }
    final cache = await getTemporaryDirectory();
    sqlite3.tempDirectory = cache.path;

    return NativeDatabase.createInBackground(file);
  });
}