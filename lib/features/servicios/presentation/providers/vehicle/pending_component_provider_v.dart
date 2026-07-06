// lib/features/assets/presentation/providers/pending_component_provider.dart
import 'package:crv_reprosisa/features/servicios/data/repository/pending_componenet_repository_impl.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/vehicle/pending_componenet_state_v.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/config/dio_client.dart';
import '../../../domain/usecases/get_pending_components_usecase.dart';
import '../../notifiers/pending_component_notifier_v.dart'; // Importa el notifier que hicimos

// 1. Repositorio (Inyecta el Dio)
final pendingRepoProvider = Provider((ref) => PendingComponentRepositoryImpl(ref.read(dioProvider)));

// 2. Usecase (Usa el repositorio)
final getPendingComponentsUseCaseProvider = Provider((ref) => GetPendingComponentsUseCase(ref.read(pendingRepoProvider)));

// 3. Notifier Provider (Este reemplaza al FutureProvider)
// Ahora usas este provider para escuchar el estado en tu UI
final pendingComponentNotifierProvider = NotifierProvider<PendingComponentNotifier, PendingComponentState>(() {
  return PendingComponentNotifier();
});