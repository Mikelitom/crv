import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
import 'package:crv_reprosisa/features/servicios/presentation/notifiers/vehicle/start_service_state.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/vehicle/service_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StartServiceNotifier extends Notifier<StartVehicleServiceState> {
  @override
  StartVehicleServiceState build() => const StartVehicleServiceState();

  Future<void> startService(
    String serviceId,
    String location,
    int mileage,
  ) async {
    state = state.copyWith(status: Status.loading);

    final useCase = ref.read(startServiceUseCaseProvider);
    final result = await useCase.call(
      serviceId: serviceId,
      location: location,
      mileage: mileage,
    );

    state = result.fold(
      (failure) => state.copyWith(status: Status.error, error: failure.message),
      (_) => state.copyWith(status: Status.success),
    );
  }

  void reset() {
    state = const StartVehicleServiceState();
  }
}
