import 'dart:io';

import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/assets/data/datasource/type_remote_datasource.dart';
import 'package:crv_reprosisa/features/assets/domain/entities/vehicle_type.dart';
import 'package:crv_reprosisa/features/assets/domain/repositories/vehicle_type_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class TypeRepositoryImpl implements VehicleTypeRepository {
  final TypeRemoteDatasource remote;

  TypeRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, List<VehicleType>>> getAllTypes() async {
    try {
      final types = await remote.getAllTypes();
      return Right(types);
    } on DioException catch (e) {
      return Left(ServerFailure(e.toString()));
    } on SocketException catch (e) {
      return Left(NetworkFailure(e.toString()));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
