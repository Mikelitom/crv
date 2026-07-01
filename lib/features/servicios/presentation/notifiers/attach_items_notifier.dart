// lib/features/servicios/presentation/notifiers/attach_items_notifier.dart
import 'package:crv_reprosisa/features/servicios/domain/entities/attach_item_entity.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/vehicle/attach_item_state.dart';
import 'package:crv_reprosisa/features/servicios/presentation/providers/vehicle/service_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../features/assets/presentation/states/status.dart';

class AttachItemsNotifier extends Notifier<AttachItemsState> {
  @override
  AttachItemsState build() => const AttachItemsState();

  Future<void> attachItems(String serviceId, List<String> itemIds) async {
    state = state.copyWith(status: Status.loading);
    
    final useCase = ref.read(attachItemsUseCaseProvider);
    final result = await useCase.call(AttachItemsEntity(serviceId: serviceId, itemIds: itemIds));

    state = result.fold(
      (failure) => state.copyWith(status: Status.error, error: failure.message),
      (_) => state.copyWith(status: Status.success),
    );
  }
}