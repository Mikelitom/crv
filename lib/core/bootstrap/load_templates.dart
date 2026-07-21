import 'package:crv_reprosisa/features/bandas_transportadoras/presentation/provider/banda_inspection_providers.dart';
import 'package:crv_reprosisa/features/prensas_industriales/presentation/provider/inspeccion_providers.dart';
import 'package:crv_reprosisa/features/vehiculos/presentation/provider/vehicle_inspection_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> loadTemplates(Ref ref) async {
  final pressRepo = ref.read(inspeccionRepositoryProvider);
  final vehicleRepo = ref.read(vehicleRepositoryProvider);
  final clientRepo = ref.read(bandaRepositoryProvider);

  await pressRepo.getInspectionTemplate();
  await vehicleRepo.getVehicleTemplate();
  await clientRepo.getBandaTemplate();
}
