import 'package:crv_reprosisa/features/evidence/domain/usecases/upload_file_use_case.dart';
import 'package:crv_reprosisa/features/evidence/presentation/providers/storage_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final uploadFileUseCaseProvider = Provider<UploadFileUseCase>((ref) {
  return UploadFileUseCase(ref.read(storageRepositoryProvider));
});
