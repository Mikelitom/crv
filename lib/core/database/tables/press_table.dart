import 'package:drift/drift.dart';

class PressesTable extends Table {
  TextColumn get id => text()();

  TextColumn get serie => text()();

  TextColumn get size => text().nullable()();

  TextColumn get type => text()();

  TextColumn get model => text().nullable()();

  TextColumn get volts => text().nullable()();

  BoolColumn get isActive =>
      boolean().withDefault(const Constant(true))();

  TextColumn get operationState =>
      text().withDefault(const Constant('AVAILABLE'))();

  TextColumn get currentLocation =>
      text().withDefault(
        const Constant('TALLER CENTRAL REPROSISA'),
      )();

  TextColumn get solicitantsName =>
      text().nullable()();

  TextColumn get loanComment =>
      text().nullable()();

  TextColumn get serviceReason =>
      text().nullable()();

  DateTimeColumn get serviceDate =>
      dateTime().nullable()();

  DateTimeColumn get checkoutDate =>
      dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}