import 'package:crv_reprosisa/features/assets/domain/params/create_vehicle_params.dart';
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
    final result = await getAllVehicle.call(); // Asegúrate de usar .call()

    result.fold(
      (failure) {
        state = state.copyWith(status: Status.error, error: failure.message);
      },
      (vehicles) {
        state = state.copyWith(status: Status.success, vehicles: vehicles);
      },
    );
  }

  Future<void> toggleVehicleStatus(String id, bool isActive) async {
    state = state.copyWith(status: Status.loading);

    final result = isActive 
        ? await ref.read(activateVehicleUseCaseProvider).call(id)
        : await ref.read(deactivateVehicleUseCaseProvider).call(id);

    result.fold(
      (failure) {
        state = state.copyWith(status: Status.error, error: failure.message);
        loadVehicles(); 
      },
      (_) {
        loadVehicles();
      },
    );
  }

  // --- MÉTODO AGREGADO ---
  Future<void> updateVehicle(String id, CreateVehicleParams params) async {
    state = state.copyWith(status: Status.loading);

    // Llamamos al caso de uso de actualización
    final result = await ref.read(updateVehicleUseCaseProvider).call(id, params);

    result.fold(
      (failure) {
        state = state.copyWith(status: Status.error, error: failure.message);
      },
      (_) {
        // Recargamos la lista para ver los cambios reflejados
        loadVehicles();
      },
    );
  }
}