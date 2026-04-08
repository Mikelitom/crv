import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/entities_press.dart';
import '../../domain/entities/component_item.dart';
import '../../domain/repositories/inspeccion_repository.dart';
import '../models/component_model.dart';
import '../datasource/inspeccion_datasource_remote.dart';

class InspeccionRepositoryImpl implements InspeccionRepository {
  final InspeccionRemoteDataSource dataSource;
  InspeccionRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<ComponentItem>>> getInspectionTemplate() async {
    try {
      final List<dynamic> data = await dataSource.getInspectionTemplate();
      final items = data
          .map((json) => PrensaComponentItem.fromJson(json))
          .toList();
      return Right(items);
    } on DioException catch (e) {
      return Left(
        ServerFailure(e.message ?? "Error al conectar con el servidor"),
      );
    } catch (e) {
      return const Left(UnknownFailure("Error al procesar el formulario"));
    }
  }

  @override
  Future<Either<Failure, Press>> getPressBySerie(String serie) async {
    try {
      final press = await dataSource.getPressBySerie(serie);
      if (press != null) return Right(press);
      return const Left(ServerFailure("No se encontró la prensa"));
    } catch (e) {
      return const Left(UnknownFailure("Error inesperado"));
    }
  }

  @override
  Future<Either<Failure, List<String>>> fetchAllSeries() async {
    try {
      final series = await dataSource.getAllSeries();
      return Right(series);
    } catch (e) {
      return const Left(ServerFailure("Error al cargar series"));
    }
  }

  @override
  Future<Either<Failure, Unit>> createPressReport(
    Map<String, dynamic> reportData,
  ) async {
    try {
      await dataSource.savePressReport(reportData);
      return const Right(unit);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? "Error al enviar el reporte"));
    } catch (e) {
      return const Left(UnknownFailure("Error inesperado al guardar"));
    }
  }
}

