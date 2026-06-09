import 'dart:convert';

import 'package:crv_reprosisa/features/prensas_industriales/data/datasource/inspeccion_datasource_remote.dart';
import 'package:crv_reprosisa/features/prensas_industriales/data/datasource/press_inspection_local_datasource.dart';

class PressSyncService {
  final PressInspectionLocalDataSource local;
  final InspeccionRemoteDataSource remote;

  PressSyncService({required this.local, required this.remote});

  Future<void> syncPendingReports() async {
    final pendingReports = await local.getPendingReports();

    for (final report in pendingReports) {
      try {
        final payload = jsonDecode(report.payload);
        
        await remote.savePressReport(payload);
        
        await local.deletePendingReport(report.id);
        print('Reporte sincronizado: ${report.folio}');
      } catch (e) {
        print('Error sincronizando ${report.folio}: $e');
      }
    }
  }
}
