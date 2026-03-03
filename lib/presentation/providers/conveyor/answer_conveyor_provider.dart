import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/data/datasources/base_data_source.dart';
import 'package:crv_reprosisa/data/datasources/base_datasource_impl.dart';

import 'package:crv_reprosisa/data/models/conveyors/answers_conveyor_model.dart';
import 'package:crv_reprosisa/data/repositories/conveyor/answers_conveyor_repository_impl.dart';
import 'package:crv_reprosisa/domain/entities/conveyors/answers_conveyor.dart';
import 'package:crv_reprosisa/domain/repositories/conveyor/answers_conveyor_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final answersConveyorDataSourceProvider = Provider<BaseDataSource<AnswersConveyor>>((ref) {
  final dio = ref.read(dioProvider);
  return BaseDataSourceImpl(
    dio: dio, 
    endpoint: "/answers-conveyor", 
    fromJson: AnswersConveyorModel.fromJson,
  );
});

final answersConveyorRepositoryProvider = Provider<AnswersConveyorRepository>((ref) {
  final dataSource = ref.read(answersConveyorDataSourceProvider);
  return AnswersConveyorRepositoryImpl(dataSource);
});