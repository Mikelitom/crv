import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/data/datasources/base_data_source.dart';
import 'package:crv_reprosisa/data/datasources/base_datasource_impl.dart';

import 'package:crv_reprosisa/data/models/vehicle/report_answers_vehicle_model.dart';
import 'package:crv_reprosisa/data/repositories/vehicle/report_answer_vehicle_repository_impl.dart';
import 'package:crv_reprosisa/domain/entities/vehicle/report_answers.dart';
import 'package:crv_reprosisa/domain/repositories/vehicle/report_answers_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reportAnswerVehicleDataSourceProvider = Provider<BaseDataSource<ReportAnswersVehicle>>((ref) {
  final dio = ref.read(dioProvider);
  return BaseDataSourceImpl(
    dio: dio, 
    endpoint: "/answer-vehicle", 
    fromJson: ReportAnswersVehicleModel.fromJson,
  );
});

final reportAnswerVehicleRepositoryProvider = Provider<ReportAnswersRepository>((ref) {
  final dataSource = ref.read(reportAnswerVehicleDataSourceProvider);
  return ReportAnswersVehicleRepositoryImpl(dataSource);
});