import 'package:drift/drift.dart';

class VehiclesTable extends Table {
  TextColumn get vehicleId => text()();

  TextColumn get plate => text()();
  TextColumn get brand => text()();
  TextColumn get model => text()();
  IntColumn get year => integer()();
  IntColumn get unit => integer()();

  TextColumn get type => text()();
  TextColumn get operationState => text()();
  TextColumn get currentLocation => text()();
  TextColumn get responsible => text()();

  IntColumn get mileage => integer().nullable()();
  TextColumn get serviceReason => text().nullable()();
  TextColumn get phone => text().nullable()();
  BoolColumn get isActive =>
      boolean().withDefault(const Constant(true))();

  DateTimeColumn get serviceDate => dateTime().nullable()();
  DateTimeColumn get checkoutDate => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {vehicleId};
}