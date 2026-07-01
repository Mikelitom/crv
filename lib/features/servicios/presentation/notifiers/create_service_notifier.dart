// lib/features/servicios/presentation/notifiers/create_service_notifier.dart
import 'package:crv_reprosisa/features/servicios/domain/entities/create_service_order_entity.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/vehicle/create_service_state.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// IMPORTA ESTE: Aquí es donde definiste 'createServiceUseCaseProvider'
import 'package:crv_reprosisa/features/servicios/presentation/providers/vehicle/service_providers.dart';

class CreateServiceNotifier extends Notifier<CreateServiceState> {
  @override
  CreateServiceState build() => const CreateServiceState();
Future<void> createOrder(CreateServiceOrderEntity entity) async {
  state = state.copyWith(status: Status.loading);
  
  final useCase = ref.read(createServiceUseCaseProvider);
  final result = await useCase.call(entity);

  state = result.fold(
    (failure) => state.copyWith(status: Status.error, error: failure.message),
    // Recibes el ID del servidor y lo guardas en el estado
    (orderId) => state.copyWith(status: Status.success, orderNumber: orderId),
  );
}
}