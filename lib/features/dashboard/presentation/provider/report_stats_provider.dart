import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/features/dashboard/data/datasource/report_stats_remote_datasource.dart';
import 'package:crv_reprosisa/features/dashboard/data/model/report_stats_model.dart';
import 'package:crv_reprosisa/features/dashboard/data/repository/report_stats_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


// Proveedor de Datasource (Asegúrate de tener un dioProvider global configurado)
final reportStatsRemoteDatasourceProvider = Provider<ReportStatsRemoteDatasource>((ref) {
  return ReportStatsRemoteDatasourceImpl(ref.watch(dioProvider));
});

// Proveedor de Repositorio
final reportStatsRepositoryProvider = Provider<ReportStatsRepository>((ref) {
  return ReportStatsRepositoryImpl(ref.watch(reportStatsRemoteDatasourceProvider));
});

// FutureProvider final para consumir las estadísticas de reportes en la UI
final reportStatsProvider = FutureProvider<List<ReportStatModel>>((ref) async {
  final repository = ref.watch(reportStatsRepositoryProvider);
  final result = await repository.getReportStats();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (stats) => stats,
  );
});