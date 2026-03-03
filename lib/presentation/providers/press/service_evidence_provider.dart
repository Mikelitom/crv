import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/data/datasources/base_data_source.dart';
import 'package:crv_reprosisa/data/datasources/base_datasource_impl.dart';

import 'package:crv_reprosisa/data/models/press/service_evidence_press_model.dart';
import 'package:crv_reprosisa/data/repositories/press/service_evidence_repository_impl..dart';
import 'package:crv_reprosisa/domain/entities/press/service_evidence_press.dart';
import 'package:crv_reprosisa/domain/repositories/press/service_evidence_press_reposity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final serviceEvidencePressDataSourceProvider = Provider<BaseDataSource<ServiceEvidencePress>>((ref) {
  final dio = ref.read(dioProvider);
  return BaseDataSourceImpl(
    dio: dio, 
    endpoint: "/press_service_evidence", 
    fromJson: ServiceEvidencePressModel.fromJson,
  );
});

final serviceEvidencePressRepositoryProvider = Provider<ServiceEvidencePressReposity>((ref) {
  final dataSource = ref.read(serviceEvidencePressDataSourceProvider);
  return ServiceEvidencePressReportsRepositoryImpl(dataSource);
});