import 'package:crv_reprosisa/features/bandas_transportadoras/data/datasource/client_local_datasource.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failure.dart';
import '../../domain/repositories/banda_repository.dart';
import '../datasource/banda_remote_datasource.dart';
import '../../domain/entities/banda_template.dart';
import '../../domain/entities/client_mine.dart';

class BandaRepositoryImpl implements BandaRepository {
  final BandaRemoteDataSource dataSource;
  final ClientLocalDataSource local;

  BandaRepositoryImpl(this.dataSource, this.local);

  @override
  Future<Either<Failure, List<BandaSection>>> getBandaTemplate() async {
    try {
      final result = await dataSource.getBandaTemplate();

      await local.saveClientTemplate(result);

      return Right(result);
    } on DioException catch (e) {
      try {
        final localData = await local.getClientTemplate();

        if (localData.isNotEmpty) {
          return Right(localData);
        }

        return Left(
          ServerFailure(
            e.message ?? "No hay template disponibñe sin conexion.",
          ),
        );
      } catch (_) {
        return const Left(ServerFailure('Error al cargar template de bandas.'));
      }
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Client>>> getActiveClients() async {
    try {
      final result = await dataSource.getActiveClients();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure("Error al obtener clientes"));
    }
  }

  @override
  Future<Either<Failure, List<Mine>>> getActiveMines() async {
    try {
      final result = await dataSource.getActiveMines();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure("Error al obtener minas"));
    }
  }

  @override
  Future<Either<Failure, String>> createBandaReport(
    Map<String, dynamic> reportData,
  ) async {
    try {
      final id = await dataSource.saveBandaReport(reportData);
      return Right(id);
    } catch (e) {
      return Left(ServerFailure("Error al guardar reporte de banda"));
    }
  }
}
