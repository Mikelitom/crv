import 'package:crv_reprosisa/core/database/database_provider.dart';
import 'package:crv_reprosisa/features/bandas_transportadoras/data/datasource/client_local_datasource.dart';
import 'package:crv_reprosisa/features/bandas_transportadoras/data/services/client_sync_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/datasource/banda_remote_datasource.dart';
import '../../data/repositories/banda_repository_impl.dart';
import '../../domain/repositories/banda_repository.dart';
import '../../domain/usecases/get_banda_template_use_case.dart';
import '../../domain/usecases/get_active_clients_use_case.dart';
import '../../domain/usecases/get_active_mines_use_case.dart';
import '../../domain/usecases/create_banda_report_use_case.dart';
import '../notifier/banda_inspection_notifier.dart';
import 'banda_inspection_state.dart';
import '../../../../core/config/dio_client.dart';

// Data Source & Repo
final bandaDataSourceProvider = Provider(
  (ref) => BandaRemoteDataSourceImpl(ref.watch(dioProvider)),
);
final clientLocalDataSourceProvider = Provider<ClientLocalDataSource>((ref) {
  final db = ref.read(appDatabaseProvider);
  final box = Hive.box('conveyor_cache');
  return ClientLocalDataSourceImpl(db, box);
});

final bandaRepositoryProvider = Provider<BandaRepository>((ref) {
  final remote = ref.watch(bandaDataSourceProvider);
  final local = ref.watch(clientLocalDataSourceProvider);

  return BandaRepositoryImpl(remote, local);
});

// Use Cases
final getBandaTemplateUseCaseProvider = Provider(
  (ref) => GetBandaTemplateUseCase(ref.watch(bandaRepositoryProvider)),
);
final getActiveClientsUseCaseProvider = Provider(
  (ref) => GetActiveClientsUseCase(ref.watch(bandaRepositoryProvider)),
);
final getActiveMinesUseCaseProvider = Provider(
  (ref) => GetActiveMinesUseCase(ref.watch(bandaRepositoryProvider)),
);

// ESTE ES EL PROVIDER QUE TE FALTABA
final createBandaReportUseCaseProvider = Provider(
  (ref) => CreateBandaReportUseCase(ref.watch(bandaRepositoryProvider)),
);

// Notifier Principal
final bandaInspectionProvider =
    NotifierProvider<BandaInspectionNotifier, BandaInspectionState>(() {
      return BandaInspectionNotifier();
    });

final clientSyncServiceProvider = Provider<ClientSyncService>((ref) {
  return ClientSyncService(
    local: ref.read(clientLocalDataSourceProvider),
    remote: ref.read(bandaDataSourceProvider),
  );
});
