import 'package:drift/drift.dart';

class ReportsVehicleTable extends Table {
  TextColumn get id => text()();

  TextColumn get vehicleId => text()();
  TextColumn get responsibleId => text()();

  DateTimeColumn get inspectionDate => dateTime()();
  IntColumn get mileage => integer()();

  BoolColumn get requiresService =>
      boolean().withDefault(const Constant(false))();
  TextColumn get observation => text().nullable()();
  TextColumn get generalNotes => text().nullable()();

  TextColumn get folio => text()();
  TextColumn get state => text()(); // IN_PROGRESS, COMPLETED

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  // 🔥 clave offline sync
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
