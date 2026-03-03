import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/data/datasources/base_data_source.dart';
import 'package:crv_reprosisa/data/datasources/base_datasource_impl.dart';

import 'package:crv_reprosisa/data/models/press/component_press_model.dart';
import 'package:crv_reprosisa/data/repositories/press/component_press_repository_impl.dart';
import 'package:crv_reprosisa/domain/entities/press/component_press.dart';
import 'package:crv_reprosisa/domain/repositories/press/component_press_reposity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final componentPressDataSourceProvider = Provider<BaseDataSource<ComponentPress>>((ref) {
  final dio = ref.read(dioProvider);
  return BaseDataSourceImpl(
    dio: dio, 
    endpoint: "/parameters", 
    fromJson: ComponentPressModel.fromJson,
  );
});

final componentPressRepositoryProvider = Provider<ComponentPressReposity>((ref) {
  final dataSource = ref.read(componentPressDataSourceProvider);
  return ComponentPressRepositoryImpl(dataSource);
});