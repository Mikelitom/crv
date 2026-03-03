import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/data/datasources/base_data_source.dart';
import 'package:crv_reprosisa/data/datasources/base_datasource_impl.dart';

import 'package:crv_reprosisa/data/models/press/evidence_press_model.dart';
import 'package:crv_reprosisa/data/repositories/press/evidence_press_repository_impl.dart';
import 'package:crv_reprosisa/domain/entities/press/evidence_press.dart';
import 'package:crv_reprosisa/domain/repositories/press/evidence_press_reposity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final evidencePressDataSourceProvider = Provider<BaseDataSource<EvidencePress>>((ref) {
  final dio = ref.read(dioProvider);
  return BaseDataSourceImpl(
    dio: dio, 
    endpoint: "/evidences", 
    fromJson: EvidencePressModel.fromJson,
  );
});

final evidencePressRepositoryProvider = Provider<EvidencePressReposity>((ref) {
  final dataSource = ref.read(evidencePressDataSourceProvider);
  return EvidencePressRepositoryImpl(dataSource);
});