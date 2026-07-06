// lib/features/servicios/presentation/notifiers/press_service_order_notifier.dart
import 'package:crv_reprosisa/features/servicios/presentation/providers/press/press_service_order_state.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/service_press_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/assets/presentation/states/status.dart';

class PressServiceOrderNotifier extends Notifier<PressServiceOrderState> {
  @override
  PressServiceOrderState build() => const PressServiceOrderState();

  Future<void> loadOrders(String pressId) async {
    state = state.copyWith(status: Status.loading);
    final useCase = ref.read(getPressServiceOrdersUseCaseProvider);
    final result = await useCase.call(pressId);
    
    state = result.fold(
      (l) => state.copyWith(status: Status.error, error: l.message),
      (r) => state.copyWith(status: Status.success, orders: r),
    );
  }
}