import 'package:crv_reprosisa/features/bandas_transportadoras/data/services/client_sync_service.dart';
import 'package:crv_reprosisa/features/prensas_industriales/data/services/press_sync_service.dart';
import 'package:crv_reprosisa/features/vehiculos/data/services/vehicle_sync_service.dart';

class SyncController {
  final VehicleSyncService vehicle;
  final PressSyncService press;
  final ClientSyncService client;

  bool _isSyncing = false;

  SyncController({
    required this.vehicle,
    required this.press,
    required this.client,
  });

  Future<void> syncAll() async {
    if (_isSyncing) return;

    _isSyncing = true;

    try {
      await client.syncPendingReports();
      await vehicle.syncPendingReports();
      await press.syncPendingReports();
    } finally {
      _isSyncing = false;
    }
  }
}