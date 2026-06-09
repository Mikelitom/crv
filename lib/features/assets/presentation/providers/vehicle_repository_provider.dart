import 'package:crv_reprosisa/features/assets/data/repositories/vehicle_repository_impl.dart';
import 'package:crv_reprosisa/features/assets/domain/repositories/vehicle_repository.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/vehicle_remote_datasource_provider.dart';
import 'package:crv_reprosisa/features/vehiculos/presentation/provider/vehicle_inspection_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final vehicleRepositoryProvider = Provider<VehicleRepository>((ref) {
  final local = ref.read(vehicleLocalDatasourceProvider);
  final datasource = ref.read(vehicleRemoteDatasourceProvider);
  return VehicleRepositoryImpl(datasource, local);
});
