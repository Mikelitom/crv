import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/data/datasources/base_data_source.dart';
import 'package:crv_reprosisa/data/datasources/base_datasource_impl.dart';

import 'package:crv_reprosisa/data/models/press/presses_model.dart';
import 'package:crv_reprosisa/data/repositories/press/presses_repository_impl.dart';
import 'package:crv_reprosisa/domain/entities/press/presses.dart';
import 'package:crv_reprosisa/domain/repositories/press/presses_reposity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pressesDataSourceProvider = Provider<BaseDataSource<Presses>>((ref) {
  final dio = ref.read(dioProvider);
  return BaseDataSourceImpl(
    dio: dio, 
    endpoint: "/presses", 
    fromJson: PressesModel.fromJson,
  );
});

final pressesRepositoryProvider = Provider<PressesReposity>((ref) {
  final dataSource = ref.read(pressesDataSourceProvider);
  return PressesReportsRepositoryImpl(dataSource);
});