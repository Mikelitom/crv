import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failure.dart';
import '../../domain/repositories/inspeccion_repository.dart';
import '../datasource/inspeccion_datasource_remote.dart';
import '../models/component_model.dart';
import '../../domain/entities/entities_press.dart';
import '../../domain/entities/component_item.dart';
import '../../domain/entities/loan_area.dart';

class InspeccionRepositoryImpl implements InspeccionRepository {
  final InspeccionRemoteDataSource dataSource;
  InspeccionRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, String>> getLatestLoanStatus(String pressId) async {
    try {
      final response = await dataSource.getLoansMultiFilter({"press_id": pressId});
      
      if (response.isNotEmpty) {
        return Right(response.first['status'].toString());
      }
      return const Right('AVAILABLE');
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? "Error al verificar estatus"));
    } catch (e) {
      return const Left(UnknownFailure("No se pudo obtener el estado de la prensa"));
    }
  }

  @override
  Future<Either<Failure, List<ComponentItem>>> getInspectionTemplate() async {
    try {
      final data = await dataSource.getInspectionTemplate();
      return Right(data.map((json) => PrensaComponentItem.fromJson(json)).toList());
    } catch (e) { return const Left(ServerFailure("Error template")); }
  }

  @override
  Future<Either<Failure, Press>> getPressBySerie(String serie) async {
    try {
      final press = await dataSource.getPressBySerie(serie);
      if (press != null) return Right(press);
      return const Left(ServerFailure("No se encontró la prensa"));
    } catch (e) { return const Left(UnknownFailure("Error al buscar serie")); }
  }

  @override
  Future<Either<Failure, List<String>>> fetchAllSeries() async {
    try {
      final series = await dataSource.getAllSeries();
      return Right(series);
    } catch (e) { return const Left(ServerFailure("Error al cargar series")); }
  }

  @override
  Future<Either<Failure, String>> createPressReport(Map<String, dynamic> reportData) async {
    try {
      final id = await dataSource.savePressReport(reportData);
      return Right(id);
    } catch (e) { return const Left(ServerFailure("Error al enviar reporte")); }
  }

  @override
  Future<Either<Failure, List<LoanArea>>> getLoanAreas() async {
    try {
      final data = await dataSource.getAllLoanAreas();
      return Right(data.map((json) => LoanArea.fromJson(json)).toList());
    } catch (e) { return const Left(ServerFailure("Error al cargar talleres")); }
  }

  @override
  Future<Either<Failure, LoanArea>> createLoanArea(Map<String, String> data) async {
    try {
      final result = await dataSource.createLoanArea(data);
      return Right(LoanArea.fromJson(result));
    } catch (e) { return const Left(ServerFailure("Error al crear taller")); }
  }

  @override
  Future<Either<Failure, Unit>> createLoan(Map<String, dynamic> data) async {
    try {
      await dataSource.createLoan(data);
      return const Right(unit);
    } catch (e) { return const Left(ServerFailure("Error al registrar préstamo")); }
  }

  @override
  Future<Either<Failure, Uint8List>> getInspectionPdfBinary(String id) async {
    try {
      final data = await dataSource.getInspectionPdfFile(id);
      return Right(data);
    } catch (e) { return const Left(ServerFailure("Error al descargar PDF")); }
  }
}