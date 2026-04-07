import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/evidence/domain/entities/upload_file_entity.dart';
import 'package:dartz/dartz.dart';

abstract class StorageRepository {
  Future<Either<Failure, String>> uploadFile(UploadFileEntity file);
}
