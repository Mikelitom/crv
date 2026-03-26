import 'package:crv_reprosisa/features/assets/data/repositories/type_repository_impl.dart';
import 'package:crv_reprosisa/features/assets/domain/repositories/vehicle_type_repository.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/type_remote_datasource_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final typeRepositoryProvider = Provider<VehicleTypeRepository>((ref) {
  final datasource = ref.read(typeRemoteDatasourceProvider);
  return TypeRepositoryImpl(datasource);
});
