import 'package:crv_reprosisa/features/activos/data/repositories/type_repository_impl.dart';
import 'package:crv_reprosisa/features/activos/domain/repositories/vehicle_type_repository.dart';
import 'package:crv_reprosisa/features/activos/presentation/providers/type_remote_datasource_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final typeRepositoryProvider = Provider<VehicleTypeRepository>((ref) {
  final datasource = ref.read(typeRemoteDatasourceProvider);
  return TypeRepositoryImpl(datasource);
});
