// lib/features/servicios/presentation/providers/service_items_state.dart
import '../../../domain/entities/service_item_entity.dart';
import '../../../../assets/presentation/states/status.dart';

class ServiceItemsState {
  final Status status;
  final List<ServiceItemEntity> items;
  final String? error;

  const ServiceItemsState({
    this.status = Status.initial,
    this.items = const [],
    this.error,
  });

  ServiceItemsState copyWith({Status? status, List<ServiceItemEntity>? items, String? error}) {
    return ServiceItemsState(
      status: status ?? this.status,
      items: items ?? this.items,
      error: error ?? this.error,
    );
  }
}