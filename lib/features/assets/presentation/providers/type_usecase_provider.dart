import 'package:crv_reprosisa/features/assets/domain/usecases/get_all_types.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/type_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAllTypesUseCaseProvider = Provider<GetAllTypes>((ref) {
  final repository = ref.read(typeRepositoryProvider);
  return GetAllTypes(repository);
});
