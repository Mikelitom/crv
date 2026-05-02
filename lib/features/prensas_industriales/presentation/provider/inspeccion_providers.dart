import 'package:flutter_riverpod/flutter_riverpod.dart';
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

// --- DATA LAYER ---
final inspeccionDataSourceProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return InspeccionRemoteDataSourceImpl(dio);
});

final inspeccionRepositoryProvider = Provider<InspeccionRepository>((ref) {
  final ds = ref.watch(inspeccionDataSourceProvider);
  return InspeccionRepositoryImpl(ds);
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

// --- OTROS ---
final allSeriesProvider = FutureProvider<List<String>>((ref) async {
  final repo = ref.watch(inspeccionRepositoryProvider);
  final result = await repo.fetchAllSeries();

  return result.fold(
    (failure) => throw Exception(failure.message),
    (series) => series,
  );
});

final inspeccionProvider = NotifierProvider<InspeccionNotifier, InspeccionState>(() {
  return InspeccionNotifier();
});