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
import 'tables/clients_table.dart';
import 'tables/mines_table.dart';

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
    ClientsTable,
    MinesTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 11;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },

    onUpgrade: (m, from, to) async {
      await m.createAll();
    },
  );
}
