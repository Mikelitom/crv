import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../states/catalogo_state.dart';
import '../providers/catalogo_providers.dart';
import '../../data/models/vehicle_state_model.dart';

class CatalogoNotifier extends Notifier<CatalogoState> {
  @override
  CatalogoState build() => CatalogoState();

  Future<void> loadVehicles() async {
    state = state.copyWith(status: CatalogoStatus.loading);
    
    final getVehicles = ref.read(getVehiclesUseCaseProvider);
    final result = await getVehicles.call();

    result.fold(
      (failure) => state = state.copyWith(status: CatalogoStatus.error, errorMessage: failure.message),
      (List<VehicleStateModel> list) {
        state = state.copyWith(
          status: CatalogoStatus.success, 
          vehicles: list,
        );
      }
    );
  }

  // loadPresses, updateSearch, etc...
}