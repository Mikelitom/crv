import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/get_vehicle_report_detail.dart';
import '../states/vehicle_report_detail_state.dart';
import '../../data/models/vehicle_report_detail_model.dart';
import '../providers/vehicle_usecase_provider.dart'; // Asegúrate de importar donde está tu getVehicleReportDetailUseCaseProvider

class VehicleReportDetailNotifier extends Notifier<VehicleReportDetailState> {
  
  @override
  VehicleReportDetailState build() {
    return VehicleReportDetailState.initial();
  }

  Future<void> fetchDetail(String reportId) async {
    // 1. Ponemos el estado en carga
    state = state.copyWith(isLoading: true, error: null);
    
    // 2. Obtenemos el caso de uso desde el provider global
    final useCase = ref.read(getVehicleReportDetailUseCaseProvider);
    
    // 3. Ejecutamos la petición
    final result = await useCase(reportId);
    
    // 4. Procesamos el resultado con fold (dartz)
    state = result.fold(
      (failure) => state.copyWith(
        isLoading: false, 
        error: failure.message
      ),
      (data) => state.copyWith(
        isLoading: false, 
        // Realizamos el casting a nuestro modelo tipado
        data: data as VehicleReportDetailModel 
      ),
    );
  }
}