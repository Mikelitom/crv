import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/data/datasources/base_data_source.dart';
import 'package:crv_reprosisa/data/datasources/base_datasource_impl.dart';

import 'package:crv_reprosisa/data/models/vehicle/vehicle_model.dart';
import 'package:crv_reprosisa/data/repositories/vehicle/vehicle_repository_impl.dart';
import 'package:crv_reprosisa/domain/entities/vehicle/vehicle.dart';
import 'package:crv_reprosisa/domain/repositories/vehicle/vehicle_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final vehicleDataSourceProvider = Provider<BaseDataSource<Vehicle>>((ref) {
  final dio = ref.read(dioProvider);
  return BaseDataSourceImpl(
    dio: dio, 
    endpoint: "/vehicle_options", 
    fromJson: VehicleModel.fromJson,
  );
});

final vehicleRepositoryProvider = Provider<VehicleRepository>((ref) {
  final dataSource = ref.read(vehicleDataSourceProvider);
  return VehicleRepositoryImpl(dataSource);
});