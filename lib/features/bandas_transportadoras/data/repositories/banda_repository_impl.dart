import 'package:crv_reprosisa/features/bandas_transportadoras/data/datasource/client_local_datasource.dart';
import 'package:dartz/dartz.dart';
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
      final remoteData = await dataSource.getBandaTemplate();

      await local.saveClientTemplate(remoteData);

      return Right(remoteData);
    } catch (e) {
      try {
        final localData = await local.getClientTemplate();

        print("REMOTE FALLÓ → USANDO CACHE");
        print(localData);
        print(localData.runtimeType);

        if (localData.isNotEmpty) {
          return Right(localData);
        }

        return const Left(ServerFailure('Sin datos en cache'));
      } catch (_) {
        return const Left(ServerFailure('Error leyendo cache'));
      }
    }
  }

  @override
  Future<Either<Failure, List<Client>>> getActiveClients() async {
    try {
      final result = await dataSource.getActiveClients();
      return Right(result);
    } catch (_) {
      try {
        final localClients = await local.getActiveClients();

        return Right(
          localClients
              .map((c) => Client(id: c.id, name: c.name, company: c.company))
              .toList(),
        );
      } catch (_) {
        return const Left(ServerFailure('Error leyendo clientes locales'));
      }
    }
  }

  @override
  Future<Either<Failure, List<Mine>>> getActiveMines() async {
    try {
      final result = await dataSource.getActiveMines();
      return Right(result);
    } catch (_) {
      try {
        final localMines = await local.getActiveMines();

        return Right(
          localMines
              .map(
                (m) => Mine(
                  id: m.id,
                  clientId: m.clientId,
                  name: m.name,
                  address: m.address ?? '',
                ),
              )
              .toList(),
        );
      } catch (_) {
        return const Left(ServerFailure('Error leyendo minas locales'));
      }
    }
  }

  @override
  Future<Either<Failure, String>> createBandaReport(
    Map<String, dynamic> reportData,
  ) async {
    try {
      final id = await dataSource.saveBandaReport(reportData);
      return Right(id);
    } catch (e, s) {
      print("REPORT DATA COMPLETO:");
      print(reportData);
      print("ERROR EN CREATE REPORT: $e");
      print(s);
      try {
        await local.saveOfflineReport(reportData);

        return const Right(
          'Reporte guardado localmente. Pendiente de sincronizacion.'
        );
      } catch (e) {
        return Left(ServerFailure("Error al guardar reporte de banda"));
      }
    }
  }
}
