import 'package:crv_reprosisa/features/reports/data/datasource/report_remote_datasource.dart';
import 'package:crv_reprosisa/features/reports/data/datasource/report_remote_datasource_impl.dart';
import 'package:crv_reprosisa/features/reports/data/repository/report_repository_impl.dart';
import 'package:crv_reprosisa/features/reports/domain/repository/report_repository.dart';
import 'package:crv_reprosisa/features/reports/domain/usecase/get_all_reports_usecae.dart';
import 'package:crv_reprosisa/features/reports/presentation/notifier/reports_notifier.dart';
import 'package:crv_reprosisa/features/reports/presentation/provider/reports_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

// Importaciones necesarias para los nuevos casos de uso de detalle
import 'package:crv_reprosisa/features/assets/presentation/providers/vehicle_usecase_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/press_usecase_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/client_usecase_provider.dart';
import 'package:flutter_riverpod/legacy.dart';

// 1. Provider del cliente Dio
final dioProvider = Provider((ref) => Dio(BaseOptions(
  baseUrl: "https://backend-crv-refactor.onrender.com/api/v1",
  connectTimeout: const Duration(seconds: 10),
  receiveTimeout: const Duration(seconds: 10),
)));

// 2. Provider del DataSource
final reportRemoteDatasourceProvider = Provider<ReportRemoteDatasource>((ref) {
  return ReportRemoteDatasourceImpl(ref.read(dioProvider));
});

// 3. Provider del Repositorio
final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  return ReportRepositoryImpl(ref.read(reportRemoteDatasourceProvider));
});

// 4. Provider del UseCase general
final getAllReportsUseCaseProvider = Provider((ref) {
  return GetAllReportsUseCase(ref.read(reportRepositoryProvider));
});

// 5. Provider del Notifier con inyección de casos de uso de detalle
final reportsNotifierProvider = StateNotifierProvider<ReportsNotifier, ReportsState>((ref) {
  final useCase = ref.read(getAllReportsUseCaseProvider);
  
  // Obtenemos los casos de uso de detalle desde sus respectivos proveedores
  final getVehicleDetail = ref.read(getVehicleReportDetailUseCaseProvider);
  final getPressDetail = ref.read(getPressReportDetailUseCaseProvider);
  final getConveyorDetail = ref.read(getConveyorReportDetailUseCaseProvider);
  final dio = ref.read(dioProvider);

  return ReportsNotifier(
    getAllReportsUseCase: useCase,
    getVehicleDetail: getVehicleDetail,
    getPressDetail: getPressDetail,
    getConveyorDetail: getConveyorDetail,
    dio: dio,
  );
});