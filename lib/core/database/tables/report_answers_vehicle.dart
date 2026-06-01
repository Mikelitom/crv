import 'package:drift/drift.dart';

class ReportAnswersVehicleTable extends Table {
  TextColumn get id => text()();

  TextColumn get reportVersionId => text()();

  TextColumn get componentId => text()();
  TextColumn get optionId => text()();

  TextColumn get observation => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
