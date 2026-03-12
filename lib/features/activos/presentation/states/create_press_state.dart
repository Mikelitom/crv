import 'package:crv_reprosisa/features/activos/presentation/states/status.dart';

class CreatePressState {
  final Status status;
  final String? error;

  const CreatePressState({this.status = Status.initial, this.error});

  CreatePressState copyWith({Status? status, String? error}) {
    return CreatePressState(status: status ?? this.status, error: error);
  }
}
