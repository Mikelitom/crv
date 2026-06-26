// lib/features/servicios/presentation/providers/service_list_notifier.dart
import 'package:crv_reprosisa/features/servicios/presentation/providers/service_providers.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/v_service_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';

class ServiceListNotifier extends Notifier<ServiceListState> {
  @override
  ServiceListState build() {
    return const ServiceListState();
  }

  Future<void> loadServices(String vehicleId) async {
    state = state.copyWith(status: Status.loading);

    // Accedemos al caso de uso mediante el ref
    final useCase = ref.read(getServicesUseCaseProvider);
    final result = await useCase.call(vehicleId);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: Status.error, 
          error: failure.message
        );
      },
      (services) {
        state = state.copyWith(
          status: Status.success, 
          services: services
        );
      },
    );
  }
}