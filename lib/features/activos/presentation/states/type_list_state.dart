import 'package:crv_reprosisa/features/activos/domain/entities/vehicle_type.dart';
import 'package:crv_reprosisa/features/activos/presentation/states/status.dart';

class TypeListState {
  final Status status;
  final List<VehicleType> types;
  final String? error;

  const TypeListState({
    this.status = Status.initial,
    this.types = const [],
    this.error,
  });

  TypeListState copyWith({
    Status? status,
    List<VehicleType>? types,
    String? error,
  }) {
    return TypeListState(
      status: status ?? this.status,
      types: types ?? this.types,
      error: error,
    );
  }
}
