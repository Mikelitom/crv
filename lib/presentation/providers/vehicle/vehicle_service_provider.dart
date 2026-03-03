import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/data/datasources/base_data_source.dart';
import 'package:crv_reprosisa/data/datasources/base_datasource_impl.dart';

import 'package:crv_reprosisa/data/models/vehicle/vehicle_service_model.dart';
import 'package:crv_reprosisa/data/repositories/vehicle/vehicle_service_repository_impl.dart';
import 'package:crv_reprosisa/domain/entities/vehicle/vehicle_service.dart';
import 'package:crv_reprosisa/domain/repositories/vehicle/vehicle_service_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final vehicleServiceDataSourceProvider = Provider<BaseDataSource<VehicleService>>((ref) {
  final dio = ref.read(dioProvider);
  return BaseDataSourceImpl(
    dio: dio, 
    endpoint: "/vehicle_service", 
    fromJson: VehicleServiceModel.fromJson,
  );
});

final vehicleServiceRepositoryProvider = Provider<VehicleServiceRepository>((ref) {
  final dataSource = ref.read(vehicleServiceDataSourceProvider);
  return VehicleServiceRepositoryImpl(dataSource);
});