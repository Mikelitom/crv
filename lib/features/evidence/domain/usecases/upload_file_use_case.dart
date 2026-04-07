import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/evidence/domain/entities/upload_file_entity.dart';
import 'package:crv_reprosisa/features/evidence/domain/repositories/storage_repository.dart';
import 'package:dartz/dartz.dart';

class UploadFileUseCase {
  final StorageRepository repository;

  UploadFileUseCase(this.repository);

  Future<Either<Failure, String>> call(UploadFileEntity file) async {
    if (file.localPath.isEmpty) {
      return Left(FileFailure('Archivo invalido'));
    }

    return await repository.uploadFile(file);
  }
}
