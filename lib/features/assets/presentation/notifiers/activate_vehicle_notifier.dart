import 'package:crv_reprosisa/features/assets/presentation/providers/vehicle_usecase_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/vehicle_state.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActivateVehicleNotifier extends Notifier<VehicleState> {
  @override
  VehicleState build() => const VehicleState(status: Status.initial);

  Future<void> activate(String id) async {
    state = state.copyWith(status: Status.loading);
    final result = await ref.read(activateVehicleUseCaseProvider).call(id);
    result.fold(
      (f) => state = state.copyWith(status: Status.error, error: f.message),
      (_) => state = state.copyWith(status: Status.success, message: "Activado"),
    );
  }
}