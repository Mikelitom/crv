import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/data/datasources/base_data_source.dart';
import 'package:crv_reprosisa/data/datasources/base_datasource_impl.dart';

import 'package:crv_reprosisa/data/models/conveyors/area_model.dart';
import 'package:crv_reprosisa/data/repositories/conveyor/area_repository_impl.dart';
import 'package:crv_reprosisa/domain/entities/conveyors/area.dart';
import 'package:crv_reprosisa/domain/repositories/conveyor/area_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final areaDataSourceProvider = Provider<BaseDataSource<Area>>((ref) {
  final dio = ref.read(dioProvider);
  return BaseDataSourceImpl(
    dio: dio, 
    endpoint: "/areas", 
    fromJson: AreaModel.fromJson,
  );
});

final areaRepositoryProvider = Provider<AreaRepository>((ref) {
  final dataSource = ref.read(areaDataSourceProvider);
  return AreaRepositoryImpl(dataSource);
});