import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/core/services/connectivity_service.dart';
import 'package:crv_reprosisa/core/sync/sync_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

final connectivitySyncServiceProvider = Provider<ConnectivitySyncService>((
  ref,
) {
  return ConnectivitySyncService(
    connectivity: Connectivity(),
    dio: ref.read(dioProvider),
    syncController: ref.read(syncControllerProvider),
    ref: ref
  );
});
