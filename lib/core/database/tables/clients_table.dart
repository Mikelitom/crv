import 'package:drift/drift.dart';

class ClientsTable extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();
  TextColumn get company => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();

  BoolColumn get isActive => boolean()();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
} 