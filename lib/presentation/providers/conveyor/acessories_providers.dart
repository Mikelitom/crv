import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/data/datasources/base_data_source.dart';
import 'package:crv_reprosisa/data/datasources/base_datasource_impl.dart';
import 'package:crv_reprosisa/data/models/conveyors/accesories_conveyor_model.dart';
import 'package:crv_reprosisa/data/repositories/conveyor/accesories_repository_impl.dart';
import 'package:crv_reprosisa/domain/entities/conveyors/accesories_conveyor.dart';
import 'package:crv_reprosisa/domain/repositories/conveyor/accesories_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final accesoriesDataSourceProvider = Provider<BaseDataSource<AccesoriesConveyor>>((ref) {
  final dio = ref.read(dioProvider);
  return BaseDataSourceImpl(
    dio: dio, 
    endpoint: "/accesories", 
    fromJson: AccesoriesConveyorModel.fromJson,
  );
});

final accesoriesRepositoryProvider = Provider<AccesoriesRepository>((ref) {
  final dataSource = ref.read(accesoriesDataSourceProvider);
  return AccesoriesRepositoryImpl(dataSource);
});