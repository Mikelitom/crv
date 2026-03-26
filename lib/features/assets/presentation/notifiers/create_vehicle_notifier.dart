import 'package:crv_reprosisa/features/assets/domain/params/create_vehicle_params.dart';
import 'package:crv_reprosisa/features/assets/domain/usecases/create_vehicle.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/vehicle_usecase_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/create_vehicle_state.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateVehicleNotifier extends Notifier<CreateVehicleState> {
  late final CreateVehicle _createVehicle;

  @override
  CreateVehicleState build() {
    _createVehicle = ref.read(createVehicleUseCaseProvider);
    return const CreateVehicleState();
  }

  Future<void> create(CreateVehicleParams params) async {
    state = state.copyWith(status: Status.loading);

    final result = await _createVehicle(params);

    result.fold(
      (failure) {
        state = state.copyWith(status: Status.error, error: failure.message);
      },
      (_) {
        state = state.copyWith(status: Status.success);
      },
    );
  }
}
