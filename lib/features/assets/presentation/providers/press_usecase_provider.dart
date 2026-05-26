import 'package:crv_reprosisa/features/assets/domain/usecases/update_press.dart';
import 'package:crv_reprosisa/features/assets/presentation/providers/press_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/create_press.dart';
import '../../domain/usecases/get_all_press.dart';
import '../../domain/usecases/activate_press.dart';
import '../../domain/usecases/deactivate_press.dart';

final createPressUseCaseProvider = Provider<CreatePress>((ref) {
  final repository = ref.read(pressRepositoryProvider);
  return CreatePress(repository);
});

final getAllPressUseCaseProvider = Provider<GetAllPress>((ref) {
  final repository = ref.read(pressRepositoryProvider);
  return GetAllPress(repository);
});

final updatePressUseCaseProvider = Provider<UpdatePress>((ref) {
  final repository = ref.read(pressRepositoryProvider);
  return UpdatePress(repository);
});
final activatePressUseCaseProvider = Provider<ActivatePress>((ref) {
  final repository = ref.read(pressRepositoryProvider);
  return ActivatePress(repository);
});

final deactivatePressUseCaseProvider = Provider<DeactivatePress>((ref) {
  final repository = ref.read(pressRepositoryProvider);
  return DeactivatePress(repository);
});
