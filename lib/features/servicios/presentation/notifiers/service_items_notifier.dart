// lib/features/servicios/presentation/notifiers/service_items_notifier.dart
import 'package:crv_reprosisa/features/servicios/presentation/providers/vehicle/service_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/vehicle/service_items_state.dart';
import '../../../../features/assets/presentation/states/status.dart';

class ServiceItemsNotifier extends Notifier<ServiceItemsState> {
  @override
  ServiceItemsState build() => const ServiceItemsState();

  // Mantenemos el nombre loadServiceItems
  Future<void> loadServiceItems(String serviceId) async {
    state = state.copyWith(status: Status.loading);
    
    final useCase = ref.read(getServiceItemsUseCaseProvider);
    final result = await useCase.call(serviceId);

    state = result.fold(
      (failure) => state.copyWith(status: Status.error, error: failure.message),
      (data) => state.copyWith(status: Status.success, items: data),
    );
  }
}