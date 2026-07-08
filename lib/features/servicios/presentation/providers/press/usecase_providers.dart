// lib/features/assets/presentation/providers/usecase_providers.dart
import 'package:crv_reprosisa/features/assets/domain/repositories/press_repository.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/press_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAllPressUseCaseProvider = Provider<GetAllPressUseCase>((ref) {
  final repository = ref.read(pressRepositoryProvider); // Tu repo implementado
  return GetAllPressUseCase(repository);
});

class GetAllPressUseCase {
  GetAllPressUseCase(PressRepository repository);
}