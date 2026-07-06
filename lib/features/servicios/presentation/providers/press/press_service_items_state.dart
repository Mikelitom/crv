// lib/features/servicios/presentation/providers/press/press_service_items_state.dart
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
import 'package:crv_reprosisa/features/servicios/domain/entities/press_service_item_entity.dart';

class PressServiceItemsState {
  final Status status;
  final List<PressServiceItemEntity> items;
  final String? error;

  const PressServiceItemsState({
    this.status = Status.initial,
    this.items = const [],
    this.error,
  });

  PressServiceItemsState copyWith({
    Status? status,
    List<PressServiceItemEntity>? items,
    String? error,
  }) {
    return PressServiceItemsState(
      status: status ?? this.status,
      items: items ?? this.items,
      error: error ?? this.error,
    );
  }
}