import 'package:crv_reprosisa/features/assets/domain/params/create_vehicle_params.dart';
import 'package:crv_reprosisa/features/assets/domain/usecases/create_vehicle.dart';
import 'package:crv_reprosisa/features/assets/domain/usecases/update_vehicle_image.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/vehicle_usecase_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/create_vehicle_state.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
import 'package:crv_reprosisa/features/evidence/presentation/providers/vehicle_image_service_provider.dart';
import 'package:crv_reprosisa/features/evidence/presentation/service/vehicle_image_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateVehicleNotifier extends Notifier<CreateVehicleState> {
  late final CreateVehicle _createVehicle;
  late final VehicleImageService _vehicleImageService;
  late final UpdateVehicleImage _updateVehicleImage;

  @override
  CreateVehicleState build() {
    _createVehicle = ref.read(createVehicleUseCaseProvider);
    _vehicleImageService = ref.read(vehicleImageServiceProvider);
    _updateVehicleImage = ref.read(updateVehicleImageUseCaseProvider);
    return const CreateVehicleState();
  }

  Future<void> create(CreateVehicleParams params) async {
    state = state.copyWith(status: Status.loading);

    print("IMAGE: ${params.image}");
    print("IMAGE PATH: ${params.image?.path}");

    try {
      final result = await _createVehicle(params);

      result.fold(
        (failure) {
          state = state.copyWith(
            status: Status.error,
            error: failure.message,
          );
        },
        (vehicle) async {
      
          if (params.image != null) {
      
            final uploadResult =
                await _vehicleImageService.uploadVehicleImage(
                  file: params.image!,
                  vehicleId: vehicle.vehicleId,
                );
      
            uploadResult.fold(
              (failure) {
                state = state.copyWith(
                  status: Status.error,
                  error: failure.message,
                );
              },
              (imagePath) async {
              
                final updateResult = await _updateVehicleImage(
                  id: vehicle.vehicleId,
                  imagePath: imagePath,
                );
              
                updateResult.fold(
                  (failure) {
                    state = state.copyWith(
                      status: Status.error,
                      error: failure.message,
                    );
                  },
                  (_) {
                    state = state.copyWith(
                      status: Status.success,
                    );
                  },
                );
              },
            );
      
          } else {
            state = state.copyWith(
              status: Status.success,
            );
          }
        },
      );
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final data = e.response?.data;

      if (statusCode == 409) {
        state = state.copyWith(
          status: Status.error,
          error:
              data?['detail'] ?? "Ya existe un vehiculo con la misma matricula",
        );
      }
      return;
    } catch (e) {
      state = state.copyWith(
        status: Status.error,
        error: "Error ineserado. Intenta de nuevo.",
      );
    }
  }
}
