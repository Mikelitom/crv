import 'package:crv_reprosisa/features/assets/domain/usecases/activate_vehicle.dart';
import 'package:crv_reprosisa/features/assets/domain/usecases/create_vehicle.dart';
import 'package:crv_reprosisa/features/assets/domain/usecases/desactivate_vehicle.dart';
import 'package:crv_reprosisa/features/assets/domain/usecases/get_all_vehicle.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/vehicle_repository_provider.dart';
import 'package:crv_reprosisa/features/assets/domain/usecases/update_vehicle.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final createVehicleUseCaseProvider = Provider<CreateVehicle>((ref) {
  final repository = ref.read(vehicleRepositoryProvider);
  return CreateVehicle(repository);
});
final activateVehicleUseCaseProvider = Provider<ActivateVehicle>((ref) {
  return ActivateVehicle(ref.read(vehicleRepositoryProvider));
});
final updateVehicleUseCaseProvider = Provider<UpdateVehicle>((ref) {
  return UpdateVehicle(ref.read(vehicleRepositoryProvider));
});
final deactivateVehicleUseCaseProvider = Provider<DeactivateVehicle>((ref) {
  return DeactivateVehicle(ref.read(vehicleRepositoryProvider));
});
final getAllVehicleUseCaseProvider = Provider<GetAllVehicle>((ref) {
  final repository = ref.read(vehicleRepositoryProvider);
  return GetAllVehicle(repository);
});
