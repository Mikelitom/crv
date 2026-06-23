import 'package:crv_reprosisa/features/vehiculos/data/datasource/vehicle_inspection_local_datasource.dart';
import 'package:crv_reprosisa/features/vehiculos/domain/entities/vehicle_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failure.dart';
import '../../domain/repositories/vehicle_inspeccion_repository.dart';
import '../datasource/vehicle_inspection_remote_datasource.dart';

class VehicleInspectionRepositoryImpl implements VehicleInspectionRepository {
  final VehicleInspectionRemoteDataSource remoteDataSource;
  final VehicleInspectionLocalDatasource localDataSource;

  VehicleInspectionRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Vehicle>>> getActiveVehicles() async {
    try {
      final response = await remoteDataSource.getActiveVehicles();

      return Right(response);
    } catch (e) {
      try {
        final localVehicles = await localDataSource.getActiveVehicles();

        List<Vehicle> vehicles = [];

        for (final local in localVehicles) {
          vehicles.add(
            Vehicle(
              id: local.vehicleId,
              typeId: local.typeId,
              brand: local.brand,
              model: local.model,
              unit: local.unit,
              year: local.year,
              plate: local.plate,
            ),
          );
        }

        return Right(vehicles);
      } catch (localError) {
        return const Left(ServerFailure("Error al obtener vehículos locales"));
      }
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getVehicleTemplate() async {
    try {
      final data = await remoteDataSource.getVehicleTemplate();

      await localDataSource.saveVehicleTemplate(data);

      return Right(data);
    } catch (e) {
      try {
        final localData = await localDataSource.getVehicleTemplate();

        if (localData.isNotEmpty) {
          return Right(localData);
        }

        return const Left(
          ServerFailure("No hay template disponible sin conexión"),
        );
      } catch (_) {
        return const Left(
          ServerFailure("Error al cargar template de vehículos"),
        );
      }
    }
  }

  @override
  Future<Either<Failure, String>> saveVehicleReport(
    Map<String, dynamic> reportData,
  ) async {
    try {
      final id = await remoteDataSource.saveVehicleReport(reportData);
      return Right(id);
    } catch (e) {
      if (e is DioException) {
        final isOffline =
            e.type == DioExceptionType.connectionError ||
            e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout;

        // 🟡 SOLO offline real
        if (isOffline) {
          await localDataSource.saveOfflineReport(reportData);

          return const Left(
            ServerFailure("Sin conexión. Reporte guardado localmente."),
          );
        }

        // 🔴 Error del servidor (NO guardar offline)
        if (e.response != null) {
          return Left(
            ServerFailure(
              e.response?.data['detail']?.toString() ??
                  'Error de validación del servidor',
            ),
          );
        }
      }

      return Left(ServerFailure(e.toString()));
    }
  }
}
