import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/data/datasources/base_data_source.dart';
import 'package:crv_reprosisa/data/datasources/base_datasource_impl.dart';

import 'package:crv_reprosisa/data/models/vehicle/report_notes_vehicle_model.dart';
import 'package:crv_reprosisa/data/repositories/vehicle/report_notes_vehicle_repository_impl.dart';
import 'package:crv_reprosisa/domain/entities/vehicle/report_notes.dart';
import 'package:crv_reprosisa/domain/repositories/vehicle/report_notes_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reportNotesVehicleDataSourceProvider = Provider<BaseDataSource<ReportNotesVehicle>>((ref) {
  final dio = ref.read(dioProvider);
  return BaseDataSourceImpl(
    dio: dio, 
    endpoint: "/vehicle-notes", 
    fromJson: ReportNotesVehicleModel.fromJson,
  );
});

final reportNotesVehicleRepositoryProvider = Provider<ReportNotesRepository>((ref) {
  final dataSource = ref.read(reportNotesVehicleDataSourceProvider);
  return ReportNotesVehicleRepositoryImpl(dataSource);
});