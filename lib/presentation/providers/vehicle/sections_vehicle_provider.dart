import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/data/datasources/base_data_source.dart';
import 'package:crv_reprosisa/data/datasources/base_datasource_impl.dart';

import 'package:crv_reprosisa/data/models/vehicle/sections_vehicle_model.dart';
import 'package:crv_reprosisa/data/repositories/vehicle/sections_vehicle_repository_impl.dart';
import 'package:crv_reprosisa/domain/entities/vehicle/sections._vehicle.dart';
import 'package:crv_reprosisa/domain/repositories/vehicle/sections_vehicle_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sectionsVehicleDataSourceProvider = Provider<BaseDataSource<SectionsVehicle>>((ref) {
  final dio = ref.read(dioProvider);
  return BaseDataSourceImpl(
    dio: dio, 
    endpoint: "/vehicle-sections", 
    fromJson: SectionsVehicleModel.fromJson,
  );
});

final sectionsVehicleRepositoryProvider = Provider<SectionsVehicleRepository>((ref) {
  final dataSource = ref.read(sectionsVehicleDataSourceProvider);
  return SectionsVehicleRepositoryImpl(dataSource);
});