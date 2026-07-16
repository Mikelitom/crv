// lib/features/servicios/presentation/providers/press_service_order_state.dart
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';
import 'package:crv_reprosisa/features/servicios/data/models/press/press_service_order_model.dart';


class PressServiceOrderState {
  final Status status;
  final List<PressServiceOrderModel> orders;
  final String? error;

  const PressServiceOrderState({
    this.status = Status.initial,
    this.orders = const [],
    this.error,
  });

  PressServiceOrderState copyWith({Status? status, List<PressServiceOrderModel>? orders, String? error}) {
    return PressServiceOrderState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      error: error ?? this.error,
    );
  }
}