import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/features/dashboard/data/model/report_counters_model.dart';
import 'package:crv_reprosisa/features/dashboard/domain/repository/dashboard_repository.dart';
import 'package:crv_reprosisa/features/dashboard/domain/usecase/get_report_counters_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../data/datasource/dashboard_remote_datasource.dart';
import '../../data/repository/dashboard_repository_impl.dart';

// 1. Provider del Datasource Remoto
final dashboardRemoteDatasourceProvider = Provider<DashboardRemoteDatasource>((ref) {
  final dio = ref.watch(dioProvider); // O el cliente Dio que utilices globalmente
  return DashboardRemoteDatasourceImpl(dio);
});

// 2. Provider del Repositorio
final dashboardCountersRepositoryProvider = Provider<DashboardCountersRepository>((ref) {
  final remote = ref.watch(dashboardRemoteDatasourceProvider);
  return DashboardCountersRepositoryImpl(remote);
});

// 3. Provider del Caso de Uso
final getReportCountersUseCaseProvider = Provider<GetReportCountersUseCase>((ref) {
  final repository = ref.watch(dashboardCountersRepositoryProvider);
  return GetReportCountersUseCase(repository);
});

// 4. StateNotifierProvider para manejar el estado reactivo en la UI
final reportCountersNotifierProvider = StateNotifierProvider<ReportCountersNotifier, AsyncValue<ReportCountersModel>>((ref) {
  final useCase = ref.watch(getReportCountersUseCaseProvider);
  return ReportCountersNotifier(useCase);
});

class ReportCountersNotifier extends StateNotifier<AsyncValue<ReportCountersModel>> {
  final GetReportCountersUseCase _useCase;

  ReportCountersNotifier(this._useCase) : super(const AsyncValue.loading()) {
    fetchCounters();
  }

  Future<void> fetchCounters() async {
    state = const AsyncValue.loading();
    final result = await _useCase();
    
    result.fold(
      (failure) => state = AsyncValue.error(failure.message, StackTrace.current),
      (counters) => state = AsyncValue.data(counters),
    );
  }
}