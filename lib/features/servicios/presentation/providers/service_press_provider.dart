import 'package:crv_reprosisa/features/servicios/domain/usecases/get_pending_press_item_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/core/config/dio_client.dart';

// Imports de Data
import 'package:crv_reprosisa/features/servicios/data/datasource/press_service_datasource.dart';
import 'package:crv_reprosisa/features/servicios/data/repository/press_item_repository_impl.dart';

// Imports de Domain
import 'package:crv_reprosisa/features/servicios/domain/repositories/press_item_repository.dart';

// Imports de Presentation (Notifier y State)
import 'package:crv_reprosisa/features/servicios/presentation/notifiers/press_item_notifier.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/press_item_state.dart';

// --- PROVIDERS PARA PRESS (PRENSA) ---

// 1. DataSource
final pressDataSourceProvider = Provider<PressServiceDataSource>((ref) {
  return PressServiceDataSourceImpl(ref.watch(dioProvider));
});

// 2. Repositorio
final pressItemRepositoryProvider = Provider<PressItemRepository>((ref) {
  return PressItemRepositoryImpl(ref.watch(pressDataSourceProvider));
});

// 3. Caso de Uso
final getPendingPressItemsUseCaseProvider = Provider<GetPendingPressItemsUseCase>((ref) {
  return GetPendingPressItemsUseCase(ref.watch(pressItemRepositoryProvider));
});

// 4. Notifier
final pressItemNotifierProvider = NotifierProvider<PressItemNotifier, PressItemState>(() {
  return PressItemNotifier();
});