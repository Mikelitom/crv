import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/vehicle_usecase_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/vehicle_history_state.dart';

// Usamos Notifier<State> igual que en tus otros archivos
class VehicleHistoryNotifier extends Notifier<VehicleHistoryState> {
  
  @override
  VehicleHistoryState build() {
    return const VehicleHistoryState(status: Status.initial);
  }

  Future<void> loadHistory(String vehicleId) async {
  state = state.copyWith(status: Status.loading);
  final result = await ref.read(getVehicleHistoryUseCaseProvider)(vehicleId);

  result.fold(
    (failure) => state = state.copyWith(status: Status.error, error: failure.message),
    (data) => state = state.copyWith(status: Status.success, history: data),
  );
}
}