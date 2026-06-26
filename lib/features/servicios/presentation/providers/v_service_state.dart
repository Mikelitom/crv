import '../../domain/entities/v_service_order.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart'; // Tu enum de estado

// Si usas Freezed, puedes usar @freezed, si no, una clase simple:
class ServiceListState {
  final Status status;
  final List<ServiceOrder> services;
  final String? error;

  const ServiceListState({
    this.status = Status.initial,
    this.services = const [],
    this.error,
  });

  ServiceListState copyWith({
    Status? status,
    List<ServiceOrder>? services,
    String? error,
  }) {
    return ServiceListState(
      status: status ?? this.status,
      services: services ?? this.services,
      error: error,
    );
  }
}