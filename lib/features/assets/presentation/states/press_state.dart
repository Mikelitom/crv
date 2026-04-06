import 'package:crv_reprosisa/features/assets/presentation/states/status.dart';

class PressState {
  final Status status;
  final String? error;
  final String? message;

  const PressState({this.status = Status.initial, this.error, this.message});

  PressState copyWith({
    Status? status,
    String? error,
    String? message,
    bool clearError = false,
    bool clearMessage = false,
  }) {
    return PressState(
      status: status ?? this.status,
      error: clearError ? null : error,
      message: clearMessage ? null : message,
    );
  }
}
