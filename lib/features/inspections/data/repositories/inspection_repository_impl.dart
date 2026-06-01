import 'package:crv_reprosisa/features/inspections/domain/entities/vehicle_inspection.dart';
import 'package:dartz/dartz.dart';
import 'package:crv_reprosisa/features/inspections/data/models/vehicle_report_detail_model.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failure.dart';
import '../../domain/repositories/inspection_repository.dart';
import '../datasource/inspection_remote_data_source.dart';
import '../../presentation/models/inspector_row_ui.dart';
import '../models/inspections_model.dart';
import '../models/vehicle_inspection_model.dart';
import '../../domain/entities/inspection.dart';

class InspectionRepositoryImpl implements InspectionRepository {
  final InspectionRemoteDataSource dataSource;

  InspectionRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<InspectionRowUI>>> getMyInspections() async {
    try {
      final result = await dataSource.getMyInspections();
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? "Error al cargar inspecciones"));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<VehicleInspection>>> getVehicleHistory(String vehicleId) async {
    try {
      final response = await dataSource.getVehicleHistory(vehicleId);
      final List<VehicleInspection> history = (response as List)
          .map((item) => VehicleInspectionModel.fromJson(item))
          .toList();
      return Right(history);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? "Error al cargar historial"));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Inspection>> getInspectionById(String id) async {
    try {
      final response = await dataSource.getInspectionById(id);
      return Right(InspectionModel.fromJson(response));
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? "Error al obtener la inspección"));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

@override
Future<Either<Failure, VehicleReportDetailModel>> getVehicleReportDetail(String id) async {
  try {
    final response = await dataSource.getVehicleReportDetail(id);
    final detail = VehicleReportDetailModel.fromJson(response);
    return Right(detail); 
  } on DioException catch (e) {
    return Left(ServerFailure(e.message ?? "Error"));
  } catch (e) {
    return Left(UnknownFailure(e.toString()));
  }
}
}