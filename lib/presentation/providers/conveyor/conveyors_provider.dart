import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/data/datasources/base_data_source.dart';
import 'package:crv_reprosisa/data/datasources/base_datasource_impl.dart';

import 'package:crv_reprosisa/data/models/conveyors/conveyors_model.dart';
import 'package:crv_reprosisa/data/repositories/conveyor/conveyors_repository_impl.dart';
import 'package:crv_reprosisa/domain/entities/conveyors/conveyors.dart';
import 'package:crv_reprosisa/domain/repositories/conveyor/conveyors_reposity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final conveyorsDataSourceProvider = Provider<BaseDataSource<Conveyors>>((ref) {
  final dio = ref.read(dioProvider);
  return BaseDataSourceImpl(
    dio: dio, 
    endpoint: "/conveyors", 
    fromJson: ConveyorsModel.fromJson,
  );
});

final conveyorsRepositoryProvider = Provider<ConveyorsReposity>((ref) {
  final dataSource = ref.read(conveyorsDataSourceProvider);
  return ConveyorsRepositoryImpl(dataSource);
});