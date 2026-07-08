import 'package:crv_reprosisa/features/servicios/data/repository/create_press_service_repository_impl.dart';
import 'package:crv_reprosisa/features/servicios/data/repository/press_attach_ittem_repository_impl.dart';
import 'package:crv_reprosisa/features/servicios/data/repository/press_incidence_repository_impl.dart';
import 'package:crv_reprosisa/features/servicios/data/repository/press_service_order_repository_impl.dart';
import 'package:crv_reprosisa/features/servicios/data/repository/press_service_repository_impl.dart';
import 'package:crv_reprosisa/features/servicios/domain/repositories/create_press_service_repository.dart';
import 'package:crv_reprosisa/features/servicios/domain/repositories/press_attach_item_repository.dart';
import 'package:crv_reprosisa/features/servicios/domain/repositories/press_service_order_repository.dart';
import 'package:crv_reprosisa/features/servicios/domain/repositories/press_incidence_repoitory.dart';
import 'package:crv_reprosisa/features/servicios/domain/repositories/press_service_repository.dart';
import 'package:crv_reprosisa/features/servicios/domain/usecases/attach_press_item_usecase.dart';
import 'package:crv_reprosisa/features/servicios/domain/usecases/create_press_service_use_case.dart';
import 'package:crv_reprosisa/features/servicios/domain/usecases/get_pending_press_item_usecase.dart';
import 'package:crv_reprosisa/features/servicios/domain/usecases/get_press_incidence_sumary_usecase.dart';
import 'package:crv_reprosisa/features/servicios/domain/usecases/get_press_service_items_usecase.dart';
import 'package:crv_reprosisa/features/servicios/domain/usecases/get_press_service_orders.dart';
import 'package:crv_reprosisa/features/servicios/presentation/notifiers/press_attach_item_notifier.dart';
import 'package:crv_reprosisa/features/servicios/presentation/notifiers/press_create_order_notifier.dart';
import 'package:crv_reprosisa/features/servicios/presentation/notifiers/press_incidence_notifier.dart';
import 'package:crv_reprosisa/features/servicios/presentation/notifiers/press_service_items_notifier.dart';
import 'package:crv_reprosisa/features/servicios/presentation/notifiers/press_service_order_notifier.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/press/press_attach_item_state.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/press/press_create_order_state.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/press/press_service_items_state.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/press/press_service_order_state.dart';
import 'package:crv_reprosisa/features/servicios/presentation/widgets/press/press_incidence_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/features/servicios/data/datasource/press_service_datasource.dart';
import 'package:crv_reprosisa/features/servicios/data/repository/press_item_repository_impl.dart';
import 'package:crv_reprosisa/features/servicios/domain/repositories/press_item_repository.dart';

import 'package:crv_reprosisa/features/servicios/presentation/notifiers/press_item_notifier.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/press_item_state.dart';
import 'package:flutter_riverpod/legacy.dart';

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
final getPendingPressItemsUseCaseProvider =
    Provider<GetPendingPressItemsUseCase>((ref) {
      return GetPendingPressItemsUseCase(
        ref.watch(pressItemRepositoryProvider),
      );
    });

// 4. Notifier
final pressItemNotifierProvider =
    NotifierProvider<PressItemNotifier, PressItemState>(() {
      return PressItemNotifier();
    }); // --- NUEVOS PROVIDERS PARA INCIDENCIAS DE PRENSA ---

// Repositorio
final pressIncidenceRepositoryProvider = Provider<PressIncidenceRepository>((
  ref,
) {
  return PressIncidenceRepositoryImpl(ref.watch(pressDataSourceProvider));
});

// Caso de Uso
final getPressIncidenceSummaryUseCaseProvider =
    Provider<GetPressIncidenceSummaryUseCase>((ref) {
      return GetPressIncidenceSummaryUseCase(
        ref.watch(pressIncidenceRepositoryProvider),
      );
    });

// Notifier
final pressIncidenceNotifierProvider =
    NotifierProvider<PressIncidenceNotifier, PressIncidenceState>(() {
      return PressIncidenceNotifier();
    }); // --- PROVIDERS PARA ÓRDENES DE SERVICIO (PRESS) ---

// Repositorio
final pressServiceOrderRepositoryProvider =
    Provider<PressServiceOrderRepository>((ref) {
      return PressServiceOrderRepositoryImpl(
        ref.watch(pressDataSourceProvider),
      );
    });

// Caso de Uso
final getPressServiceOrdersUseCaseProvider =
    Provider<GetPressServiceOrdersUseCase>((ref) {
      return GetPressServiceOrdersUseCase(
        ref.watch(pressServiceOrderRepositoryProvider),
      );
    });

// Notifier
final pressServiceOrderNotifierProvider =
    NotifierProvider<PressServiceOrderNotifier, PressServiceOrderState>(() {
      return PressServiceOrderNotifier();
    }); // --- PROVIDERS PARA CREAR ORDEN (PRESS) ---

// Repositorio
final createPressServiceRepositoryProvider =
    Provider<CreatePressServiceRepository>((ref) {
      return CreatePressServiceRepositoryImpl(
        ref.watch(pressDataSourceProvider),
      );
    });

// Caso de Uso
final createPressServiceUseCaseProvider = Provider<CreatePressServiceUseCase>((
  ref,
) {
  return CreatePressServiceUseCase(
    ref.watch(createPressServiceRepositoryProvider),
  );
});

// Notifier
final pressCreateOrderNotifierProvider =
    NotifierProvider<PressCreateOrderNotifier, PressCreateOrderState>(() {
      return PressCreateOrderNotifier();
    });
final pressAttachRepositoryProvider = Provider<PressAttachItemRepository>((
  ref,
) {
  return PressAttachItemRepositoryImpl(ref.watch(pressDataSourceProvider));
});

final attachPressItemUseCaseProvider = Provider<AttachPressItemUseCase>((ref) {
  return AttachPressItemUseCase(ref.watch(pressAttachRepositoryProvider));
});

final pressAttachItemsNotifierProvider =
    NotifierProvider<PressAttachItemNotifier, PressAttachItemState>(
      () {
        return PressAttachItemNotifier();
      },
    ); // lib/features/servicios/presentation/providers/service_press_provider.dart

// 1. Provider del DataSource
final pressServiceDataSourceProvider = Provider<PressServiceDataSource>((ref) {
  return PressServiceDataSourceImpl(ref.read(dioProvider));
});

// 2. Provider del Repository (AQUÍ ESTÁ EL QUE TE FALTA)
final pressServiceRepositoryProvider = Provider<PressServiceRepository>((ref) {
  return PressServiceRepositoryImpl(ref.read(pressServiceDataSourceProvider));
});

// 3. Provider del Caso de Uso (que consume al repository)
final getPressServiceItemsUseCaseProvider = Provider((ref) {
  return GetPressServiceItemsUseCase(ref.read(pressServiceRepositoryProvider));
});

final pressServiceItemsNotifierProvider =
    NotifierProvider<PressServiceItemsNotifier, PressServiceItemsState>(() {
      return PressServiceItemsNotifier();
    });
