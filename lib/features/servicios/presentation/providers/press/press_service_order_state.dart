// lib/features/servicios/presentation/providers/press_service_order_state.dart
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
import 'package:crv_reprosisa/features/servicios/domain/entities/press_service_order_entity.dart';


class PressServiceOrderState {
  final Status status;
  final List<PressServiceOrderEntity> orders;
  final String? error;

  const PressServiceOrderState({
    this.status = Status.initial,
    this.orders = const [],
    this.error,
  });

  PressServiceOrderState copyWith({Status? status, List<PressServiceOrderEntity>? orders, String? error}) {
    return PressServiceOrderState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      error: error ?? this.error,
    );
  }
}