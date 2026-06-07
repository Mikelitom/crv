import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/client_usecase_provider.dart';
import '../states/conveyor_report_detail_state.dart';

class ConveyorReportDetailNotifier extends Notifier<ConveyorReportDetailState> {
  @override
  ConveyorReportDetailState build() {
    return ConveyorReportDetailState.initial();
  }

  Future<void> fetchDetail(String versionId) async {
    state = state.copyWith(isLoading: true, error: null);
    final useCase = ref.read(getConveyorReportDetailUseCaseProvider);
    final result = await useCase(versionId);
    
    result.fold(
      (failure) => state = state.copyWith(isLoading: false, error: failure.message),
      (data) => state = state.copyWith(isLoading: false, data: data),
    );
  }
}