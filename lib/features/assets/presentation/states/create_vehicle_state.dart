import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';

class CreateVehicleState {
  final Status status;
  final String? error;

  const CreateVehicleState({this.status = Status.initial, this.error});

  CreateVehicleState copyWith({Status? status, String? error}) {
    return CreateVehicleState(status: status ?? this.status, error: error);
  }
}
