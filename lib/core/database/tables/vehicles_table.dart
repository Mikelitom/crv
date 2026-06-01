import 'package:drift/drift.dart';

class VehiclesTable extends Table {
  TextColumn get id => text()();
  TextColumn get typeId => text()();
  TextColumn get brand => text()();
  TextColumn get model => text()();
  IntColumn get year => integer()();
  TextColumn get plate => text()();
  IntColumn get unit => integer()();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}
