// lib/features/assets/presentation/notifiers/press_report_detail_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/press_usecase_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/press_report_detail_state.dart';

class PressReportDetailNotifier extends Notifier<PressReportDetailState> {
  
  @override
  PressReportDetailState build() {
    return PressReportDetailState.initial();
  }

  Future<void> fetchDetail(String versionId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    final result = await ref.read(getPressReportDetailUseCaseProvider)(versionId);

    result.fold(
      (failure) => state = state.copyWith(isLoading: false, error: failure.message),
      (data) => state = state.copyWith(isLoading: false, data: data),
    );
  }
}