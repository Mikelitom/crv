import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/data/datasources/base_data_source.dart';
import 'package:crv_reprosisa/data/datasources/base_datasource_impl.dart';

import 'package:crv_reprosisa/data/models/vehicle/vehicle_eval_options_model.dart';
import 'package:crv_reprosisa/data/repositories/vehicle/vehicle_eval_options_repository_impl.dart';
import 'package:crv_reprosisa/domain/entities/vehicle/vehicle_eval_options.dart';
import 'package:crv_reprosisa/domain/repositories/vehicle/vehicle_eval_options_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final vehicleEvalOptionsDataSourceProvider = Provider<BaseDataSource<VehicleEvalOptions>>((ref) {
  final dio = ref.read(dioProvider);
  return BaseDataSourceImpl(
    dio: dio, 
    endpoint: "/vehicle_options", 
    fromJson: VehicleEvalOptionsModel.fromJson,
  );
});

final vehicleEvalOptionsRepositoryProvider = Provider<VehicleEvalOptionsRepository>((ref) {
  final dataSource = ref.read(vehicleEvalOptionsDataSourceProvider);
  return VehicleEvalOptionsRepositoryImpl(dataSource);
});