import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/data/datasources/base_data_source.dart';
import 'package:crv_reprosisa/data/datasources/base_datasource_impl.dart';

import 'package:crv_reprosisa/data/models/vehicle/service_evidence_vehicle_model.dart';
import 'package:crv_reprosisa/data/repositories/vehicle/service_evidence_vehicle_repository_impl.dart';
import 'package:crv_reprosisa/domain/entities/vehicle/service_evidence_vehicle.dart';
import 'package:crv_reprosisa/domain/repositories/vehicle/service_evidence_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final serviceEvidenceVehicleDataSourceProvider = Provider<BaseDataSource<ServiceEvidenceVehicle>>((ref) {
  final dio = ref.read(dioProvider);
  return BaseDataSourceImpl(
    dio: dio, 
    endpoint: "/vehicle_service_evidence", 
    fromJson: ServiceEvidenceVehicleModel.fromJson,
  );
});

final serviceEvidenceVehicleRepositoryProvider = Provider<ServiceEvidenceRepository>((ref) {
  final dataSource = ref.read(serviceEvidenceVehicleDataSourceProvider);
  return ServiceEvidenceVehicleRepositoryImpl(dataSource);
});