import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/vehicle_entity.dart';
import '../../domain/repositories/vehicle_inspeccion_repository.dart';
import '../datasource/vehicle_inspection_remote_datasource.dart';
import '../models/inspection_vehicle_model.dart';

class VehicleInspectionRepositoryImpl implements VehicleInspectionRepository {
  final VehicleInspectionRemoteDataSource dataSource;
  VehicleInspectionRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<Vehicle>>> getActiveVehicles() async {
    try {
      final response = await dataSource.getActiveVehicles();
      print("DEBUG: Repo data received: ${response.length} items");

      for (var item in response) {
        print("ITEM TYPE: ${item.runtimeType}");
        print("ITEM VALUE: $item");
      }

      // final vehicles = response
      //     .map((json) => VehicleModel.fromJson(json))
      //     .toList();
      print(
        "DEBUG: Repo mapping success: ${response.first.plate}",
      ); // Verifica si el mapeo funcionó

      return Right(response);
    } catch (e) {
      print(
        "DEBUG: Repo Mapping Error: $e",
      ); // Esto te dirá qué campo del JSON está mal
      return const Left(ServerFailure("Error al mapear vehículos"));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getVehicleTemplate() async {
    try {
      final data = await dataSource.getVehicleTemplate();
      return Right(data);
    } catch (e) {
      return const Left(ServerFailure("Error al cargar template de vehículos"));
    }
  }

  @override
  Future<Either<Failure, String>> saveVehicleReport(
    Map<String, dynamic> reportData,
  ) async {
    try {
      final id = await dataSource.saveVehicleReport(reportData);
      return Right(id);
    } catch (e) {
      return const Left(
        ServerFailure("Error al enviar el reporte de inspección"),
      );
    }
  }
}
