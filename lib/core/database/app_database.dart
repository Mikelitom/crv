import 'package:drift/drift.dart';

import 'database_connection.dart';
import 'tables/vehicles_table.dart';
import 'tables/reports_vehicle_table.dart';
import 'tables/report_versions_vehicle.dart';
import 'tables/report_answers_vehicle.dart';
import 'tables/evidence_vehicle_table.dart';
import 'tables/pending_vehicle_reports_table.dart';
import 'tables/pending_press_reports_table.dart';
import 'tables/press_table.dart';
import 'tables/loan_areas_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    VehiclesTable,
    ReportsVehicleTable,
    VehicleReportVersionsTable,
    ReportAnswersVehicleTable,
    EvidenceVehicleTable,
    PendingVehicleReportsTable,
    PressesTable,
    LoanAreasTable,
    PendingPressReportsTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 8;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 8) {
        await m.deleteTable('vehiclesTable');
        await m.createTable(vehiclesTable);
      }
    },
  );
}
