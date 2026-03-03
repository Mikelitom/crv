import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/data/datasources/base_data_source.dart';
import 'package:crv_reprosisa/data/datasources/base_datasource_impl.dart';

import 'package:crv_reprosisa/data/models/vehicle/component_vehicle_model.dart';
import 'package:crv_reprosisa/data/repositories/vehicle/component_vehicle_repository_impl.dart';
import 'package:crv_reprosisa/domain/entities/vehicle/component_vehicle.dart';
import 'package:crv_reprosisa/domain/repositories/vehicle/component_vehicle_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final componentVehicleDataSourceProvider = Provider<BaseDataSource<ComponentVehicle>>((ref) {
  final dio = ref.read(dioProvider);
  return BaseDataSourceImpl(
    dio: dio, 
    endpoint: "/components-vehicle", 
    fromJson: ComponentVehicleModel.fromJson,
  );
});

final componentVehicleRepositoryProvider = Provider<ComponentVehicleRepository>((ref) {
  final dataSource = ref.read(componentVehicleDataSourceProvider);
  return ComponentVehicleRepositoryImpl(dataSource);
});