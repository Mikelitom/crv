import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/press_usecase_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/press_state.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';

class DeactivatePressNotifier extends Notifier<PressState> {
  @override
  PressState build() => const PressState(status: Status.initial);

  Future<void> deactivate(String id) async {
    state = state.copyWith(status: Status.loading);
    
    final result = await ref.read(deactivatePressUseCaseProvider).call(id);
    
    result.fold(
      (failure) {
        state = state.copyWith(
          status: Status.error, 
          error: failure.message
        );
      },
      (_) {
        state = state.copyWith(
          status: Status.success, 
          message: "Prensa desactivada con éxito"
        );
      },
    );
  }
}