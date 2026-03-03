import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/data/datasources/base_data_source.dart';
import 'package:crv_reprosisa/data/datasources/base_datasource_impl.dart';

import 'package:crv_reprosisa/data/models/press/answers_press_model.dart';
import 'package:crv_reprosisa/data/repositories/press/answer_press_repository_impl.dart';
import 'package:crv_reprosisa/domain/entities/press/answers_press.dart';
import 'package:crv_reprosisa/domain/repositories/press/answers_press_reposity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final answerPressDataSourceProvider = Provider<BaseDataSource<AnswersPress>>((ref) {
  final dio = ref.read(dioProvider);
  return BaseDataSourceImpl(
    dio: dio, 
    endpoint: "/answer_press", 
    fromJson: AnswersPressModel.fromJson,
  );
});

final answerPressRepositoryProvider = Provider<AnswersPressReposity>((ref) {
  final dataSource = ref.read(answerPressDataSourceProvider);
  return AnswersPressRepositoryImpl(dataSource);
});