import 'package:crv_reprosisa/features/activos/domain/usecases/create_vehicle.dart';
import 'package:crv_reprosisa/features/activos/domain/usecases/get_all_vehicle.dart';
import 'package:crv_reprosisa/features/activos/presentation/providers/vehicle_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final createVehicleUseCaseProvider = Provider<CreateVehicle>((ref) {
  final repository = ref.read(vehicleRepositoryProvider);
  return CreateVehicle(repository);
});

final getAllVehicleUseCaseProvider = Provider<GetAllVehicle>((ref) {
  final repository = ref.read(vehicleRepositoryProvider);
  return GetAllVehicle(repository);
});
