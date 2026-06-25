
import 'package:crv_reprosisa/core/sync/rate_limit/global_rate_limiter.dart';
import 'package:crv_reprosisa/core/sync/sync_controller.dart';
import 'package:crv_reprosisa/features/bandas_transportadoras/presentation/provider/banda_inspection_providers.dart';
import 'package:crv_reprosisa/features/prensas_industriales/presentation/provider/inspeccion_providers.dart';
import 'package:crv_reprosisa/features/vehiculos/presentation/provider/vehicle_inspection_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final syncControllerProvider = Provider<SyncController>((ref) {
  return SyncController(
    vehicle: ref.read(vehicleSyncServiceProvider),
    press: ref.read(pressSyncServiceProvider),
    client: ref.read(clientSyncServiceProvider),
  );
});

final globalRateLimiterProvider = Provider<GlobalRateLimiter>((ref) {
  return GlobalRateLimiter(
    minInterval: const Duration(milliseconds: 750),
  );
});