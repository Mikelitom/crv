import 'dart:convert';

import 'package:crv_reprosisa/features/bandas_transportadoras/data/datasource/banda_remote_datasource.dart';
import 'package:crv_reprosisa/features/bandas_transportadoras/data/datasource/client_local_datasource.dart';

class ClientSyncService {
  final BandaRemoteDataSource remote;
  final ClientLocalDataSource local;

  ClientSyncService({
    required this.remote,
    required this.local
  });

  Future<void> syncPendingReports() async {
    final pendingReports = await local.getPendingReports();

    for (final report in pendingReports) {
      try {
        final payload = jsonDecode(report.payload);
        
        await remote.saveBandaReport(payload);
        
        await local.deletePendingReport(report.id);
        print('Reporte sincronizado: ${report.folio}');
      } catch (e) {
        print('Error sincronizando ${report.folio}: $e');
      }
    }
  }
}
