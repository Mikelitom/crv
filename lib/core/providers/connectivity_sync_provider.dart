import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/core/services/connectivity_service.dart';
import 'package:crv_reprosisa/core/sync/sync_providers.dart';
import 'package:crv_reprosisa/features/bandas_transportadoras/presentation/provider/banda_inspection_providers.dart';
import 'package:crv_reprosisa/features/prensas_industriales/presentation/provider/inspeccion_providers.dart';
import 'package:crv_reprosisa/features/vehiculos/presentation/provider/vehicle_inspection_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

final connectivitySyncServiceProvider = Provider<ConnectivitySyncService>((
  ref,
) {
  return ConnectivitySyncService(
    connectivity: Connectivity(),
    dio: ref.read(dioProvider),
    vehicleSyncService: ref.read(vehicleSyncServiceProvider),
    pressSyncService: ref.read(pressSyncServiceProvider),
    clientSyncService: ref.read(clientSyncServiceProvider),
    syncController: ref.read(syncControllerProvider)
  );
});
