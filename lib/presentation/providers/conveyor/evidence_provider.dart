import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/data/datasources/base_data_source.dart';
import 'package:crv_reprosisa/data/datasources/base_datasource_impl.dart';

import 'package:crv_reprosisa/data/models/conveyors/evidence_conveyor_model.dart';
import 'package:crv_reprosisa/data/repositories/conveyor/evidence_conveyor_repository_impl.dart';
import 'package:crv_reprosisa/domain/entities/conveyors/evidence_conveyor.dart';
import 'package:crv_reprosisa/domain/repositories/conveyor/evidence_conveyor_reposity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final evidenceDataSourceProvider = Provider<BaseDataSource<EvidenceConveyor>>((ref) {
  final dio = ref.read(dioProvider);
  return BaseDataSourceImpl(
    dio: dio, 
    endpoint: "/evidence-conveyor", 
    fromJson: EvidenceConveyorModel.fromJson,
  );
});

final evidenceRepositoryProvider = Provider<EvidenceConveyorReposity>((ref) {
  final dataSource = ref.read(evidenceDataSourceProvider);
  return EvidenceConveyorRepositoryImpl(dataSource);
});