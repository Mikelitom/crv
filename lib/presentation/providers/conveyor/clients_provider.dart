import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/data/datasources/base_data_source.dart';
import 'package:crv_reprosisa/data/datasources/base_datasource_impl.dart';

import 'package:crv_reprosisa/data/models/conveyors/clients_conveyor_model.dart';
import 'package:crv_reprosisa/data/repositories/conveyor/clients_conveyor_repository_impl.dart';
import 'package:crv_reprosisa/domain/entities/conveyors/clients_conveyor.dart';
import 'package:crv_reprosisa/domain/repositories/conveyor/clients_conveyor_reposity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final clientsDataSourceProvider = Provider<BaseDataSource<ClientsConveyor>>((ref) {
  final dio = ref.read(dioProvider);
  return BaseDataSourceImpl(
    dio: dio, 
    endpoint: "/clients", 
    fromJson: ClientsConveyorModel.fromJson,
  );
});

final clientsRepositoryProvider = Provider<ClientsConveyorReposity>((ref) {
  final dataSource = ref.read(clientsDataSourceProvider);
  return ClientsConveyorRepositoryImpl(dataSource);
});