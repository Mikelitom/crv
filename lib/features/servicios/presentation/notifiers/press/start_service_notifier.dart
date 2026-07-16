import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
import 'package:crv_reprosisa/features/servicios/presentation/notifiers/press/start_press_service_state.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/service_press_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StartServiceNotifier extends Notifier<StartPressServiceState> {
  @override
  StartPressServiceState build() => const StartPressServiceState();

  Future<void> startService(
    String serviceId,
    String observation
  ) async {
    state = state.copyWith(status: Status.loading);

    final useCase = ref.read(startPressServiceUseCaseProvider);
    final result = await useCase.call(
      serviceId: serviceId,
      observation: observation
    );

    state = result.fold(
      (failure) => state.copyWith(status: Status.error, error: failure.message),
      (_) => state.copyWith(status: Status.success),
    );
  }

  void reset() {
    state = const StartPressServiceState();
  }
}