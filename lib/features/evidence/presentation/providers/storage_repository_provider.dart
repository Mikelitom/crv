import 'package:crv_reprosisa/features/evidence/data/storage_repository_impl.dart';
import 'package:crv_reprosisa/features/evidence/domain/repositories/storage_repository.dart';
import 'package:crv_reprosisa/features/evidence/presentation/providers/storage_datasource_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final storageRepositoryProvider = Provider<StorageRepository>((ref) {
  return StorageRepositoryImpl(ref.read(storageDatasourceProvider));
});
