import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failure.dart';
import '../../domain/repositories/inspection_repository.dart';
import '../datasource/inspection_remote_data_source.dart';
import '../../presentation/models/inspector_row_ui.dart';
import '../models/inspections_model.dart';
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
Future<Either<Failure, Inspection>> getInspectionById(String id) async {
  try {
    final response = await dataSource.getInspectionById(id);
    return Right(InspectionModel.fromJson(response)); // Tu mapeo correspondiente
  } on DioException catch (e) {
    return Left(ServerFailure(e.message ?? "Error al obtener la inspección"));
  }
}
}