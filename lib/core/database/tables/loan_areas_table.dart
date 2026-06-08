import 'package:drift/drift.dart';

class LoanAreasTable extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();

  TextColumn get address => text().nullable()();

  TextColumn get contact => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}