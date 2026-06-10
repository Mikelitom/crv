import 'package:drift/drift.dart';

class PendingPressReportsTable extends Table {
  TextColumn get id => text()();

  TextColumn get pressId => text()();

  TextColumn get folio => text()();

  TextColumn get payload => text()();

  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
