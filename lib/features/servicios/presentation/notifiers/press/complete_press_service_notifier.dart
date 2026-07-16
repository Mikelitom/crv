import 'package:crv_reprosisa/features/servicios/domain/entities/service_evidence.dart';
import 'package:crv_reprosisa/features/servicios/presentation/notifiers/press/complete_press_service_state.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/service_press_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompletePressServiceNotifier extends Notifier<CompleteServiceState>{
  @override
    CompleteServiceState build() {
      return CompleteServiceState.initial();
    }
  
    Future<void> completeService(
      String serviceId,
      List<ServiceEvidence> evidences,
    ) async {
      state = state.copyWith(
        loading: true,
        success: false,
        error: null,
      );
  
      final useCase = ref.read(completeServiceUseCaseProvider);
  
      final result = await useCase.call(
        serviceId,
        evidences
      );
  
      result.fold(
        (failure) {
          state = state.copyWith(
            loading: false,
            success: false,
            error: failure.message,
          );
        },
        (_) {
          state = state.copyWith(
            loading: false,
            success: true,
            error: null,
          );
        },
      );
    }
  
    void reset() {
      state = CompleteServiceState.initial();
    }
}