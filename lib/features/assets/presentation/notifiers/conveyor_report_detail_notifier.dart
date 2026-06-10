// En lib/features/assets/presentation/notifiers/conveyor_report_detail_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/client_usecase_provider.dart';
import '../states/conveyor_report_detail_state.dart';
// Asegúrate de importar tu entidad o modelo de reporte
import 'package:crv_reprosisa/features/assets/domain/entities/conveyor_report_detail.dart'; 

class ConveyorReportDetailNotifier extends Notifier<ConveyorReportDetailState> {
  @override
  ConveyorReportDetailState build() {
    return ConveyorReportDetailState.initial();
  }

  Future<ConveyorReportDetail?> fetchDetail(String versionId) async {
    state = state.copyWith(isLoading: true, error: null);
    final useCase = ref.read(getConveyorReportDetailUseCaseProvider);
    final result = await useCase(versionId);
    
    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
        return null; // Error, retornamos nulo
      },
      (data) {
        state = state.copyWith(isLoading: false, data: data);
        return data; // Éxito, retornamos el objeto para el PDF
      },
    );
  }
}