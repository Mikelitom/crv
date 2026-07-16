import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';

class StartPressServiceState {
  final Status status;
  final String? error;

  const StartPressServiceState({this.status = Status.initial, this.error});

  StartPressServiceState copyWith({Status? status, String? error}) {
    return StartPressServiceState(
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}
