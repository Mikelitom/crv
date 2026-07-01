// IMPORTANTE: Asegúrate de importar el modelo con V
import 'package:crv_reprosisa/features/servicios/data/models/v_service_order_model.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';

class ServiceListState {
  final Status status;
  final List<ServiceOrderModel> services; // <--- Cambia ServiceOrder a ServiceOrderModelV
  final String? error;

  const ServiceListState({
    this.status = Status.initial,
    this.services = const [],
    this.error,
  });

  ServiceListState copyWith({
    Status? status,
    List<ServiceOrderModel>? services, // <--- Cambia aquí también
    String? error,
  }) {
    return ServiceListState(
      status: status ?? this.status,
      services: services ?? this.services,
      error: error,
    );
  }
}