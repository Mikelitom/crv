import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/data/datasources/base_data_source.dart';
import 'package:crv_reprosisa/data/datasources/base_datasource_impl.dart';

import 'package:crv_reprosisa/data/models/press/press_reports_model.dart';
import 'package:crv_reprosisa/data/repositories/press/press_reports_repository_impl.dart';
import 'package:crv_reprosisa/domain/entities/press/press_reports.dart';
import 'package:crv_reprosisa/domain/repositories/press/press_reports_reposity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pressReportDataSourceProvider = Provider<BaseDataSource<PressReports>>((ref) {
  final dio = ref.read(dioProvider);
  return BaseDataSourceImpl(
    dio: dio, 
    endpoint: "/press-reports", 
    fromJson: PressReportsModel.fromJson,
  );
});

final pressReportRepositoryProvider = Provider<PressReportsReposity>((ref) {
  final dataSource = ref.read(pressReportDataSourceProvider);
  return PressReportsRepositoryImpl(dataSource);
});