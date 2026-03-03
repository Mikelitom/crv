import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/data/datasources/base_data_source.dart';
import 'package:crv_reprosisa/data/datasources/base_datasource_impl.dart';

import 'package:crv_reprosisa/data/models/conveyors/reports_conveyor_model.dart';
import 'package:crv_reprosisa/data/repositories/conveyor/reports_conveyor_repository_impl.dart';
import 'package:crv_reprosisa/domain/entities/conveyors/reports_conveyor.dart';
import 'package:crv_reprosisa/domain/repositories/conveyor/reports_conveyor_reposity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reportsDataSourceProvider = Provider<BaseDataSource<ReportsConveyor>>((ref) {
  final dio = ref.read(dioProvider);
  return BaseDataSourceImpl(
    dio: dio, 
    endpoint: "/reports-conveyor", 
    fromJson: ReportsConveyorModel.fromJson,
  );
});

final reportsRepositoryProvider = Provider<ReportsConveyorReposity>((ref) {
  final dataSource = ref.read(reportsDataSourceProvider);
  return ReportsConveyorRepositoryImpl(dataSource);
});