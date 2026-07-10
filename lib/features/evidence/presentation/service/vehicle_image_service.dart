import 'dart:io';

import 'package:crv_reprosisa/core/constants/storage_buckets.dart';
import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/evidence/domain/entities/upload_file_entity.dart';
import 'package:crv_reprosisa/features/evidence/domain/usecases/upload_file_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:mime/mime.dart';

class VehicleImageService {
  final UploadFileUseCase uploadFile;

  VehicleImageService(this.uploadFile);

  Future<Either<Failure, String>> uploadVehicleImage({
    required File file,
    required String vehicleId,
  }) async {
    try {
      final mimeType =
          lookupMimeType(file.path) ?? 'application/octet-stream';

      final entity = UploadFileEntity(
        bucket: StorageBuckets.assets,
        path: 'vehicles/$vehicleId',
        fileName: 'main.jpg',
        mimeType: mimeType,
        localPath: file.path,
      );

      final result = await uploadFile(entity);

      return result.fold(
        (failure) => Left(failure),
        (filePath) => Right(filePath),
      );
    } catch (e) {
      return Left(
        UploadFailure('Error procesando imagen del vehículo'),
      );
    }
  }
}