import 'dart:typed_data';
import 'package:crv_reprosisa/features/prensas_industriales/data/datasource/press_inspection_local_datasource.dart';
import 'package:crv_reprosisa/features/prensas_industriales/data/models/loan_area_model.dart';
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
  final PressInspectionLocalDataSource local;

  InspeccionRepositoryImpl(this.dataSource, this.local);

  @override
  Future<Either<Failure, Map<String, dynamic>>> getLatestLoanStatus(
    String pressId,
  ) async {
    try {
      final response = await dataSource.getLoansMultiFilter({
        "press_id": pressId,
      });

      if (response.isNotEmpty) {
        return Right(Map<String, dynamic>.from(response.first));
      }

      return const Right({'status': 'AVAILABLE'});
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? "Error al verificar estatus"));
    } catch (e) {
      return const Left(
        UnknownFailure("No se pudo obtener el estado de la prensa"),
      );
    }
  }

  @override
  Future<Either<Failure, List<ComponentItem>>> getInspectionTemplate() async {
    try {
      final data = await dataSource.getInspectionTemplate();

      await local.savePressTemplate({'components': data});

      return Right(
        data.map((json) => PrensaComponentItem.fromJson(json)).toList(),
      );
    } on DioException {
      try {
        final cached = await local.getPressTemplate();

        final components = cached['components'] as List<dynamic>? ?? [];

        return Right(
          components
              .map(
                (json) => PrensaComponentItem.fromJson(
                  Map<String, dynamic>.from(json),
                ),
              )
              .toList(),
        );
      } catch (_) {
        return const Left(ServerFailure("No existe template local"));
      }
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Press>> getPressBySerie(String serie) async {
    try {
      final localPress = await local.getPressBySerie(serie);

      if (localPress != null) {
        return Right(
          Press(
            id: localPress.id,
            serie: localPress.serie,
            model: localPress.model,
            type: localPress.type,
            voltz: localPress.volts,
          ),
        );
      }

      final remotePress = await dataSource.getPressBySerie(serie);

      if (remotePress != null) {
        return Right(remotePress);
      }

      return const Left(ServerFailure("No se encontró la prensa"));
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? "Error al buscar prensa"));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> fetchAllSeries() async {
    try {
      final series = await local.getAllSeries();

      return Right(series);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> createPressReport(
    Map<String, dynamic> reportData,
  ) async {
    try {
      final id = await dataSource.savePressReport(reportData);
      return Right(id);
    } catch (e) {
      try {
        await local.saveOfflineReport(reportData);

        return const Right(
          'Reporte guardado localmente. Pendiente de sincronizacion.'
        );
      } catch (localError) {
        return const Left(ServerFailure("No fue posible guardar el reporte localmente"));
      }
    }
  }

  @override
  Future<Either<Failure, List<LoanArea>>> getLoanAreas() async {
    try {
      final data = await dataSource.getAllLoanAreas();

      final areas = data
          .map(
            (json) => LoanAreaModel.fromJson(Map<String, dynamic>.from(json)),
          )
          .toList();

      await local.clearLoanAreas();
      await local.saveLoanAreas(areas);

      return Right(areas);
    } on DioException {
      try {
        final cached = await local.getLoanAreas();

        return Right(cached);
      } catch (_) {
        return const Left(ServerFailure("No se pudieron cargar las áreas"));
      }
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LoanArea>> createLoanArea(
    Map<String, String> data,
  ) async {
    try {
      final result = await dataSource.createLoanArea(data);
      return Right(LoanArea.fromJson(result));
    } catch (e) {
      return const Left(ServerFailure("Error al crear taller"));
    }
  }

  @override
  Future<Either<Failure, Unit>> createLoan(Map<String, dynamic> data) async {
    try {
      await dataSource.createLoan(data);
      return const Right(unit);
    } catch (e) {
      return const Left(ServerFailure("Error al registrar préstamo"));
    }
  }

  @override
  Future<Either<Failure, Uint8List>> getInspectionPdfBinary(String id) async {
    try {
      final data = await dataSource.getInspectionPdfFile(id);
      return Right(data);
    } catch (e) {
      return const Left(ServerFailure("Error al descargar PDF"));
    }
  }
}
