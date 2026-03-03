import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/data/datasources/base_data_source.dart';
import 'package:crv_reprosisa/data/datasources/base_datasource_impl.dart';

import 'package:crv_reprosisa/data/models/vehicle/evidence_vehicle_model.dart';
import 'package:crv_reprosisa/data/repositories/vehicle/evidence_vehicle_repository_impl.dart';
import 'package:crv_reprosisa/domain/entities/vehicle/evidence_vehicle.dart';
import 'package:crv_reprosisa/domain/repositories/vehicle/evidence_vehicle_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final evidenceVehicleDataSourceProvider = Provider<BaseDataSource<EvidenceVehicle>>((ref) {
  final dio = ref.read(dioProvider);
  return BaseDataSourceImpl(
    dio: dio, 
    endpoint: "/vehicle-evidences", 
    fromJson: EvidenceVehicleModel.fromJson,
  );
});

final evidenceVehicleRepositoryProvider = Provider<EvidenceVehicleRepository>((ref) {
  final dataSource = ref.read(evidenceVehicleDataSourceProvider);
  return EvidenceVehicleRepositoryImpl(dataSource);
});