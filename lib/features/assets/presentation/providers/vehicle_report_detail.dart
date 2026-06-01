// lib/features/assets/presentation/providers/vehicle_report_detail_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
// Importa tus clases corregidas (asegúrate de que estas rutas sean correctas)
import '../../domain/usecases/get_vehicle_report_detail.dart';
import '../../presentation/providers/vehicle_repository_provider.dart';
import '../../presentation/notifiers/vehicle_report_detail_notifier.dart';
import '../../presentation/states/vehicle_report_detail_state.dart';

// Este provider es el que inyecta el caso de uso
final getVehicleReportDetailUseCaseProvider = Provider<GetVehicleReportDetail>((ref) {
  final repository = ref.read(vehicleRepositoryProvider);
  return GetVehicleReportDetail(repository);
});

final vehicleReportDetailProvider = NotifierProvider<VehicleReportDetailNotifier, VehicleReportDetailState>(() {
  return VehicleReportDetailNotifier();
});