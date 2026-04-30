import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/entities_press.dart';
import '../../domain/entities/component_item.dart';
import '../../domain/entities/loan_area.dart'; // Importa la entidad
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
      return Left(ServerFailure(e.message ?? "Error al conectar con el servidor"));
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
  Future<Either<Failure, String>> createPressReport(Map<String, dynamic> reportData) async {
    try {
      final id = await dataSource.savePressReport(reportData);
      return Right(id);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? "Error al enviar el reporte"));
    } catch (e) {
      return const Left(UnknownFailure("Error inesperado al guardar el reporte"));
    }
  }

  @override
  Future<Either<Failure, List<dynamic>>> getLoanAreas() async {
    try {
      final areas = await dataSource.getAllLoanAreas();
      return Right(areas);
    } catch (e) {
      return const Left(ServerFailure("Error al cargar las áreas"));
    }
  }

  @override
  Future<Either<Failure, LoanArea>> createLoanArea(Map<String, String> data) async {
    try {
      // 1. Obtenemos el Map del DataSource
      final result = await dataSource.createLoanArea(data);
      
      // 2. CONVERSIÓN: Transformamos el Map a la Entidad LoanArea
      // Esto soluciona el error 'invalid_override'
      final area = LoanArea.fromJson(result);
      
      return Right(area);
    } catch (e) {
      return const Left(ServerFailure("Error al crear área nueva"));
    }
  }

  @override
  Future<Either<Failure, Unit>> createLoan(Map<String, dynamic> data) async {
    try {
      await dataSource.createLoan(data);
      return const Right(unit);
    } catch (e) {
      return const Left(ServerFailure("Error al registrar el préstamo"));
    }
  }
}