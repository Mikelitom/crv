import 'package:crv_reprosisa/features/assets/domain/params/create_vehicle_params.dart';
import 'package:crv_reprosisa/features/assets/domain/usecases/update_vehicle.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/vehicle_usecase_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/vehicle_state.dart'; // Asegúrate de tener este estado
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateVehicleNotifier extends Notifier<VehicleState> {
  late final UpdateVehicle _updateVehicle;

  @override
  VehicleState build() {
    _updateVehicle = ref.read(updateVehicleUseCaseProvider);
    return const VehicleState(status: Status.initial);
  }

  Future<void> update(String id, CreateVehicleParams params) async {
    state = state.copyWith(
      status: Status.loading,
      clearError: true,
      clearMessage: true,
    );

    try {
      final result = await _updateVehicle(id, params);

      result.fold(
        (failure) {
          state = state.copyWith(status: Status.error, error: failure.message);
        },
        (_) {
          state = state.copyWith(
            status: Status.success,
            message: "Vehículo actualizado correctamente",
          );
        },
      );
    } on DioException catch (e) {
      final data = e.response?.data;
      // Manejo de errores específico según tu API
      state = state.copyWith(
        status: Status.error,
        error: data?['detail'] ?? "Error al actualizar el vehículo",
      );
    } catch (e) {
      state = state.copyWith(
        status: Status.error,
        error: "Error inesperado. Intenta de nuevo.",
      );
    }
  }
}