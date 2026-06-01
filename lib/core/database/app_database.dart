import 'package:drift/drift.dart';

import 'database_connection.dart';
import 'tables/vehicles_table.dart';
import 'tables/reports_vehicle_table.dart';
import 'tables/report_versions_vehicle.dart';
import 'tables/report_answers_vehicle.dart';
import 'tables/evidence_vehicle_table.dart';
import 'tables/pending_vehicle_reports_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    VehiclesTable,
    ReportsVehicleTable,
    VehicleReportVersionsTable,
    ReportAnswersVehicleTable,
    EvidenceVehicleTable,
    PendingVehicleReportsTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.createTable(reportsVehicleTable);
        await m.createTable(vehicleReportVersionsTable);
        await m.createTable(reportAnswersVehicleTable);
        await m.createTable(evidenceVehicleTable);
        await m.createTable(pendingVehicleReportsTable);
      }
    },
  );
}
