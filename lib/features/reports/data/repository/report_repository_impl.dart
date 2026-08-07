import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:crv_reprosisa/core/error/failure.dart';
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
    return await remoteDatasource.getVehicleHistory();
  }

  @override
  Future<List<ConveyorReportEntity>> getAllConveyorReports() async {
    return await remoteDatasource.getConveyorHistory();
  }

  @override
  Future<void> sendConveyorReviewNote(String versionId, String notes) async {
    return await remoteDatasource.sendConveyorReviewNote(versionId, notes);
  }

  @override
  Future<List<PressReportEntity>> getAllPressReports() async {
    return await remoteDatasource.getPressHistory();
  }

  @override
  Future<void> acceptReport(String reportId) async {
    return await remoteDatasource.acceptReport(reportId);
  }

  @override
  Future<Either<Failure, List<String>>> getClientEmails(String clientId) async {
    try {
      final emails = await remoteDatasource.getClientEmails(clientId);
      return Right(emails);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data?['message'] ?? e.message ?? "Error de servidor"));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> sendReportEmail({
    required String versionId,
    required String email,
    required String message,
    required Uint8List pdfBytes,
  }) async {
    try {
      await remoteDatasource.sendReportEmail(
        versionId: versionId,
        email: email,
        message: message,
        pdfBytes: pdfBytes,
      );
      return const Right(unit);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data?['message'] ?? e.message ?? "Error de servidor"));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}