// 1. DataSource
import 'package:crv_reprosisa/core/config/dio_client.dart';
import 'package:crv_reprosisa/features/servicios/data/datasource/v_service_datasource.dart';
import 'package:crv_reprosisa/features/servicios/data/repository/v_service_repository_impl.dart';
import 'package:crv_reprosisa/features/servicios/domain/repositories/v_service_repository.dart';
import 'package:crv_reprosisa/features/servicios/domain/usecases/get_services_by_vehicle.dart';
import 'package:crv_reprosisa/features/servicios/presentation/notifiers/v_service_notifier.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/v_service_state.dart';
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
final serviceListNotifierProvider = NotifierProvider<ServiceListNotifier, ServiceListState>(() {
  return ServiceListNotifier(); // Este llamará al caso de uso dentro
});