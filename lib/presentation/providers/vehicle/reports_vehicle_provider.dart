import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/data/datasources/base_data_source.dart';
import 'package:crv_reprosisa/data/datasources/base_datasource_impl.dart';

import 'package:crv_reprosisa/data/models/vehicle/reports_vehicle_model.dart';
import 'package:crv_reprosisa/data/repositories/vehicle/reports_vehicle_repository_impl.dart';
import 'package:crv_reprosisa/domain/entities/vehicle/reports_vehicle.dart';
import 'package:crv_reprosisa/domain/repositories/vehicle/reports_vehicle_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reportVehicleDataSourceProvider = Provider<BaseDataSource<ReportsVehicle>>((ref) {
  final dio = ref.read(dioProvider);
  return BaseDataSourceImpl(
    dio: dio, 
    endpoint: "/vehicle-reports", 
    fromJson: ReportsVehicleModel.fromJson,
  );
});

final reportVehicleRepositoryProvider = Provider<ReportsVehicleRepository>((ref) {
  final dataSource = ref.read(reportVehicleDataSourceProvider);
  return ReportsVehicleRepositoryImpl(dataSource);
});