import 'package:drift/drift.dart';

class MinesTable extends Table {
  TextColumn get id => text()();

  // 👇 IMPORTANTE: SIN references()
  TextColumn get clientId => text()();

  TextColumn get name => text()();
  TextColumn get address => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();

  BoolColumn get isActive => boolean()();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}