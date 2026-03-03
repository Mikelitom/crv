import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/data/datasources/base_data_source.dart';
import 'package:crv_reprosisa/data/datasources/base_datasource_impl.dart';
import 'package:crv_reprosisa/data/models/conveyors/accesory_options_conveyor_model.dart';
import 'package:crv_reprosisa/data/repositories/conveyor/acessories_options_repository_imp.dart';
import 'package:crv_reprosisa/domain/entities/conveyors/accesory_options_conveyor.dart';
import 'package:crv_reprosisa/domain/repositories/conveyor/accesory_options_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final accesoriesOptionsDataSourceProvider = Provider<BaseDataSource<AccesoryOptionsConveyor>>((ref) {
  final dio = ref.read(dioProvider);
  return BaseDataSourceImpl(
    dio: dio, 
    endpoint: "/accesories_option", 
    fromJson: AccesoryOptionsConveyorModel.fromJson,
  );
});

final accesoriesOptionsRepositoryProvider = Provider<AccesoryOptionsRepository>((ref) {
  final dataSource = ref.read(accesoriesOptionsDataSourceProvider);
  return AccesoriesOptionsRepositoryImpl(dataSource);
});