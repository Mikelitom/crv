import 'dart:convert';

import '../datasource/vehicle_inspection_local_datasource.dart';
import '../datasource/vehicle_inspection_remote_datasource.dart';

class VehicleSyncService {
  final VehicleInspectionLocalDatasource localDatasource;
  final VehicleInspectionRemoteDataSource remoteDatasource;

  VehicleSyncService({
    required this.localDatasource,
    required this.remoteDatasource,
  });

  Future<void> syncPendingReports() async {
    final pendingReports = await localDatasource.getPendingReports();

    for (final report in pendingReports) {
      try {
        final payload = jsonDecode(report.payload);

        await remoteDatasource.saveVehicleReport(payload);

        await localDatasource.deletePendingReport(report.id);

        print('Reporte sincronizado: ${report.folio}');
      } catch (e) {
        print('Error sincronizando ${report.folio}: $e');
      }
    }
  }
}