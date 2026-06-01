import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import 'database_connection.dart';
import 'tables/vehicles_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [VehiclesTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 1;
}
