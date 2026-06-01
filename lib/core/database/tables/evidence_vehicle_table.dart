import 'package:drift/drift.dart';

class EvidenceVehicleTable extends Table {
  TextColumn get id => text()();

  TextColumn get answerId => text()();

  TextColumn get filePath => text()(); // local path o remote url
  TextColumn get fileType => text()(); // image | video
  TextColumn get mimeType => text()();

  IntColumn get fileSize => integer().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
