import 'package:crv_reprosisa/features/assets/domain/entities/vehicle_history.dart';
import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';

class VehicleHistoryState {
  final Status status;
  final List<VehicleHistory> history;
  final String error;

  const VehicleHistoryState({
    this.status = Status.initial,
    this.history = const [],
    this.error = '',
  });

  VehicleHistoryState copyWith({
    Status? status,
    List<VehicleHistory>? history,
    String? error,
  }) {
    return VehicleHistoryState(
      status: status ?? this.status,
      history: history ?? this.history,
      error: error ?? this.error,
    );
  }
}