import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';

class StartVehicleServiceState {
  final Status status;
  final String? error;

  const StartVehicleServiceState({this.status = Status.initial, this.error});

  StartVehicleServiceState copyWith({Status? status, String? error}) {
    return StartVehicleServiceState(
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}
