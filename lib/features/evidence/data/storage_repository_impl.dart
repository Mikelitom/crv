import 'dart:io';

import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/evidence/data/datasources/supabase_storage_datasource.dart';
import 'package:crv_reprosisa/features/evidence/domain/entities/upload_file_entity.dart';
import 'package:crv_reprosisa/features/evidence/domain/repositories/storage_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageRepositoryImpl extends StorageRepository {
  final SupabaseStorageDatasource remote;

  StorageRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, String>> uploadFile(UploadFileEntity file) async {
    try {
      final result = await remote.uploadFile(
        UploadFileEntity(
          path: file.path,
          fileName: file.fileName,
          mimeType: file.mimeType,
          localPath: file.localPath,
        ),
      );

      return Right(result);
    } on StorageException catch (e) {
      return Left(UploadFailure('Upload failure: ${e.message}'));
    } on SocketException catch (e) {
      return Left(NetworkFailure('Connection failure: ${e.message}'));
    } catch (e) {
      return Left(UnknownFailure('Unexpected failure'));
    }
  }
}
