import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crv_reprosisa/core/connectivity/providers/connection_provider.dart';
import 'package:crv_reprosisa/core/sync/sync_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectivitySyncService {
  final Connectivity connectivity;
  final SyncController syncController;
  final Dio dio;
  final Ref ref;

  StreamSubscription<List<ConnectivityResult>>? _subscription;

  bool _isSyncing = false;

  ConnectivitySyncService({
    required this.connectivity,
    required this.syncController,
    required this.dio,
    required this.ref,
  });

  Future<bool> checkBackend() async {
    try {
      final response = await dio.get(
        '/health',
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

  Future<void> start() async {
    final current = await connectivity.checkConnectivity();

    if (!current.contains(ConnectivityResult.none)) {
      await _updateConnectionStatus();
    } else {
      ref.read(connectionProvider.notifier).setConnected(false);
    }

    _subscription = connectivity.onConnectivityChanged.listen((results) async {
      if (results.contains(ConnectivityResult.none)) {
        ref.read(connectionProvider.notifier).setConnected(false);

        return;
      }

      await Future.delayed(const Duration(seconds: 2));

      await _updateConnectionStatus();
    });
  }

  Future<void> _sync() async {
    if (_isSyncing) return;
  
    _isSyncing = true;
  
    final notifier = ref.read(connectionProvider.notifier);
  
    try {
      // Obtener cuántos reportes hay antes de enviarlos
      final pendingBefore = await syncController.pendingReportsCount();
  
      notifier.setPendingReports(pendingBefore);
  
      notifier.setSyncing(true);
  
      await syncController.syncAll();
  
      notifier.syncCompleted();
  
      if (pendingBefore > 0) {
        notifier.setSyncMessage(
          'Se sincronizaron $pendingBefore reportes correctamente',
        );
  
        Future.delayed(
          const Duration(seconds: 5),
          () {
            notifier.clearSyncMessage();
          },
        );
      }
  
    } finally {
      _isSyncing = false;
    }
  }

  void dispose() {
    _subscription?.cancel();
  }

  Future<void> _updateConnectionStatus() async {
    final backendAvailable = await checkBackend();
  
    if (!backendAvailable) {
      ref.read(connectionProvider.notifier)
          .setConnected(false);
  
      return;
    }
  
  
    await _sync();
  
  
    ref.read(connectionProvider.notifier)
        .setConnected(true);
  }
}
