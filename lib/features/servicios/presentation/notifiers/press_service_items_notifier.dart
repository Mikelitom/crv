// lib/features/servicios/presentation/providers/press/press_service_items_notifier.dart
import 'package:crv_reprosisa/features/servicios/presentation/providers/press/press_service_items_state.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/service_press_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';


class PressServiceItemsNotifier extends Notifier<PressServiceItemsState> {
  @override
  PressServiceItemsState build() => const PressServiceItemsState();

  Future<void> loadServiceItems(String serviceId) async {
    state = state.copyWith(status: Status.loading);
    try {
      final useCase = ref.read(getPressServiceItemsUseCaseProvider);
      final items = await useCase.call(serviceId);
      state = state.copyWith(status: Status.success, items: items);
    } catch (e) {
      state = state.copyWith(status: Status.error, error: e.toString());
    }
  }
}