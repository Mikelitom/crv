import 'dart:convert';

import 'package:crv_reprosisa/core/sync/rate_limit/global_rate_limiter.dart';

import '../datasource/vehicle_inspection_local_datasource.dart';
import '../datasource/vehicle_inspection_remote_datasource.dart';

class VehicleSyncService {
  final VehicleInspectionLocalDatasource localDatasource;
  final VehicleInspectionRemoteDataSource remoteDatasource;
  final GlobalRateLimiter rateLimiter;

  VehicleSyncService({
    required this.localDatasource,
    required this.remoteDatasource,
    required this.rateLimiter,
  });

  Future<void> syncPendingReports() async {
    final pendingReports = await localDatasource.getPendingReports();

    for (final report in pendingReports) {
      try {
        await rateLimiter.acquire();

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
