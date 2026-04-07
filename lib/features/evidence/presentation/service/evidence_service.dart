import 'dart:io';

import 'package:crv_reprosisa/core/error/failure.dart';
import 'package:crv_reprosisa/features/evidence/domain/entities/upload_file_entity.dart';
import 'package:crv_reprosisa/features/evidence/domain/usecases/upload_file_use_case.dart';
import 'package:crv_reprosisa/features/evidence/presentation/dto/evidence_dto.dart';
import 'package:dartz/dartz.dart';
import 'package:mime/mime.dart';
import 'package:uuid/uuid.dart';

class EvidenceService {
  final UploadFileUseCase uploadFile;

  EvidenceService(this.uploadFile);

  Future<Either<Failure, EvidenceDto>> uploadEvidence({
    required File file,
    required String basePath,
  }) async {
    try {
      final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';

      final size = await file.length();

      final entity = UploadFileEntity(
        path: basePath,
        fileName: const Uuid().v4(),
        mimeType: mimeType,
        localPath: file.path,
      );

      final result = await uploadFile(entity);

      return result.fold(
        (failure) => Left(failure),
        (filePath) => Right(
          EvidenceDto(
            filePath: filePath,
            fileType: _getFileType(mimeType),
            mimeType: mimeType,
            fileSize: size.toString(),
          ),
        ),
      );
    } catch (e) {
      return Left(UploadFailure('Error procesando archivo'));
    }
  }
}

extension EvidenceServiceMultiple on EvidenceService {
  Future<Either<Failure, List<EvidenceDto>>> uploadMultiple({
    required List<File> files,
    required String basePath,
  }) async {
    final evidences = <EvidenceDto>[];

    for (final file in files) {
      final result = await uploadEvidence(file: file, basePath: basePath);

      if (result.isLeft()) {
        return Left(result.swap().getOrElse(() => UploadFailure('Error')));
      }

      evidences.add(result.getOrElse(() => throw Exception()));
    }

    return Right(evidences);
  }
}
