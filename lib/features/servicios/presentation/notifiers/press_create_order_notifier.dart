// lib/features/servicios/presentation/notifiers/press_create_order_notifier.dart
import 'package:crv_reprosisa/features/servicios/presentation/providers/service_press_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
import 'package:crv_reprosisa/features/servicios/domain/entities/press_create_order_entity.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/press/press_create_order_state.dart';

class PressCreateOrderNotifier extends Notifier<PressCreateOrderState> {
  @override
  PressCreateOrderState build() => const PressCreateOrderState();

  Future<void> createOrder(PressCreateOrderEntity entity) async {
    state = state.copyWith(status: Status.loading);
    
    final useCase = ref.read(createPressServiceUseCaseProvider);
    final result = await useCase.call(entity);

    state = result.fold(
      (failure) => state.copyWith(status: Status.error, error: failure.message),
      (orderId) => state.copyWith(status: Status.success, orderNumber: orderId),
    );
  }
}