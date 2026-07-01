import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../states/vehicle_report_detail_state.dart';
import '../../data/models/vehicle_report_detail_model.dart';
import '../providers/vehicle_usecase_provider.dart';

class VehicleReportDetailNotifier extends Notifier<VehicleReportDetailState> {
  
  @override
  VehicleReportDetailState build() {
    return VehicleReportDetailState.initial();
  }

  Future<void> fetchDetail(String reportId) async {
    // 1. Ponemos el estado en carga
    state = state.copyWith(isLoading: true, error: null);
    
    // 2. Obtenemos el caso de uso
    final useCase = ref.read(getVehicleReportDetailUseCaseProvider);
    
    // 3. Ejecutamos la petición
    final result = await useCase.call(reportId);
    
    // 4. Procesamos el resultado. 
    // Mantenemos tu lógica original: como tu State espera un Model, 
    // convertimos el resultado de la entidad al modelo.
    state = result.fold(
      (failure) => state.copyWith(
        isLoading: false, 
        error: failure.message
      ),
      (data) => state.copyWith(
        isLoading: false, 
        data: data as VehicleReportDetailModel 
      ),
    );
  }
}