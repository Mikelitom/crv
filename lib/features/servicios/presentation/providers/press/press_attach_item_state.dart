import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';

class PressAttachItemState {
  final Status status;
  final String? error;

  const PressAttachItemState({
    this.status = Status.initial, 
    this.error,
  });

  PressAttachItemState copyWith({Status? status, String? error}) {
    return PressAttachItemState(
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}