import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasource/vehicle_inspection_remote_datasource.dart';
import '../../data/repositories/vehicle_inspection_repository_impl.dart';
import '../../domain/usecases/get_active_vehicles_use_case.dart';
import '../../domain/usecases/get_vehicle_template_use_case.dart';
import '../../domain/usecases/create_vehicle_report_use_case.dart';
import 'vehicle_inspection_state.dart';
import '../notifier/vehicle_inspection_notifier.dart';
import '../../domain/repositories/vehicle_inspeccion_repository.dart';

final vehicleDataSourceProvider = Provider<VehicleInspectionRemoteDataSource>((ref) {
  return VehicleInspectionRemoteDataSourceImpl(ref.read(dioProvider));
});

final vehicleRepositoryProvider = Provider<VehicleInspectionRepository>((ref) {
  return VehicleInspectionRepositoryImpl(ref.read(vehicleDataSourceProvider));
});

// Casos de uso
final getActiveVehiclesUseCaseProvider = Provider((ref) => 
  GetActiveVehiclesUseCase(ref.read(vehicleRepositoryProvider)));

final getVehicleTemplateUseCaseProvider = Provider((ref) => 
  GetVehicleTemplateUseCase(ref.read(vehicleRepositoryProvider)));

final createVehicleReportUseCaseProvider = Provider((ref) => 
  CreateVehicleReportUseCase(ref.read(vehicleRepositoryProvider)));

// Notifier
final vehicleInspectionProvider = NotifierProvider<VehicleInspectionNotifier, VehicleInspectionState>(() {
  return VehicleInspectionNotifier();
});

final allPlatesProvider = FutureProvider<List<String>>((ref) async {
  final useCase = ref.read(getActiveVehiclesUseCaseProvider);
  final result = await useCase();
  return result.fold(
    (l) => [],
    (vehicles) => vehicles.map((v) => v.plate).toList(),
  );
});