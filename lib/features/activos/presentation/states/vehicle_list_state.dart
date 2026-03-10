import 'package:crv_reprosisa/features/activos/domain/entities/vehicle.dart';

import 'status.dart';

class VehicleListState {
  final Status status;
  final List<Vehicle> vehicle;
  final String? error;

  const VehicleListState({
    this.status = Status.initial,
    this.vehicle = const [],
    this.error,
  });

  VehicleListState copyWith({
    Status? status,
    List<Vehicle>? vehicle,
    String? error,
  }) {
    return VehicleListState(
      status: status ?? this.status,
      vehicle: vehicle ?? this.vehicle,
      error: error,
    );
  }
}
