import 'package:crv_reprosisa/features/activos/domain/entities/vehicle.dart';

import 'status.dart';

class VehicleListState {
  final Status status;
  final List<Vehicle> vehicles;
  final String? error;

  const VehicleListState({
    this.status = Status.initial,
    this.vehicles = const [],
    this.error,
  });

  VehicleListState copyWith({
    Status? status,
    List<Vehicle>? vehicles,
    String? error,
  }) {
    return VehicleListState(
      status: status ?? this.status,
      vehicles: vehicles ?? this.vehicles,
      error: error,
    );
  }
}
