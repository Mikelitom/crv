// 1. DataSource
import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/features/servicios/data/datasource/v_service_datasource.dart';
import 'package:crv_reprosisa/features/servicios/data/repository/attach_items_repository_impl.dart';
import 'package:crv_reprosisa/features/servicios/data/repository/create_service_repository_impl.dart';
import 'package:crv_reprosisa/features/servicios/data/repository/service_items_repository_impl.dart';
import 'package:crv_reprosisa/features/servicios/data/repository/service_items_repository_impl_g.dart';
import 'package:crv_reprosisa/features/servicios/data/repository/v_service_repository_impl.dart';
import 'package:crv_reprosisa/features/servicios/domain/repositories/attach_item_repository.dart';
import 'package:crv_reprosisa/features/servicios/domain/repositories/create_service_repository.dart';
import 'package:crv_reprosisa/features/servicios/domain/repositories/incidence_repository_g.dart';
import 'package:crv_reprosisa/features/servicios/domain/repositories/service_item_repository.dart';
import 'package:crv_reprosisa/features/servicios/domain/repositories/v_service_repository.dart';
import 'package:crv_reprosisa/features/servicios/domain/usecases/attach_item_usecase.dart';
import 'package:crv_reprosisa/features/servicios/domain/usecases/create_service_usecase.dart';
import 'package:crv_reprosisa/features/servicios/domain/usecases/get_service_items_usecase.dart';
import 'package:crv_reprosisa/features/servicios/domain/usecases/get_service_items_usecase_g.dart';
import 'package:crv_reprosisa/features/servicios/domain/usecases/get_services_by_vehicle.dart';
import 'package:crv_reprosisa/features/servicios/presentation/notifiers/attach_items_notifier.dart';
import 'package:crv_reprosisa/features/servicios/presentation/notifiers/incidence_notifier_g.dart';
import 'package:crv_reprosisa/features/servicios/presentation/notifiers/service_items_notifier.dart' show ServiceItemsNotifier;
import 'package:crv_reprosisa/features/servicios/presentation/notifiers/v_service_notifier.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/vehicle/attach_item_state.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/vehicle/incidence_state_g.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/vehicle/service_items_state.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/vehicle/v_service_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final serviceRemoteDataSourceProvider = Provider<ServiceDataSource>((ref) {
  return ServiceDataSourceImpl(ref.watch(dioProvider));
});

// 2. Repositorio
final serviceRepositoryProvider = Provider<ServiceRepository>((ref) {
  return ServiceRepositoryImpl(ref.watch(serviceRemoteDataSourceProvider));
});

// 3. Caso de Uso
final getServicesUseCaseProvider = Provider<GetServicesByVehicle>((ref) {
  return GetServicesByVehicle(ref.watch(serviceRepositoryProvider));
});

// 4. Notifier (UI)
final serviceListNotifierProvider =
    NotifierProvider<ServiceListNotifier, ServiceListState>(() {
      return ServiceListNotifier(); // Este llamará al caso de uso dentro
    });

final createServiceRepositoryProvider = Provider<CreateServiceRepository>((
  ref,
) {
  return CreateServiceRepositoryImpl(ref.watch(dioProvider));
});

final createServiceUseCaseProvider = Provider<CreateServiceUseCase>((ref) {
  return CreateServiceUseCase(ref.watch(createServiceRepositoryProvider));
});
// --- NUEVOS PROVIDERS PARA ATTACH ITEMS ---

// 1. Repositorio (Inyectando el DataSource que ya tienes)
final attachItemsRepositoryProvider = Provider<AttachItemsRepository>((ref) {
  return AttachItemsRepositoryImpl(ref.watch(serviceRemoteDataSourceProvider));
});

// 2. Caso de Uso
final attachItemsUseCaseProvider = Provider<AttachItemsUseCase>((ref) {
  return AttachItemsUseCase(ref.watch(attachItemsRepositoryProvider));
});

// 3. Notifier (UI)
final attachItemsNotifierProvider = NotifierProvider<AttachItemsNotifier, AttachItemsState>(() {
  return AttachItemsNotifier();

});
// --- PROVIDERS PARA SERVICE ITEMS ---

// 1. Repositorio
final serviceItemsRepositoryProvider = Provider<ServiceItemsRepository>((ref) {
  return ServiceItemsRepositoryImpl(ref.watch(serviceRemoteDataSourceProvider));
});

// 2. Caso de Uso
final getServiceItemsUseCaseProvider = Provider<GetServiceItemsUseCase>((ref) {
  return GetServiceItemsUseCase(ref.watch(serviceItemsRepositoryProvider));
});

// 3. Notifier
final serviceItemsNotifierProvider = NotifierProvider<ServiceItemsNotifier, ServiceItemsState>(() {
  return ServiceItemsNotifier();
});// --- PROVIDERS PARA INCIDENCIAS (_G) ---

// 1. Repositorio
final incidenceRepositoryProvider = Provider<IncidenceRepository>((ref) {
  return IncidenceRepositoryImplG(ref.watch(serviceRemoteDataSourceProvider));
});

// 2. Caso de Uso
final getIncidenceSummaryUseCaseProvider = Provider<GetIncidenceSummaryUseCaseG>((ref) {
  return GetIncidenceSummaryUseCaseG(ref.watch(incidenceRepositoryProvider));
});

// 3. Notifier
final incidenceNotifierProvider = NotifierProvider<IncidenceNotifierG, IncidenceStateG>(() {
  return IncidenceNotifierG();
});