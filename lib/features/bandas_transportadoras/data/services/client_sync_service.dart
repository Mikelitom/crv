import 'dart:convert';

import 'package:crv_reprosisa/core/sync/rate_limit/global_rate_limiter.dart';
import 'package:crv_reprosisa/features/bandas_transportadoras/data/datasource/banda_remote_datasource.dart';
import 'package:crv_reprosisa/features/bandas_transportadoras/data/datasource/client_local_datasource.dart';

class ClientSyncService {
  final BandaRemoteDataSource remote;
  final ClientLocalDataSource local;
  final GlobalRateLimiter rateLimiter;

  ClientSyncService({
    required this.remote,
    required this.local,
    required this.rateLimiter,
  });

  Future<void> syncPendingReports() async {
    final pending = await local.getPendingReports();

    for (final report in pending) {
      try {
        await rateLimiter.acquire();

        final payload = jsonDecode(report.payload);
        await remote.saveBandaReport(payload);

        await local.deletePendingReport(report.id);
      } catch (e) {
        print("sync error: $e");
      }
    }
  }
}