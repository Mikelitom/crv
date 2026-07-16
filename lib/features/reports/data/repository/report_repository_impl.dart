import 'package:crv_reprosisa/features/reports/domain/entities/conveyor_report_entity.dart';
import 'package:crv_reprosisa/features/reports/domain/entities/press_report_entity.dart';
import 'package:crv_reprosisa/features/reports/domain/entities/vehicle_report_entity.dart';
import 'package:crv_reprosisa/features/reports/domain/repository/report_repository.dart';

import '../datasource/report_remote_datasource.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportRemoteDatasource remoteDatasource;

  ReportRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<VehicleReportEntity>> getAllVehicleReports() async {
    return await remoteDatasource.getVehicleHistory(); // Ya devuelve los modelos
  }

  @override
  Future<List<ConveyorReportEntity>> getAllConveyorReports() async {
    return await remoteDatasource.getConveyorHistory();
  }

  @override
  Future<List<PressReportEntity>> getAllPressReports() async {
    return await remoteDatasource.getPressHistory();
  }
}