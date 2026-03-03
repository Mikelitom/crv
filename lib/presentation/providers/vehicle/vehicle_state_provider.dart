import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/data/datasources/base_data_source.dart';
import 'package:crv_reprosisa/data/datasources/base_datasource_impl.dart';

import 'package:crv_reprosisa/data/models/vehicle/vehicle_state_model.dart';
import 'package:crv_reprosisa/data/repositories/vehicle/vehicle_state_repository_impl.dart';
import 'package:crv_reprosisa/domain/entities/vehicle/vehicle_state.dart';
import 'package:crv_reprosisa/domain/repositories/vehicle/vehicle_state_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final vehicleStateDataSourceProvider = Provider<BaseDataSource<VehicleState>>((ref) {
  final dio = ref.read(dioProvider);
  return BaseDataSourceImpl(
    dio: dio, 
    endpoint: "/vehicle_state", 
    fromJson: VehicleStateModel.fromJson,
  );
});

final vehicleStateRepositoryProvider = Provider<VehicleStateRepository>((ref) {
  final dataSource = ref.read(vehicleStateDataSourceProvider);
  return VehicleStateRepositoryImpl(dataSource);
});