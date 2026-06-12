import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crv_reprosisa/features/bandas_transportadoras/data/services/client_sync_service.dart';
import 'package:crv_reprosisa/features/prensas_industriales/data/services/press_sync_service.dart';
import 'package:crv_reprosisa/features/vehiculos/data/services/vehicle_sync_service.dart';
import 'package:dio/dio.dart';

class ConnectivitySyncService {
  final Connectivity connectivity;
  final VehicleSyncService vehicleSyncService;
  final PressSyncService pressSyncService;
  final ClientSyncService clientSyncService;
  final Dio dio;

  StreamSubscription<List<ConnectivityResult>>? _subscription;

  bool _isSyncing = false;

  ConnectivitySyncService({
    required this.connectivity,
    required this.vehicleSyncService,
    required this.pressSyncService,
    required this.clientSyncService,
    required this.dio,
  });

  Future<bool> checkBackend() async {
    try {
      final response = await dio.get(
        '/info',
        options: Options(
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );

      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  void start() {
    _subscription = connectivity.onConnectivityChanged.listen((results) async {
      if (results.contains(ConnectivityResult.none)) {
        return;
      }

      await Future.delayed(const Duration(seconds: 3));

      final backendAvailable = await checkBackend();

      if (!backendAvailable) {
        return;
      }

      await _sync();
    });
  }

  Future<void> _sync() async {
    if (_isSyncing) return;

    _isSyncing = true;

    try {
      await vehicleSyncService.syncPendingReports();
      await pressSyncService.syncPendingReports();
      await clientSyncService.syncPendingReports();
    } finally {
      _isSyncing = false;
    }
  }

  void dispose() {
    _subscription?.cancel();
  }
}
