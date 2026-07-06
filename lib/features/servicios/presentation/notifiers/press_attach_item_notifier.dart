import 'package:crv_reprosisa/features/servicios/domain/entities/press_attach_item_entity.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/press/press_attach_item_state.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/service_press_provider.dart'; 
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PressAttachItemNotifier extends Notifier<PressAttachItemState> {
  @override
  PressAttachItemState build() => const PressAttachItemState();

  Future<void> attachItems(String serviceId, List<String> itemIds) async {
    // 1. Cambiamos el estado a cargando
    state = state.copyWith(status: Status.loading);
    
    // 2. Leemos el caso de uso desde los providers definidos
    final useCase = ref.read(attachPressItemUseCaseProvider);
    
    // 3. Ejecutamos la lógica
    final result = await useCase.call(PressAttachItemEntity(
      serviceId: serviceId, 
      itemIds: itemIds
    ));

    // 4. Actualizamos el estado basado en el resultado (éxito o error)
    state = result.fold(
      (failure) => state.copyWith(
        status: Status.error, 
        error: failure.message
      ),
      (_) => state.copyWith(
        status: Status.success
      ),
    );
  }
}