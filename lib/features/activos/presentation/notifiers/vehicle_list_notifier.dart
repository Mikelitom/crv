import 'package:crv_reprosisa/features/activos/domain/usecases/get_all_vehicle.dart';
import 'package:crv_reprosisa/features/activos/presentation/providers/vehicle_usecase_provider.dart';
import 'package:crv_reprosisa/features/activos/presentation/states/vehicle_list_state.dart';
import 'package:crv_reprosisa/features/activos/presentation/states/status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VehicleListNotifier extends Notifier<VehicleListState> {
  late final GetAllVehicle _getAllVehicle;

  @override
  VehicleListState build() {
    _getAllVehicle = ref.read(getAllVehicleUseCaseProvider);
    return const VehicleListState();
  }

  Future<void> loadVehicle() async {
    state = state.copyWith(status: Status.loading);

    final result = await _getAllVehicle();

    result.fold(
      (failure) {
        state = state.copyWith(status: Status.error, error: failure.message);
      },
      (vehicle) {
        state = state.copyWith(status: Status.success, vehicle: vehicle);
      },
    );
  }
}
