// lib/features/servicios/presentation/providers/press/press_create_order_state.dart
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';

class PressCreateOrderState {
  final Status status;
  final String? error;
  final String? orderNumber;

  const PressCreateOrderState({
    this.status = Status.initial,
    this.error,
    this.orderNumber,
  });

  PressCreateOrderState copyWith({
    Status? status,
    String? error,
    String? orderNumber,
  }) {
    return PressCreateOrderState(
      status: status ?? this.status,
      error: error ?? this.error,
      orderNumber: orderNumber ?? this.orderNumber,
    );
  }
}