import 'package:crv_reprosisa/features/assets/presentation/providers/press_repository_provider.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/vehicle_repository_provider.dart';
import 'package:crv_reprosisa/features/prensas_industriales/presentation/provider/inspeccion_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> loadInitialDataAfterLogin(Ref ref) async {
  final pressRepo = ref.read(pressRepositoryProvider);
  final pressInspRepo = ref.read(inspeccionRepositoryProvider);
  final vehicleRepo = ref.read(vehicleRepositoryProvider);

  await pressRepo.getAllPress();
  await pressInspRepo.getLoanAreas();
  await vehicleRepo.getAllVehicle();

  // presses.fold(
  //   (_) {},
  //   (data) => ref.read(pressStateProvider.notifier).setAll(data),
  // );

  // vehicles.fold(
  //   (_) {},
  //   (data) => ref.read(vehicleStateProvider.notifier).setAll(data),
  // );
}
