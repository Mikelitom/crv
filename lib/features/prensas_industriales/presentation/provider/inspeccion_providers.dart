import 'package:crv_reprosisa/core/database/database_provider.dart';
import 'package:crv_reprosisa/features/prensas_industriales/data/datasource/press_inspection_local_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import '../../../../core/config/dio_client.dart';
import '../../data/datasource/inspeccion_datasource_remote.dart';
import '../../data/repositories/inspeccion_repository_impl.dart';
import '../../domain/repositories/inspeccion_repository.dart';
import '../../domain/usecases/get_press_by_serie_use_case.dart';
import '../../domain/usecases/create_press_report_use_case.dart';
// Asegúrate de que estas rutas a tus casos de uso sean correctas
import '../../domain/usecases/get_loan_areas_use_case.dart';
import '../../domain/usecases/create_loan_use_case.dart';
import '../notifier/inspeccion_notifier.dart';
import 'inspeccion_state.dart';
import '../../domain/usecases/get_latest_loan_status_use_case.dart';
import 'package:hive/hive.dart';
import 'package:crv_reprosisa/features/prensas_industriales/data/services/press_sync_service.dart';

final inspeccionDataSourceProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return InspeccionRemoteDataSourceImpl(dio);
});

final inspectionLocalDataSourceProvider =
    Provider<PressInspectionLocalDataSource>((ref) {
      final db = ref.read(appDatabaseProvider);
      final box = Hive.box('press_cache');
      return PressInspectionLocalDataSourceImpl(db, box);
    });

final inspeccionRepositoryProvider = Provider<InspeccionRepository>((ref) {
  final ds = ref.watch(inspeccionDataSourceProvider);
  final lds = ref.watch(inspectionLocalDataSourceProvider);
  return InspeccionRepositoryImpl(ds, lds);
});

final pressSyncServiceProvider = Provider<PressSyncService>((ref) {
  return PressSyncService(
    local: ref.read(inspectionLocalDataSourceProvider),
    remote: ref.read(inspeccionDataSourceProvider),
  );
});

// --- USE CASES ---
final getPressBySerieProvider = Provider((ref) {
  final repo = ref.watch(inspeccionRepositoryProvider);
  return GetPressBySerieUseCase(repo);
});

final createPressReportProvider = Provider((ref) {
  final repo = ref.watch(inspeccionRepositoryProvider);
  return CreatePressReportUseCase(repo);
});

// --- NUEVOS CASOS DE USO PARA PRÉSTAMOS ---
final getLoanAreasUseCaseProvider = Provider((ref) {
  final repo = ref.watch(inspeccionRepositoryProvider);
  return GetLoanAreasUseCase(repo);
});

final createLoanAreaUseCaseProvider = Provider((ref) {
  final repo = ref.watch(inspeccionRepositoryProvider);
  return CreateLoanAreaUseCase(repo);
});
final getLatestLoanStatusUseCaseProvider = Provider((ref) {
  final repo = ref.watch(inspeccionRepositoryProvider);
  return GetLatestLoanStatusUseCase(repo);
});
// --- OTROS ---
final allSeriesProvider = FutureProvider<List<String>>((ref) async {
  final repo = ref.watch(inspeccionRepositoryProvider);
  final result = await repo.fetchAllSeries();

  return result.fold(
    (failure) => throw Exception(failure.message),
    (series) => series,
  );
});

final inspeccionProvider =
    NotifierProvider<InspeccionNotifier, InspeccionState>(() {
      return InspeccionNotifier();
    });
