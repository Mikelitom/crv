import 'package:crv_reprosisa/features/activos/presentation/states/status.dart';

class CreateClientState {
  final Status status;
  final String? error;

  const CreateClientState({this.status = Status.initial, this.error});

  CreateClientState copyWith({Status? status, String? error}) {
    return CreateClientState(status: status ?? this.status, error: error);
  }
}
