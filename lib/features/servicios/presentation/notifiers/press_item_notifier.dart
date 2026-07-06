import 'package:crv_reprosisa/features/servicios/presentation/providers/service_press_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/press_item_state.dart';
import '../../../../features/assets/presentation/states/status.dart';

class PressItemNotifier extends Notifier<PressItemState> {
  @override
  PressItemState build() => const PressItemState();

  Future<void> loadPendingItems(String pressId) async {
    state = state.copyWith(status: Status.loading);
    
    // Asumiendo que el provider se llama getPendingPressItemsUseCaseProvider
    final result = await ref.read(getPendingPressItemsUseCaseProvider).call(pressId);
    
    state = result.fold(
      (l) => state.copyWith(status: Status.error, error: l.message),
      (r) => state.copyWith(status: Status.success, data: r),
    );
  }
}