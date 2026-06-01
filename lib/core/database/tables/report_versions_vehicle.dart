import 'package:drift/drift.dart';

class VehicleReportVersionsTable extends Table {
  TextColumn get id => text()();

  TextColumn get reportId => text()();

  IntColumn get versionNumber => integer()();
  BoolColumn get isCurrent => boolean()();

  TextColumn get createdBy => text()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
