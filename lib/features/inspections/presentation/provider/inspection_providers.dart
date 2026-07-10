import 'package:crv_reprosisa/features/vehiculos/presentation/provider/vehicle_inspection_provider.dart';
import 'package:crv_reprosisa/features/vehiculos/domain/usecases/update_vehicle_report_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/dio_client.dart';
import '../../data/repositories/inspection_repository_impl.dart';
import '../../domain/repositories/inspection_repository.dart';
import '../../data/datasource/inspection_remote_data_source.dart';
import '../notifier/inspection_notifier.dart';
import '../../domain/usecases/get_my_inspections.dart';
import 'inspection_state.dart';
import '../../domain/usecases/get_inspection_by_id_use_case.dart';
import '../../domain/usecases/get_vehicle_history.dart';
import '../../domain/usecases/get_vehicle_report_detail.dart'; // <--- Importa el nuevo UseCase

final inspectionDataSourceProvider = Provider((ref) => 
  InspectionRemoteDataSourceImpl(ref.watch(dioProvider)));

final inspectionRepositoryProvider = Provider<InspectionRepository>((ref) => 
  InspectionRepositoryImpl(ref.watch(inspectionDataSourceProvider)));

final getInspectionByIdUseCaseProvider = Provider((ref) => 
  GetInspectionByIdUseCase(ref.watch(inspectionRepositoryProvider)));

final getVehicleHistoryUseCaseProvider = Provider((ref) => 
  GetVehicleHistoryUseCase(ref.watch(inspectionRepositoryProvider)));

final getMyInspectionsUseCaseProvider = Provider((ref) => 
  GetMyInspectionsUseCase(ref.watch(inspectionRepositoryProvider)));

final getVehicleReportDetailUseCaseProvider = Provider((ref) => 
  GetVehicleReportDetailUseCase(ref.watch(inspectionRepositoryProvider)));

final inspectionProvider = NotifierProvider<InspectionNotifier, InspectionState>(() {
  return InspectionNotifier();
});// En inspeccion_providers.dart
final updateVehicleReportUseCaseProvider = Provider((ref) {
  // Obtenemos el repositorio general
  final repo = ref.read(vehicleRepositoryProvider);
  
  return UpdateVehicleReportUseCase(repo);
});