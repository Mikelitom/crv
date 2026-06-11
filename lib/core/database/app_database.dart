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
  int get schemaVersion => 10;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      if (from < 10) {
        await m.deleteTable('vehicles');
        await m.deleteTable('reports_vehicle');
        await m.deleteTable('vehicle_report_versions');
        await m.deleteTable('report_answers_vehicle');
        await m.deleteTable('evidence_vehicle');
        await m.deleteTable('pending_vehicle_reports');
        await m.deleteTable('presses');
        await m.deleteTable('loan_areas');
        await m.deleteTable('pending_press_reports');
  
        await m.createAll();
      }
    },
  );
}
