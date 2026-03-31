import 'package:crv_reprosisa/features/assets/presentation/providers/vehicle_usecase_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/vehicle_list_state.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VehicleListNotifier extends Notifier<VehicleListState> {
  @override
  VehicleListState build() {
    return const VehicleListState();
  }

  Future<void> loadVehicles() async {
    state = state.copyWith(status: Status.loading);

    final getAllVehicle = ref.read(getAllVehicleUseCaseProvider);
    final result = await getAllVehicle();

    result.fold(
      (failure) {
        state = state.copyWith(status: Status.error, error: failure.message);
      },
      (vehicles) {
        state = state.copyWith(status: Status.success, vehicles: vehicles);
      },
    );
  }
}
